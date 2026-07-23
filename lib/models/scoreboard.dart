/// Tracks cumulative wins/draws for the current play session (resets when
/// the app restarts — not persisted, purely in-memory scoreboard).
class Scoreboard {
  final int xWins;
  final int oWins;
  final int draws;

  const Scoreboard({this.xWins = 0, this.oWins = 0, this.draws = 0});

  Scoreboard copyWith({int? xWins, int? oWins, int? draws}) {
    return Scoreboard(
      xWins: xWins ?? this.xWins,
      oWins: oWins ?? this.oWins,
      draws: draws ?? this.draws,
    );
  }
}
