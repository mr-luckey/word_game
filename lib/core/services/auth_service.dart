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

  String? get photoUrl {
    final url = _auth.currentUser?.photoURL?.trim();
    if (url == null || url.isEmpty) return null;
    return url;
  }

  bool get isGoogleSignIn {
    final user = _auth.currentUser;
    if (user == null) return false;
    return user.providerData.any((p) => p.providerId == 'google.com');
  }

  AuthUserProfile? get profile {
    final user = _auth.currentUser;
    if (user == null) return null;
    return AuthUserProfile(
      uid: user.uid,
      email: user.email ?? '',
      displayName: displayName,
    );
  }

  /// Merges local guest data with Firestore and uploads full profile.
  Future<void> syncSignedInUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final name = displayName;
    await _sync.mergeGuestProgressIntoCloud(
      uid: user.uid,
      displayName: name,
      email: user.email ?? '',
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
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Updates Firebase Auth + local cache. Returns a user-facing warning if
  /// Firestore sync failed (e.g. rules not deployed in Firebase Console).
  Future<String?> updateDisplayName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;

    final user = _auth.currentUser;
    if (user == null) return null;

    await user.updateDisplayName(trimmed);
    await _prefs.setString(_displayNameKey, trimmed);

    try {
      await _firestore.updateDisplayName(user.uid, trimmed);
      return null;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        return 'Name saved on this device. Deploy Firestore rules in Firebase Console.';
      }
      return 'Name saved locally. Cloud sync failed: ${e.message ?? e.code}';
    }
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
