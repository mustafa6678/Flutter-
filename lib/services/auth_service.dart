import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> signIn({required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapError(e));
    }
  }

  Future<User?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (displayName.trim().isNotEmpty) {
        await credential.user?.updateDisplayName(displayName.trim());
      }
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapError(e));
    }
  }

  /// Lets someone try the game without creating an account. Their history
  /// is still saved (tied to the anonymous UID) and can be preserved later
  /// if you add account-linking — not implemented here to keep scope tight.
  Future<User?> signInAnonymously() async {
    try {
      final credential = await _firebaseAuth.signInAnonymously();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapError(e));
    }
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  String _mapError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'network-request-failed':
        return 'No internet connection. Please try again.';
      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }
}
