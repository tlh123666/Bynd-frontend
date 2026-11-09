abstract final class HomePhotoAssets {
  // Same order and 0/25 sky option as jn in the reference JavaScript.
  static const photos = <String>[
    '',
    'home-canion',
    'home-o-tarde-duna',
    'home-o-textura-areia',
    'home-n-manha-campo',
    'home-n-manha-glaciar',
    'home-n-manha-picos',
    'home-n-noite-deserto',
    'home-n-noite-hora-azul',
    'home-n-tarde-mesas',
    'home-a-ambar-coral',
    'home-a-aneis-respiro',
    'home-a-fios-ouro',
    'home-a-ondas-agua',
    'home-a-veu-violeta',
    'home-a-halo-safira',
    'home-abs-duna-lua',
    'home-abs-seda',
    'home-abs-tinta',
    'home-manha-floresta',
    'home-manha-lago',
    'home-noite-aurora',
    'home-noite-estrelas',
    'home-noite-lua',
    'home-tarde-dunas',
    'home-tarde-praia',
  ];
  static String path(int photo, DateTime now) => photo == 0
      ? 'assets/images/fundo-${now.hour >= 18 || now.hour < 6 ? 'noite' : 'manha'}.jpg'
      : 'assets/images/${photos[photo.clamp(1, 25)]}.webp';
}
