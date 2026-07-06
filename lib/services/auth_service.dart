import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new account.
  Future<UserCredential> register({
    required String email,
    required String password,
    String? name,
  }) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (name != null && name.isNotEmpty) {
      await credential.user?.updateDisplayName(name);
    }

    return credential;
  }

  // Sign in to an existing account.
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign the user out.
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get the signed-in user.
  User? get currentUser => _auth.currentUser;
}
