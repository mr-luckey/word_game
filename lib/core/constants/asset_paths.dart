class AssetPaths {
  AssetPaths._();

  static const splashBg = 'assets/images/splash/travel_bg.jpg';
  static const wordLogoLottie = 'assets/animations/word_logo.json';
  static const confettiLottie = 'assets/animations/confetti.json';
  static const starBurstLottie = 'assets/animations/star_burst.json';
  static const wordFoundLottie = 'assets/animations/word_found.json';

  static String themeImage(String fileName) => 'assets/images/themes/$fileName';

  static const wordFoundSfx = 'audio/word_found.wav';
  static const levelCompleteSfx = 'audio/level_complete.wav';
  static const wrongSfx = 'audio/wrong.wav';
  static const bgMusic = 'audio/bg_music.wav';
}
