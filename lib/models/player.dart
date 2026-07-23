/// Represents the mark occupying a cell, or an empty cell.
enum Player {
  x,
  o,
  none;

  bool get isNone => this == Player.none;

  /// The other player's mark — used to alternate turns.
  Player get opponent {
    switch (this) {
      case Player.x:
        return Player.o;
      case Player.o:
        return Player.x;
      case Player.none:
        return Player.none;
    }
  }

  String get label {
    switch (this) {
      case Player.x:
        return 'X';
      case Player.o:
        return 'O';
      case Player.none:
        return '';
    }
  }
}
