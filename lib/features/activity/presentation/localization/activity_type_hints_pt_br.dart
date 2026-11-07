import '../../domain/models/activity_type.dart';

/// 与网页原型 `descMod()` 对齐的活动说明。
///
/// 这里只描述原型会展示的页面能力，不代表 GPS 或其他传感器已经可用。
String activityTypeHintPtBr(ActivityType type) {
  if (type.id == 'hyrox') return '16 etapas da prova';
  if (type.id == 'triatlo' || type.id == 'duatlo') {
    return '5 etapas da prova';
  }
  if (type.id == 'natacao') return 'piscina e ritmo';
  if (type.hasRouteToggle) return 'com GPS';
  if (type.usesStrengthSets) return 'séries e peso';
  if (_roundBasedActivities.contains(type.id)) return 'rounds';

  final gameParts = _gameParts[type.id];
  if (gameParts != null) return gameParts;
  if (type.livePageFamily == ActivityLivePageFamily.stress) {
    return 'coração sem movimento';
  }
  if (type.category == ActivityCategory.sports ||
      type.category == ActivityCategory.combat) {
    return 'tempo de jogo';
  }
  if (_machineActivities.contains(type.id)) return 'distância da máquina';
  if (_intervalActivities.contains(type.id)) return 'intervalos';
  if (type.category == ActivityCategory.mindBody &&
      !_movementActivities.contains(type.id)) {
    return 'respiração e calma';
  }
  if (type.category == ActivityCategory.other) return 'passos e movimento';
  return 'tempo e coração';
}

const _roundBasedActivities = {
  'muay-thai',
  'mma',
  'karate',
  'taekwondo',
  'judo',
  'boxe',
  'kickboxing',
  'jiu-jitsu',
  'luta-olimpica',
  'artes-marciais',
  'box-fitness',
};

const _gameParts = {
  'futsal': '2 tempos',
  'futebol-society': '2 tempos',
  'futebol': '2 tempos',
  'basquete': '4 quartos',
  'handebol': '2 tempos',
  'rugby': '2 tempos',
  'futebol-americano': '4 quartos',
  'futebol-australiano': '4 quartos',
  'futebol-gaelico': '2 tempos',
  'hurling': '2 tempos',
  'hoquei-grama': '4 quartos',
  'hoquei-gelo': '3 períodos',
  'lacrosse': '4 quartos',
  'netball': '4 quartos',
  'ultimate': '2 tempos',
  'polo': '4 chukkers',
  'polo-aquatico': '4 quartos',
};

const _machineActivities = {
  'esteira',
  'spinning',
  'assault-bike',
  'eliptico',
  'remo-ergometro',
  'ski-erg',
  'escada',
  'degraus',
};

const _intervalActivities = {'hiit', 'pular-corda'};
const _movementActivities = {'zumba', 'danca', 'barre', 'hidroginastica'};
