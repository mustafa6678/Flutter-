import 'dart:async';
import 'package:flutter/material.dart';

import '../core/constants/constants.dart';
import '../models/models.dart';
import '../services/services.dart';

/// Owns all Tic Tac Toe game state: the board, whose turn it is, the mode
/// (2-player or vs-computer), the running scoreboard, and win detection.
class GameProvider extends ChangeNotifier {
  final AiService _aiService = AiService();
  final HistoryService? _historyService;

  GameProvider({HistoryService? historyService}) : _historyService = historyService;

  /// Set by the app whenever the signed-in user changes (see main.dart's
  /// ChangeNotifierProxyProvider wiring). Null means no one is signed in —
  /// in that case matches simply aren't saved.
  String? currentUid;

  GameMode mode = GameMode.twoPlayer;
  List<Player> board = List.filled(AppConstants.cellCount, Player.none);
  Player currentPlayer = Player.x;
  GameStatus status = GameStatus.playing;
  List<int>? winningLine;
  Scoreboard scoreboard = const Scoreboard();

  /// In vs-computer mode, which mark the human plays. The computer always
  /// plays the opposite mark. Defaults to the human playing X (goes first).
  Player humanPlayer = Player.x;

  bool _disposed = false;

  bool get isVsComputer => mode == GameMode.vsComputer;
  bool get isGameOver => status.isOver;
  bool get isAiTurn => isVsComputer && currentPlayer != humanPlayer && !isGameOver;

  void startNewMatch({required GameMode selectedMode, Player humanStartsAs = Player.x}) {
    mode = selectedMode;
    humanPlayer = humanStartsAs;
    scoreboard = const Scoreboard();
    _resetBoard();
  }

  void restartRound() {
    _resetBoard();
  }

  void _resetBoard() {
    board = List.filled(AppConstants.cellCount, Player.none);
    currentPlayer = Player.x;
    status = GameStatus.playing;
    winningLine = null;
    notifyListeners();

    if (isAiTurn) {
      _scheduleAiMove();
    }
  }

  void makeMove(int index) {
    if (isGameOver) return;
    if (board[index] != Player.none) return;
    if (isVsComputer && currentPlayer != humanPlayer) return; // not human's turn

    _placeMark(index);

    if (!isGameOver && isAiTurn) {
      _scheduleAiMove();
    }
  }

  void _scheduleAiMove() {
    Future.delayed(AppConstants.aiMoveDelay, () {
      if (_disposed || isGameOver) return;
      final move = _aiService.getBestMove(List.of(board), currentPlayer);
      if (move == -1) return;
      _placeMark(move);
    });
  }

  void _placeMark(int index) {
    board[index] = currentPlayer;
    final result = _evaluateBoard();

    if (result != null) {
      status = result.status;
      winningLine = result.line;
      _updateScoreboard(result.status);
    } else {
      currentPlayer = currentPlayer.opponent;
    }

    notifyListeners();
  }

  void _updateScoreboard(GameStatus finalStatus) {
    switch (finalStatus) {
      case GameStatus.xWon:
        scoreboard = scoreboard.copyWith(xWins: scoreboard.xWins + 1);
        break;
      case GameStatus.oWon:
        scoreboard = scoreboard.copyWith(oWins: scoreboard.oWins + 1);
        break;
      case GameStatus.draw:
        scoreboard = scoreboard.copyWith(draws: scoreboard.draws + 1);
        break;
      case GameStatus.playing:
        break;
    }
    _saveMatchIfSignedIn(finalStatus);
  }

  void _saveMatchIfSignedIn(GameStatus finalStatus) {
    final uid = currentUid;
    if (uid == null || _historyService == null) return;
    // Fire-and-forget: don't block the UI on network. Any failure here is
    // silently swallowed since it must never disrupt gameplay.
    _historyService.saveMatch(
      uid: uid,
      mode: mode,
      result: finalStatus,
      humanPlayer: humanPlayer,
    ).catchError((_) {});
  }

  _EvaluationResult? _evaluateBoard() {
    for (final line in AppConstants.winningLines) {
      final a = board[line[0]];
      final b = board[line[1]];
      final c = board[line[2]];
      if (a != Player.none && a == b && b == c) {
        return _EvaluationResult(
          status: a == Player.x ? GameStatus.xWon : GameStatus.oWon,
          line: line,
        );
      }
    }
    if (board.every((cell) => cell != Player.none)) {
      return const _EvaluationResult(status: GameStatus.draw, line: null);
    }
    return null;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class _EvaluationResult {
  final GameStatus status;
  final List<int>? line;
  const _EvaluationResult({required this.status, required this.line});
}
