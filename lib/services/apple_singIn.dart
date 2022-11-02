import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/shared/preferencias_usuario.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSinginService {
  static Future singIn() async {
    final _prefs = PreferenciasUsuario();

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oAuthprovider = OAuthProvider('apple.com');
      final credentiallogin = oAuthprovider.credential(
          idToken: credential.identityToken,
          accessToken: credential.authorizationCode);
      await FirebaseAuth.instance.signInWithCredential(credentiallogin);
      _prefs.email = credential.email ?? '';
      _prefs.name = credential.givenName ?? 'User';
      return credential;
    } catch (e) {
      return null;
    }
  }
}
