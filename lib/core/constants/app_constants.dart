class AppConstants {
  AppConstants._();

  static const int boardSize = 3;
  static const int cellCount = boardSize * boardSize;

  // All possible winning lines as index triplets on a flattened 3x3 board.
  static const List<List<int>> winningLines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  static const String keyThemeMode = 'ttt_theme_mode';

  static const Duration markAnimationDuration = Duration(milliseconds: 250);
  static const Duration themeAnimationDuration = Duration(milliseconds: 350);
  static const Duration aiMoveDelay = Duration(milliseconds: 550);
  static const Duration winLineAnimationDuration = Duration(milliseconds: 500);
}
