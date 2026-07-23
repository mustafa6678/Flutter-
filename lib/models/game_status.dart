import 'player.dart';

/// The current outcome state of a match.
enum GameStatus {
  playing,
  xWon,
  oWon,
  draw;

  bool get isOver => this != GameStatus.playing;

  Player? get winner {
    switch (this) {
      case GameStatus.xWon:
        return Player.x;
      case GameStatus.oWon:
        return Player.o;
      case GameStatus.playing:
      case GameStatus.draw:
        return null;
    }
  }
}
