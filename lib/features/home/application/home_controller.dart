import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/auth/auth_session.dart';
import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import '../data/demo_home_repository.dart';
import '../data/remote_home_repository.dart';
import '../data/home_preferences.dart';
import '../domain/home_models.dart';
import '../domain/home_repository.dart';

class HomeController extends ChangeNotifier {
  HomeController({
    required this.repository,
    required this.preferences,
    this.session,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now,
       _sessionToken = session?.accessToken {
    session?.addListener(_sessionChanged);
  }
  final HomeRepository repository;
  bool get demoData => repository is DemoHomeRepository;
  final HomePreferences preferences;
  final AuthSession? session;
  final DateTime Function() _clock;
  String? _sessionToken;
  int accountRevision = 0;
  HomeSnapshot? snapshot;
  ApiException? error;
  bool loading = false, _disposed = false, _initialized = false;
  int _request = 0;
  int day = 0, photo = 1;
  String locale = 'pt-BR';
  List<HomeSignal> signals = HomeSignal.defaults;
  DateTime get date => homeDay(_clock(), day);
  DateTime get now => _clock();

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    unawaited(_restorePhoto());
    await reload();
  }

  Future<void> _restorePhoto() async {
    try {
      final value = await preferences.photo();
      if (!_disposed) {
        photo = value;
        notifyListeners();
      }
    } catch (_) {
      /* Preferences cannot block reading health data. */
    }
  }

  void _sessionChanged() {
    if (_sessionToken == session?.accessToken) return;
    _sessionToken = session?.accessToken;
    accountRevision++;
    // Clear private data immediately; an old request must never populate a
    // different account or reappear after sign-out.
    snapshot = null;
    signals = HomeSignal.defaults;
    unawaited(reload());
  }

  Future<void> setDay(int value) async {
    if (value < 0 || value >= 30 || value == day) return;
    day = value;
    snapshot = null;
    await reload();
  }

  Future<void> setLocale(String value) async {
    if (locale == value) return;
    locale = value;
    if (_initialized) {
      snapshot = null;
      await reload();
    }
  }

  Future<void> reload() async {
    final request = ++_request;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final result = await repository.fetch(date, locale);
      List<HomeSignal> saved;
      try {
        saved = await preferences.signals(
          result.userId.isEmpty ? 'anonymous' : result.userId,
        );
      } catch (_) {
        saved = HomeSignal.defaults;
      }
      if (_disposed || request != _request) return;
      snapshot = result;
      signals = List.unmodifiable(saved);
    } catch (e) {
      if (_disposed || request != _request) return;
      error = e is ApiException
          ? e
          : const ApiException('Não foi possível carregar a Home.');
      snapshot = null;
    } finally {
      if (!_disposed && request == _request) {
        loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> nextPhoto() async {
    final next = (photo + 1) % 26;
    await preferences.savePhoto(next);
    if (_disposed) return;
    photo = next;
    notifyListeners();
  }

  Future<void> saveSignals(List<HomeSignal> selected) async {
    if (selected.length != 6 || selected.toSet().length != 6) {
      throw ArgumentError('Home requires exactly six distinct signals');
    }
    final user = snapshot?.userId ?? '';
    if (user.isEmpty) throw StateError('Account is not available');
    await preferences.saveSignals(user, selected);
    if (_disposed || snapshot?.userId != user) return;
    signals = List.unmodifiable(selected);
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    ++_request;
    session?.removeListener(_sessionChanged);
    repository.dispose();
    super.dispose();
  }
}

abstract final class HomeRuntime {
  static HomeController create({AppConfig? config}) {
    final settings = config ?? AppConfig.current;
    return HomeController(
      repository: settings.demoData
          ? DemoHomeRepository()
          : RemoteHomeRepository(ApiClient.configured(config: settings)),
      preferences: LocalHomePreferences(),
      session: settings.demoData ? null : AuthSession.instance,
    );
  }
}
