import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSingInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  static Future singInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      final googleKey = await account!.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleKey.accessToken, idToken: googleKey.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      return account;
    } catch (e) {
      return null;
    }
  }

  static Future signOut() async {
    await _googleSignIn.signOut();
  }
}
