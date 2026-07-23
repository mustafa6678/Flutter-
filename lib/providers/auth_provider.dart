import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/services.dart';

enum AuthStatus { unknown, signedOut, signedIn }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  StreamSubscription<User?>? _authSubscription;

  AuthProvider(this._authService) {
    _authSubscription = _authService.authStateChanges.listen((user) {
      _user = user;
      status = user == null ? AuthStatus.signedOut : AuthStatus.signedIn;
      notifyListeners();
    });
  }

  AuthStatus status = AuthStatus.unknown;
  User? _user;
  bool isLoading = false;
  String? errorMessage;

  User? get user => _user;
  String? get uid => _user?.uid;
  String get displayName =>
      (_user?.displayName?.isNotEmpty ?? false) ? _user!.displayName! : (_user?.email ?? 'Player');

  Future<bool> signIn({required String email, required String password}) async {
    return _runAuthAction(() => _authService.signIn(email: email, password: password));
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return _runAuthAction(
      () => _authService.signUp(email: email, password: password, displayName: displayName),
    );
  }

  Future<bool> signInAnonymously() async {
    return _runAuthAction(() => _authService.signInAnonymously());
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<bool> _runAuthAction(Future<User?> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await action();
      isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      isLoading = false;
      errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      isLoading = false;
      errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
