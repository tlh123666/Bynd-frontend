import '../../domain/models/activity_type.dart';
import '../../domain/models/activity_type_catalog.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'activity_type_hints_pt_br.dart';
import 'activity_type_names_pt_br.dart';

/// 通过稳定 ID 显示本地化名称；业务层 ID 保持不变。
const Map<String, String> _englishActivityNames = {
  'corrida': 'Running',
  'caminhada': 'Walking',
  'ciclismo': 'Cycling',
  'mountain-bike': 'Mountain biking',
  'spinning': 'Spinning',
  'assault-bike': 'Air bike (assault bike)',
  'trilha': 'Hiking / rucking',
  'eliptico': 'Elliptical',
  'escada': 'Stair climber',
  'degraus': 'Stadium stairs',
  'esteira': 'Treadmill',
  'corrida-trilha': 'Trail running',
  'remo-ergometro': 'Rowing machine',
  'ski-erg': 'SkiErg',
  'pular-corda': 'Jump rope',
  'hiit': 'HIIT',
  'atletismo': 'Track and field',
  'corrida-obstaculos': 'Obstacle running',
  'duatlo': 'Duathlon',
  'triatlo': 'Triathlon',
  'patins': 'Roller skating',
  'patinacao-gelo': 'Ice skating',
  'esqui': 'Skiing',
  'esqui-cross': 'Cross-country skiing',
  'snowboard': 'Snowboarding',
  'carrinho-corrida': 'Jogging stroller run',
  'parkour': 'Parkour',
  'crossfit': 'CrossFit',
  'calistenia': 'Calisthenics',
  'musculacao': 'Strength training',
  'powerlifting': 'Powerlifting',
  'funcional': 'Functional training',
  'f45': 'F45',
  'hyrox': 'HYROX',
  'treino-militar': 'Military training / fitness test',
  'kettlebell': 'Kettlebell',
  'trx': 'TRX / suspension training',
  'strongman': 'Strongman',
  'barrys': "Barry's (run + strength)",
  'box-fitness': 'Boxing fitness',
  'ginastica': 'Artistic gymnastics',
  'futsal': 'Futsal',
  'futebol-society': 'Small-sided soccer',
  'futevolei': 'Footvolley',
  'volei-praia': 'Beach volleyball',
  'beach-tennis': 'Beach tennis',
  'futebol': 'Soccer',
  'basquete': 'Basketball',
  'volei': 'Volleyball',
  'handebol': 'Handball',
  'tenis': 'Tennis',
  'padel': 'Padel',
  'pickleball': 'Pickleball',
  'squash': 'Squash',
  'badminton': 'Badminton',
  'tenis-mesa': 'Table tennis',
  'golfe': 'Golf',
  'disc-golf': 'Disc golf',
  'beisebol': 'Baseball',
  'softbol': 'Softball',
  'criquete': 'Cricket',
  'rugby': 'Rugby',
  'futebol-americano': 'American football',
  'futebol-australiano': 'Australian football',
  'futebol-gaelico': 'Gaelic football',
  'hurling': 'Hurling / camogie',
  'hoquei-grama': 'Field hockey',
  'hoquei-gelo': 'Ice hockey',
  'lacrosse': 'Lacrosse',
  'netball': 'Netball',
  'ultimate': 'Ultimate frisbee',
  'spikeball': 'Spikeball',
  'skate': 'Skateboarding',
  'escalada': 'Rock climbing',
  'equitacao': 'Horse riding',
  'polo': 'Polo',
  'motocross': 'Motocross',
  'automobilismo': 'Motorsport',
  'paintball': 'Paintball',
  'esgrima': 'Fencing',
  'muay-thai': 'Muay Thai',
  'mma': 'MMA',
  'karate': 'Karate',
  'taekwondo': 'Taekwondo',
  'judo': 'Judo',
  'capoeira': 'Capoeira',
  'boxe': 'Boxing',
  'kickboxing': 'Kickboxing',
  'jiu-jitsu': 'Jiu-jitsu',
  'luta-olimpica': 'Wrestling',
  'artes-marciais': 'Martial arts',
  'natacao': 'Swimming',
  'remo': 'Rowing',
  'natacao-aberta': 'Open-water swimming',
  'caiaque': 'Kayaking / canoeing',
  'stand-up': 'Stand-up paddleboarding',
  'surfe': 'Surfing',
  'kitesurfe': 'Kitesurfing',
  'wakeboard': 'Wakeboarding',
  'esqui-aquatico': 'Water skiing',
  'vela': 'Sailing',
  'mergulho': 'Diving',
  'polo-aquatico': 'Water polo',
  'hidroginastica': 'Water aerobics',
  'zumba': 'Zumba / dance fitness',
  'tai-chi': 'Tai chi',
  'respiracao': 'Guided breathing',
  'yoga': 'Yoga',
  'yoga-quente': 'Hot yoga',
  'pilates': 'Pilates',
  'barre': 'Barre',
  'danca': 'Dance',
  'alongamento': 'Stretching',
  'meditacao': 'Meditation',
  'fisioterapia': 'Physical therapy',
  'liberacao': 'Myofascial release',
  'sauna': 'Sauna',
  'banho-gelo': 'Ice bath',
  'massagem': 'Massage',
  'pistola-massagem': 'Massage gun',
  'botas-compressao': 'Compression boots',
  'passear-cao': 'Walking the dog',
  'carrinho-bebe': 'Walking with a stroller',
  'carregar-bebe': 'Carrying a baby',
  'brincar-filhos': 'Playing with kids',
  'trajeto': 'Walking or cycling commute',
  'jardinagem': 'Gardening',
  'limpeza': 'House cleaning',
  'cozinhar': 'Cooking',
  'trabalho-bracal': 'Manual labor',
  'treinar-alguem': 'Coaching',
  'palco': 'Stage performance',
  'musica': 'Playing an instrument',
  'falar-publico': 'Public speaking',
  'trabalho-estresse': 'High-stress work',
  'games': 'Video games',
  'assistir-esporte': 'Watching a game',
  'circo': 'Circus arts',
  'cadeira-rodas': 'Wheelchair activity',
  'outro': 'Other',
};

