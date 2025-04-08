import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile']
  );

  Future<String?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      print('GoogleSignIn result: $account');
      return account?.email;
    } catch (e) {
      print('GoogleSignIn error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
