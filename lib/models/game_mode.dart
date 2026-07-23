/// Which way the game is being played.
enum GameMode {
  /// Two people share the same device, taking turns.
  twoPlayer,

  /// One person plays against the computer (unbeatable minimax AI).
  vsComputer;

  String get label {
    switch (this) {
      case GameMode.twoPlayer:
        return '2 Players';
      case GameMode.vsComputer:
        return 'Vs Computer';
    }
  }

  String get description {
    switch (this) {
      case GameMode.twoPlayer:
        return 'Take turns on the same device';
      case GameMode.vsComputer:
        return 'Challenge the unbeaten AI';
    }
  }
}
