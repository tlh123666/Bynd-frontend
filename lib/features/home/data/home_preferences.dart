import 'package:shared_preferences/shared_preferences.dart';
import '../domain/home_models.dart';

abstract interface class HomePreferences {
  Future<int> photo();
  Future<void> savePhoto(int photo);
  Future<List<HomeSignal>> signals(String user);
  Future<void> saveSignals(String user, List<HomeSignal> signals);
}

class LocalHomePreferences implements HomePreferences {
  @override
  Future<int> photo() async =>
      ((await SharedPreferences.getInstance()).getInt('home.photo.v1') ?? 1)
          .clamp(0, 25);
  @override
  Future<void> savePhoto(int photo) async {
    if (!await (await SharedPreferences.getInstance()).setInt(
      'home.photo.v1',
      photo,
    )) {
      throw StateError('Photo preference was not saved');
    }
  }

  @override
  Future<List<HomeSignal>> signals(String user) async {
    final names = (await SharedPreferences.getInstance()).getStringList(
      'home.signals.v1.$user',
    );
    final valid = names == null
        ? <HomeSignal>[]
        : [
            for (final name in names)
              for (final signal in HomeSignal.values)
                if (signal.name == name) signal,
          ];
    return valid.length == 6 && valid.toSet().length == 6
        ? valid
        : HomeSignal.defaults;
  }

  @override
  Future<void> saveSignals(String user, List<HomeSignal> signals) async {
    if (!await (await SharedPreferences.getInstance()).setStringList(
      'home.signals.v1.$user',
      signals.map((s) => s.name).toList(),
    )) {
      throw StateError('Signal preferences were not saved');
    }
  }
}
