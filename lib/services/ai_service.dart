import '../core/constants/constants.dart';
import '../models/models.dart';

/// Unbeatable computer opponent using the minimax algorithm with alpha-beta
/// pruning. Given a board and which mark the computer plays, returns the
/// index of the best move.
class AiService {
  /// [board] is a flattened 9-cell list. [aiPlayer] is the mark the computer
  /// plays as; the human is assumed to play [aiPlayer.opponent].
  int getBestMove(List<Player> board, Player aiPlayer) {
    final humanPlayer = aiPlayer.opponent;
    int bestScore = -1000;
    int bestMove = -1;

    for (int i = 0; i < board.length; i++) {
      if (board[i] != Player.none) continue;
      board[i] = aiPlayer;
      final score = _minimax(board, 0, false, aiPlayer, humanPlayer);
      board[i] = Player.none;

      if (score > bestScore) {
        bestScore = score;
        bestMove = i;
      }
    }

    return bestMove;
  }

  int _minimax(
    List<Player> board,
    int depth,
    bool isMaximizing,
    Player aiPlayer,
    Player humanPlayer,
  ) {
    final winner = _checkWinner(board);
    if (winner == aiPlayer) return 10 - depth;
    if (winner == humanPlayer) return depth - 10;
    if (_isBoardFull(board)) return 0;

    if (isMaximizing) {
      int best = -1000;
      for (int i = 0; i < board.length; i++) {
        if (board[i] != Player.none) continue;
        board[i] = aiPlayer;
        best = _max(best, _minimax(board, depth + 1, false, aiPlayer, humanPlayer));
        board[i] = Player.none;
      }
      return best;
    } else {
      int best = 1000;
      for (int i = 0; i < board.length; i++) {
        if (board[i] != Player.none) continue;
        board[i] = humanPlayer;
        best = _min(best, _minimax(board, depth + 1, true, aiPlayer, humanPlayer));
        board[i] = Player.none;
      }
      return best;
    }
  }

  Player? _checkWinner(List<Player> board) {
    for (final line in AppConstants.winningLines) {
      final a = board[line[0]];
      final b = board[line[1]];
      final c = board[line[2]];
      if (a != Player.none && a == b && b == c) return a;
    }
    return null;
  }

  bool _isBoardFull(List<Player> board) {
    return board.every((cell) => cell != Player.none);
  }

  int _max(int a, int b) => a > b ? a : b;
  int _min(int a, int b) => a < b ? a : b;
}
