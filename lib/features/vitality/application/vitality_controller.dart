import 'package:flutter/foundation.dart';
import '../../../core/auth/auth_session.dart';
import '../domain/vitality_models.dart';

class VitalityController extends ChangeNotifier {
  VitalityController({
    required this.repository,
    required this.kind,
    required this.date,
    AuthSession? session,
  }) : _session = session,
       _token = session?.accessToken {
    session?.addListener(_accountChanged);
  }
  final VitalityRepository repository;
  final VitalityKind kind;
  final AuthSession? _session;
  final String? _token;
  DateTime date;
  VitalitySnapshot? snapshot;
  Object? error;
  bool loading = false,
      saving = false,
      accountChanged = false,
      _disposed = false;
  int _generation = 0;
  void _accountChanged() {
    if (_session?.accessToken != _token) {
      accountChanged = true;
      _generation++;
      snapshot = null;
      loading = false;
      _emit();
    }
  }

  Future<void> load({DateTime? date}) async {
    if (accountChanged || saving || _disposed) return;
    if (date != null) this.date = date;
    final generation = ++_generation;
    loading = true;
    error = null;
    snapshot = null;
    _emit();
    try {
      final data = await repository.load(kind, this.date);
      if (_live(generation)) snapshot = data;
    } catch (e) {
      if (_live(generation)) error = e;
    } finally {
      if (_live(generation)) {
        loading = false;
        _emit();
      }
    }
  }

  Future<bool> save(VitalityPreferences p) async {
    if (saving || accountChanged || _disposed) return false;
    final generation = _generation;
    saving = true;
    error = null;
    _emit();
    try {
      await repository.savePreferences(p);
      if (!_live(generation)) return false;
      saving = false;
      await load();
      return !accountChanged;
    } catch (e) {
      if (_live(generation)) error = e;
      return false;
    } finally {
      if (!_disposed) {
        saving = false;
        _emit();
      }
    }
  }

  bool _live(int generation) =>
      !_disposed && !accountChanged && generation == _generation;
  void _emit() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    _session?.removeListener(_accountChanged);
    repository.dispose();
    super.dispose();
  }
}
