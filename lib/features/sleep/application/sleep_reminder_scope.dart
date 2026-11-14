import 'dart:async';
import 'package:flutter/widgets.dart';
import '../../../core/auth/auth_session.dart';
import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import '../data/remote_sleep_repository.dart';
import 'sleep_reminders.dart';

/// Follows the same lifetime as authenticated Device/Atlas services. Startup
/// restores cloud reminders; signing out cancels only bedtime notifications.
class SleepReminderScope extends StatefulWidget {
  const SleepReminderScope({
    required this.config,
    required this.child,
    this.authenticated = true,
    super.key,
  });
  final AppConfig config;
  final Widget child;
  final bool authenticated;
  @override
  State<SleepReminderScope> createState() => _SleepReminderScopeState();
}

class _SleepReminderScopeState extends State<SleepReminderScope> {
  RemoteSleepRepository? _repository;
  String? _locale;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.authenticated) {
      if (_locale != 'anonymous' &&
          !widget.config.demoData &&
          SleepReminders.instance.supported) {
        _locale = 'anonymous';
        unawaited(SleepReminders.instance.clear().catchError((Object _) {}));
      }
      return;
    }
    final locale = Localizations.localeOf(context).languageCode;
    if (_locale == locale ||
        widget.config.demoData ||
        !SleepReminders.instance.supported) {
      return;
    }
    _locale = locale;
    _repository ??= RemoteSleepRepository(
      ApiClient.configured(config: widget.config),
      session: AuthSession.instance,
    );
    unawaited(_sync(locale));
  }

  Future<void> _sync(String locale) async {
    try {
      final plans = await _repository!.plans();
      if (mounted) {
        await SleepReminders.instance.apply(plans, portuguese: locale == 'pt');
      }
    } catch (_) {
      /* The sleep planner exposes errors and allows an explicit retry. */
    }
  }

  @override
  void dispose() {
    _repository?.dispose();
    if (!widget.config.demoData && SleepReminders.instance.supported) {
      unawaited(SleepReminders.instance.clear().catchError((Object _) {}));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
