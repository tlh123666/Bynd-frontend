import 'home_models.dart';

abstract interface class HomeRepository {
  Future<HomeSnapshot> fetch(DateTime date, String locale);
  Future<List<HomeHistoryPoint>> history(
    HomeSignal signal,
    DateTime date,
    String locale,
  );
  Future<List<HomeDiaryEvent>> diary(DateTime date, String locale);
  Future<void> saveDiary(
    DateTime date,
    String locale, {
    required String category,
    required String label,
    required String note,
  });
  void dispose();
}
