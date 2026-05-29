import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_game/core/services/firestore_user_service.dart';
import 'package:word_game/core/services/progress_sync_service.dart';

class AuthUserProfile {
  const AuthUserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
  });

  final String uid;
  final String email;
  final String displayName;
}

/// Firebase Auth — guest play uses local DB only; login syncs to Firestore.
class AuthService {
  AuthService(
    this._auth,
    this._googleSignIn,
    this._prefs,
    this._sync,
    this._firestore,
  );

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final SharedPreferences _prefs;
  final ProgressSyncService _sync;
  final FirestoreUserService _firestore;

  static const _displayNameKey = 'auth_display_name';

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  bool get isSignedIn => _auth.currentUser != null;

  User? get currentUser => _auth.currentUser;

  String? get userId => _auth.currentUser?.uid;

  String get displayName {
    final firebaseName = _auth.currentUser?.displayName?.trim();
    if (firebaseName != null && firebaseName.isNotEmpty) return firebaseName;
    final cached = _prefs.getString(_displayNameKey)?.trim();
    if (cached != null && cached.isNotEmpty) return cached;
    return 'Player';
  }

  String? get email => _auth.currentUser?.email;

  AuthUserProfile? get profile {
    final user = _auth.currentUser;
    if (user == null) return null;
    return AuthUserProfile(
      uid: user.uid,
      email: user.email ?? '',
      displayName: displayName,
    );
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = cred.user;
    if (user == null) throw FirebaseAuthException(code: 'user-null');

    await user.updateDisplayName(displayName.trim());
    await _prefs.setString(_displayNameKey, displayName.trim());

    await _sync.mergeGuestProgressIntoCloud(
      uid: user.uid,
      displayName: displayName.trim(),
      email: email.trim(),
    );
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = cred.user;
    if (user == null) throw FirebaseAuthException(code: 'user-null');

    final name = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!.trim()
        : (user.email?.split('@').first ?? 'Player');
    await _prefs.setString(_displayNameKey, name);

    await _sync.mergeGuestProgressIntoCloud(
      uid: user.uid,
      displayName: name,
      email: user.email ?? email.trim(),
    );
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(code: 'google-cancelled');
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final cred = await _auth.signInWithCredential(credential);
    final user = cred.user;
    if (user == null) throw FirebaseAuthException(code: 'user-null');

    final name = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!.trim()
        : 'Player';
    await _prefs.setString(_displayNameKey, name);

    await _sync.mergeGuestProgressIntoCloud(
      uid: user.uid,
      displayName: name,
      email: user.email ?? '',
    );
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<void> updateDisplayName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    final user = _auth.currentUser;
    if (user == null) return;

    await user.updateDisplayName(trimmed);
    await _prefs.setString(_displayNameKey, trimmed);
    await _firestore.updateDisplayName(user.uid, trimmed);
  }

  String readableAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered. Try logging in.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'google-cancelled':
        return 'Google sign-in was cancelled.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
