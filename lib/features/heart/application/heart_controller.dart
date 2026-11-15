import 'package:flutter/foundation.dart';
import '../../../core/auth/auth_session.dart';
import '../domain/heart_models.dart';

class HeartController extends ChangeNotifier {
  HeartController({
    required this.repository,
    required this.date,
    AuthSession? session,
  }) : _session = session,
       _token = session?.accessToken {
    session?.addListener(_account);
  }
  final HeartRepository repository;
  final AuthSession? _session;
  final String? _token;
  DateTime date;
  HeartSnapshot? snapshot;
  Object? error;
  bool loading = false,
      saving = false,
      accountChanged = false,
      _disposed = false;
  int _request = 0;
  void _account() {
    if (_session?.accessToken != _token) {
      accountChanged = true;
      _request++;
      snapshot = null;
      loading = false;
      _emit();
    }
  }

  bool _live(int id) => !_disposed && !accountChanged && id == _request;
  void _emit() {
    if (!_disposed) notifyListeners();
  }

  Future<void> load({DateTime? date, String locale = 'pt-BR'}) async {
    if (accountChanged || saving || _disposed) return;
    if (date != null) this.date = date;
    final id = ++_request;
    loading = true;
    error = null;
    snapshot = null;
    _emit();
    try {
      final next = await repository.load(this.date, locale);
      if (_live(id)) snapshot = next;
    } catch (e) {
      if (_live(id)) error = e;
    } finally {
      if (_live(id)) {
        loading = false;
        _emit();
      }
    }
  }

  Future<bool> savePreferences(HeartPreferences p) async {
    if (saving || accountChanged || snapshot == null) return false;
    final id = _request;
    saving = true;
    error = null;
    _emit();
    try {
      final saved = await repository.savePreferences(p);
      if (!_live(id)) return false;
      snapshot = snapshot!.withPreferences(saved);
      return true;
    } catch (e) {
      if (_live(id)) error = e;
      return false;
    } finally {
      if (!_disposed) {
        saving = false;
        _emit();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _request++;
    _session?.removeListener(_account);
    repository.dispose();
    super.dispose();
  }
}