String activityTypeLocalizedName(ActivityType type, AppLocalizations strings) =>
    strings.localeName == 'en'
    ? (_englishActivityNames[type.id] ?? type.id)
    : (activityTypeNamesPtBr[type.id] ?? type.id);

String activityCategoryLocalizedName(
  ActivityCategory category,
  AppLocalizations strings,
) {
  if (strings.localeName != 'en') {
    return activityCategoryNamesPtBr[category.name] ?? category.name;
  }
  return switch (category) {
    ActivityCategory.cardio => strings.categoryCardio,
    ActivityCategory.strength => strings.categoryStrength,
    ActivityCategory.sports => strings.categorySports,
    ActivityCategory.combat => strings.categoryCombat,
    ActivityCategory.aquatic => strings.categoryAquatic,
    ActivityCategory.mindBody => strings.categoryMindBody,
    ActivityCategory.recovery => strings.categoryRecovery,
    ActivityCategory.other => strings.categoryOther,
  };
}

String activityTypeLocalizedHint(ActivityType type, AppLocalizations strings) {
  if (strings.localeName != 'en') {
    return activityTypeHintPtBr(type);
  }
  if (type.id == 'hyrox') {
    return strings.activityHintHyrox;
  }
  if (type.id == 'triatlo' || type.id == 'duatlo') {
    return strings.activityHintRaceStages;
  }
  if (type.id == 'natacao') {
    return strings.activityHintPoolPace;
  }
  if (type.hasRouteToggle) {
    return strings.activityHintGps;
  }
  if (type.usesStrengthSets) {
    return strings.activityHintSetsWeight;
  }
  if (type.category == ActivityCategory.combat) {
    return strings.activityHintRounds;
  }
  if (type.category == ActivityCategory.sports) {
    return strings.activityHintGameTime;
  }
  if (type.livePageFamily == ActivityLivePageFamily.stress) {
    return strings.activityHintHeartRateNoMovement;
  }
  if (type.category == ActivityCategory.mindBody) {
    return strings.activityHintBreathingCalm;
  }
  if (type.category == ActivityCategory.recovery) {
    return strings.activityHintTimeHeartRate;
  }
  if (type.category == ActivityCategory.other) {
    return strings.activityHintStepsMovement;
  }
  if (type.category == ActivityCategory.cardio) {
    return strings.activityHintMachineDistance;
  }
  return strings.activityHintTimeHeartRate;
}

/// 校验活动目录中的每个稳定 ID 都存在英文名称。
bool get activityEnglishNamesCoverCatalog => _englishActivityNames.keys
    .toSet()
    .containsAll(ActivityTypeCatalog.all.map((type) => type.id));
