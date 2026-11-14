import 'package:flutter/foundation.dart';
import '../../../core/auth/auth_session.dart';
import '../domain/sleep_models.dart';

class SleepController extends ChangeNotifier {
  SleepController({
    required this.repository,
    required this.date,
    AuthSession? session,
  }) : _session = session,
       _token = session?.accessToken {
    session?.addListener(_accountChanged);
  }
  final SleepRepository repository;
  final AuthSession? _session;
  final String? _token;
  DateTime date;
  SleepSnapshot? snapshot;
  Object? error;
  bool loading = false,
      saving = false,
      accountChanged = false,
      _disposed = false;
  int _revision = 0;
  void _accountChanged() {
    if (_token != _session?.accessToken) {
      accountChanged = true;
      _revision++;
      snapshot = null;
      loading = false;
      _emit();
    }
  }

  Future<void> load({DateTime? date, String locale = 'pt-BR'}) async {
    if (accountChanged || saving) return;
    if (date != null) this.date = date;
    final revision = ++_revision;
    loading = true;
    error = null;
    snapshot = null;
    _emit();
    try {
      final data = await repository.load(this.date, locale);
      if (_live(revision)) snapshot = data;
    } catch (e) {
      if (_live(revision)) error = e;
    } finally {
      if (_live(revision)) {
        loading = false;
        _emit();
      }
    }
  }

  Future<bool> savePreferences(SleepPreferences p) async {
    if (saving || accountChanged || snapshot == null) return false;
    final revision = _revision;
    saving = true;
    error = null;
    _emit();
    try {
      final saved = await repository.savePreferences(p);
      if (!_live(revision)) return false;
      snapshot = snapshot!.withPreferences(saved);
      return true;
    } catch (e) {
      if (_live(revision)) error = e;
      return false;
    } finally {
      if (!_disposed) {
        saving = false;
        _emit();
      }
    }
  }

  bool _live(int r) => !_disposed && !accountChanged && r == _revision;
  void _emit() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _revision++;
    _session?.removeListener(_accountChanged);
    repository.dispose();
    super.dispose();
  }
}
