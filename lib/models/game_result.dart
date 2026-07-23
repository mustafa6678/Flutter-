import 'package:cloud_firestore/cloud_firestore.dart';
import 'game_mode.dart';
import 'game_status.dart';

class GameResult {
  final String id;
  final String userId;
  final GameMode mode;
  final GameStatus status;
  final DateTime timestamp;

  GameResult({
    required this.id,
    required this.userId,
    required this.mode,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'mode': mode.name,
      'status': status.name,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  factory GameResult.fromMap(String id, Map<String, dynamic> map) {
    return GameResult(
      id: id,
      userId: map['userId'] ?? '',
      mode: GameMode.values.firstWhere((e) => e.name == map['mode'], orElse: () => GameMode.twoPlayer),
      status: GameStatus.values.firstWhere((e) => e.name == map['status'], orElse: () => GameStatus.draw),
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
