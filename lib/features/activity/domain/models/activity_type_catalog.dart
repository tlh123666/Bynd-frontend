import 'activity_type.dart';

/// 对照网页 `treinos.js` 的 140 个稳定活动 ID 与实时页分支。
///
/// 此目录记录原型的呈现能力，不代表传感器授权、数据可用或算法已被产品确认。
abstract final class ActivityTypeCatalog {
  static const List<ActivityType> all = [
    // 有氧活动
    ActivityType(
      id: 'corrida',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'caminhada',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'ciclismo',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'mountain-bike',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'spinning',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'assault-bike',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'trilha',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'eliptico',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'escada',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'degraus',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'esteira',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'corrida-trilha',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'remo-ergometro',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'ski-erg',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'pular-corda',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'hiit',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'atletismo',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'corrida-obstaculos',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'duatlo',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.eventStages,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'triatlo',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.eventStages,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'patins',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'patinacao-gelo',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'esqui',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'esqui-cross',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'snowboard',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'carrinho-corrida',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'parkour',
      category: ActivityCategory.cardio,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    // 力量类活动
    ActivityType(
      id: 'crossfit',
      category: ActivityCategory.strength,
      livePageFamily: ActivityLivePageFamily.strength,
      usesStrengthSets: true,
    ),
    ActivityType(
      id: 'calistenia',
      category: ActivityCategory.strength,
      livePageFamily: ActivityLivePageFamily.strength,
      usesStrengthSets: true,
    ),
    ActivityType(
      id: 'musculacao',
      category: ActivityCategory.strength,
      livePageFamily: ActivityLivePageFamily.strength,
      usesStrengthSets: true,
    ),
    ActivityType(
      id: 'powerlifting',
      category: ActivityCategory.strength,
      livePageFamily: ActivityLivePageFamily.strength,
      usesStrengthSets: true,
    ),
    ActivityType(
      id: 'funcional',
      category: ActivityCategory.strength,
      livePageFamily: ActivityLivePageFamily.strength,
      usesStrengthSets: true,
    ),
    ActivityType(
      id: 'f45',
      category: ActivityCategory.strength,
      livePageFamily: ActivityLivePageFamily.strength,
      usesStrengthSets: true,
    ),
    ActivityType(
      id: 'hyrox',
      category: ActivityCategory.strength,
      livePageFamily: ActivityLivePageFamily.eventStages,
    ),
    ActivityType(
      id: 'treino-militar',
      category: ActivityCategory.strength,
      livePageFamily: ActivityLivePageFamily.overview,
    ),
    ActivityType(
      id: 'kettlebell',
      category: ActivityCategory.strength,
      livePageFamily: ActivityLivePageFamily.strength,
      usesStrengthSets: true,
    ),
    ActivityType(
      id: 'trx',
      category: ActivityCategory.strength,
      livePageFamily: ActivityLivePageFamily.strength,
      usesStrengthSets: true,
    ),
    ActivityType(
      id: 'strongman',
      category: ActivityCategory.strength,
      livePageFamily: ActivityLivePageFamily.strength,
      usesStrengthSets: true,
    ),
    // Barry's 在原型中归入力量分组，但没有组次训练流程。
    ActivityType(
      id: 'barrys',
      category: ActivityCategory.strength,
      livePageFamily: ActivityLivePageFamily.overview,
    ),
    ActivityType(
      id: 'box-fitness',
      category: ActivityCategory.strength,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'ginastica',
      category: ActivityCategory.strength,
      livePageFamily: ActivityLivePageFamily.overview,
    ),
    // 球类与其他运动
    ActivityType(
      id: 'futsal',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'futebol-society',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'futevolei',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'volei-praia',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'beach-tennis',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'futebol',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'basquete',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'volei',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'handebol',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'tenis',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'padel',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'pickleball',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'squash',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'badminton',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'tenis-mesa',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'golfe',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'disc-golf',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'beisebol',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'softbol',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'criquete',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'rugby',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'futebol-americano',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'futebol-australiano',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'futebol-gaelico',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'hurling',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'hoquei-grama',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'hoquei-gelo',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'lacrosse',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'netball',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'ultimate',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'spikeball',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'skate',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'escalada',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'equitacao',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'polo',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'motocross',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'automobilismo',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'paintball',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'esgrima',
      category: ActivityCategory.sports,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    // 格斗活动
    ActivityType(
      id: 'muay-thai',
      category: ActivityCategory.combat,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'mma',
      category: ActivityCategory.combat,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'karate',
      category: ActivityCategory.combat,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'taekwondo',
      category: ActivityCategory.combat,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'judo',
      category: ActivityCategory.combat,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'capoeira',
      category: ActivityCategory.combat,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'boxe',
      category: ActivityCategory.combat,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'kickboxing',
      category: ActivityCategory.combat,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'jiu-jitsu',
      category: ActivityCategory.combat,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'luta-olimpica',
      category: ActivityCategory.combat,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    ActivityType(
      id: 'artes-marciais',
      category: ActivityCategory.combat,
      livePageFamily: ActivityLivePageFamily.match,
    ),
    // 水上活动
    ActivityType(
      id: 'natacao',
      category: ActivityCategory.aquatic,
      livePageFamily: ActivityLivePageFamily.pool,
    ),
    ActivityType(
      id: 'remo',
      category: ActivityCategory.aquatic,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'natacao-aberta',
      category: ActivityCategory.aquatic,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'caiaque',
      category: ActivityCategory.aquatic,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'stand-up',
      category: ActivityCategory.aquatic,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'surfe',
      category: ActivityCategory.aquatic,
      livePageFamily: ActivityLivePageFamily.overview,
    ),
    ActivityType(
      id: 'kitesurfe',
      category: ActivityCategory.aquatic,
      livePageFamily: ActivityLivePageFamily.overview,
    ),
    ActivityType(
      id: 'wakeboard',
      category: ActivityCategory.aquatic,
      livePageFamily: ActivityLivePageFamily.overview,
    ),
    ActivityType(
      id: 'esqui-aquatico',
      category: ActivityCategory.aquatic,
      livePageFamily: ActivityLivePageFamily.overview,
    ),
    ActivityType(
      id: 'vela',
      category: ActivityCategory.aquatic,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'mergulho',
      category: ActivityCategory.aquatic,
      livePageFamily: ActivityLivePageFamily.overview,
    ),
    ActivityType(
      id: 'polo-aquatico',
      category: ActivityCategory.aquatic,
      livePageFamily: ActivityLivePageFamily.overview,
    ),
    // 身心活动
    ActivityType(
      id: 'hidroginastica',
      category: ActivityCategory.mindBody,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'zumba',
      category: ActivityCategory.mindBody,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'tai-chi',
      category: ActivityCategory.mindBody,
      livePageFamily: ActivityLivePageFamily.calm,
    ),
    ActivityType(
      id: 'respiracao',
      category: ActivityCategory.mindBody,
      livePageFamily: ActivityLivePageFamily.calm,
    ),
    ActivityType(
      id: 'yoga',
      category: ActivityCategory.mindBody,
      livePageFamily: ActivityLivePageFamily.calm,
    ),
    ActivityType(
      id: 'yoga-quente',
      category: ActivityCategory.mindBody,
      livePageFamily: ActivityLivePageFamily.calm,
    ),
    ActivityType(
      id: 'pilates',
      category: ActivityCategory.mindBody,
      livePageFamily: ActivityLivePageFamily.calm,
    ),
    ActivityType(
      id: 'barre',
      category: ActivityCategory.mindBody,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'danca',
      category: ActivityCategory.mindBody,
      livePageFamily: ActivityLivePageFamily.cardio,
    ),
    ActivityType(
      id: 'alongamento',
      category: ActivityCategory.mindBody,
      livePageFamily: ActivityLivePageFamily.calm,
    ),
    ActivityType(
      id: 'meditacao',
      category: ActivityCategory.mindBody,
      livePageFamily: ActivityLivePageFamily.calm,
    ),
    // 恢复活动
    ActivityType(
      id: 'fisioterapia',
      category: ActivityCategory.recovery,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    ActivityType(
      id: 'liberacao',
      category: ActivityCategory.recovery,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    ActivityType(
      id: 'sauna',
      category: ActivityCategory.recovery,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    ActivityType(
      id: 'banho-gelo',
      category: ActivityCategory.recovery,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    ActivityType(
      id: 'massagem',
      category: ActivityCategory.recovery,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    ActivityType(
      id: 'pistola-massagem',
      category: ActivityCategory.recovery,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    ActivityType(
      id: 'botas-compressao',
      category: ActivityCategory.recovery,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    // 其他日常活动
    ActivityType(
      id: 'passear-cao',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'carrinho-bebe',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'carregar-bebe',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    ActivityType(
      id: 'brincar-filhos',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    ActivityType(
      id: 'trajeto',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'jardinagem',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    ActivityType(
      id: 'limpeza',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    ActivityType(
      id: 'cozinhar',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    ActivityType(
      id: 'trabalho-bracal',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    ActivityType(
      id: 'treinar-alguem',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    ActivityType(
      id: 'palco',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.stress,
    ),
    ActivityType(
      id: 'musica',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    ActivityType(
      id: 'falar-publico',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.stress,
    ),
    ActivityType(
      id: 'trabalho-estresse',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.stress,
    ),
    ActivityType(
      id: 'games',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.stress,
    ),
    ActivityType(
      id: 'assistir-esporte',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.stress,
    ),
    ActivityType(
      id: 'circo',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
    ActivityType(
      id: 'cadeira-rodas',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.map,
      hasRouteToggle: true,
    ),
    ActivityType(
      id: 'outro',
      category: ActivityCategory.other,
      livePageFamily: ActivityLivePageFamily.daily,
    ),
  ];

  static final Map<String, ActivityType> byId = Map.unmodifiable(
    <String, ActivityType>{for (final type in all) type.id: type},
  );

  static ActivityType? findById(String id) => byId[id];
}
