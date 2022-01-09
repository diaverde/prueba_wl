import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Clase para autenticación con distintas credenciales
class Authentication {
  // Autenticación con correo y contraseña
  static Future<bool?> logInToFb(String user, String pwd) async {
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user, password: pwd);
      //print(result.user!.uid);
      if (result.user != null) {
        return true;
      } else {
        return null;
      }
    } on FirebaseAuthException {
      return false;
    } on Exception catch (e) {
      //print(e);
      return null;
    }
  }

  // Autenticación con credenciales de Google
  static Future<String> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);
        user = userCredential.user;
        return 'Ok';
      } catch (e) {
        //print(e);
        return 'Error: $e';
      }
    } else {
      final googleSignIn = GoogleSignIn();
      final googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final userCredential = await auth.signInWithCredential(credential);
          user = userCredential.user;
          return 'Ok';
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            return 'Error de cuenta';
          } else if (e.code == 'invalid-credential') {
            return 'Error de credenciales';
          }
        } catch (e) {
          return 'Error: $e';
        }
      }
      return 'Error accediendo a Google Sign-In';
    }
  }

  // Cerrar sesión con Google
  static Future<void> signOutGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      //print(e);
    }
  }

  // Autenticación con credenciales de Facebook
  static Future<User?> signInWithFacebook() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      final result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final facebookCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          final userCredential =
              await auth.signInWithCredential(facebookCredential);
          user = userCredential.user;
          return user;
        case LoginStatus.cancelled:
          print('Canceled');
          return null;
        case LoginStatus.failed:
          print('Failed');
          return null;
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return null;
      } else if (e.code == 'invalid-credential') {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Cerrar sesión con Facebook
  static Future<void> signOutFacebook({required BuildContext context}) async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
