import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/models.dart';

/// Persists and retrieves each signed-in user's match history in Firestore,
/// under: users/{uid}/history/{matchId}
class HistoryService {
  final FirebaseFirestore _firestore;

  HistoryService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _historyCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('history');
  }

  Future<void> saveMatch({
    required String uid,
    required GameMode mode,
    required GameStatus result,
    required Player humanPlayer,
  }) async {
    final record = MatchRecord(
      id: '', // Firestore assigns the doc ID; unused when writing.
      mode: mode,
      result: result,
      humanPlayer: humanPlayer,
      playedAt: DateTime.now(),
    );

    await _historyCollection(uid).add(record.toMap());
  }

  /// Live-updating stream of the most recent matches, newest first.
  Stream<List<MatchRecord>> watchHistory(String uid, {int limit = 50}) {
    return _historyCollection(uid)
        .orderBy('playedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MatchRecord.fromMap(doc.id, doc.data()))
            .toList());
  }

  /// One-off summary counts (wins/losses/draws) computed from the full
  /// history — fine at this scale; move to a Cloud Function aggregate if
  /// history grows very large.
  Future<HistorySummary> getSummary(String uid) async {
    final snapshot = await _historyCollection(uid).get();
    int wins = 0, losses = 0, draws = 0;

    for (final doc in snapshot.docs) {
      final record = MatchRecord.fromMap(doc.id, doc.data());
      if (record.result == GameStatus.draw) {
        draws++;
      } else if (record.humanWon) {
        wins++;
      } else {
        losses++;
      }
    }

    return HistorySummary(wins: wins, losses: losses, draws: draws);
  }
}

class HistorySummary {
  final int wins;
  final int losses;
  final int draws;

  const HistorySummary({required this.wins, required this.losses, required this.draws});

  int get totalGames => wins + losses + draws;
}
