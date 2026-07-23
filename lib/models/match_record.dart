import 'package:cloud_firestore/cloud_firestore.dart';

import 'game_mode.dart';
import 'game_status.dart';
import 'player.dart';

/// One completed round, saved to Firestore under the signed-in user's
/// play history subcollection.
class MatchRecord {
  final String id;
  final GameMode mode;
  final GameStatus result;
  final Player humanPlayer;
  final DateTime playedAt;

  MatchRecord({
    required this.id,
    required this.mode,
    required this.result,
    required this.humanPlayer,
    required this.playedAt,
  });

  /// Whether the signed-in human player won this match (always false for a
  /// draw, and — in 2-player mode — reflects whichever mark was recorded as
  /// "the human," i.e. the device owner, typically Player.x).
  bool get humanWon => result.winner == humanPlayer;

  Map<String, dynamic> toMap() {
    return {
      'mode': mode.name,
      'result': result.name,
      'humanPlayer': humanPlayer.name,
      'playedAt': Timestamp.fromDate(playedAt),
    };
  }

  factory MatchRecord.fromMap(String id, Map<String, dynamic> map) {
    return MatchRecord(
      id: id,
      mode: GameMode.values.firstWhere(
        (m) => m.name == map['mode'],
        orElse: () => GameMode.twoPlayer,
      ),
      result: GameStatus.values.firstWhere(
        (s) => s.name == map['result'],
        orElse: () => GameStatus.draw,
      ),
      humanPlayer: Player.values.firstWhere(
        (p) => p.name == map['humanPlayer'],
        orElse: () => Player.x,
      ),
      playedAt: (map['playedAt'] as Timestamp).toDate(),
    );
  }
}
