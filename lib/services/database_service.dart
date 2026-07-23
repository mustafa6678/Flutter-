import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../models/game_result.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveGameResult(GameResult result) async {
    await _db.collection('history').add(result.toMap());
  }

  Stream<List<GameResult>> getHistory(String userId) {
    return _db
        .collection('history')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GameResult.fromMap(doc.id, doc.data()))
            .toList());
  }
}
