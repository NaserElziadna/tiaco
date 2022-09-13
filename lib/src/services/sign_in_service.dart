import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tictactoe/src/constants.dart';
import 'package:tictactoe/src/models/user_model.dart';
import 'package:tictactoe/src/services/shared_sevice.dart';

class SignInActivity {
  static final GoogleSignIn googleSignIn = GoogleSignIn();
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final SharedService service = SharedService();

  static Future<bool> get check async => googleSignIn.isSignedIn();

  static Future<List<dynamic>> signIn() async {
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      final GoogleSignInAuthentication authentication =
          await account!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken);

      await auth
          .signInWithCredential(credential)
          .then((value) => _saveData(value.user!));

      return [true];
    } on PlatformException catch (e) {
      return [false, "error msg : ${e.message} \n error code : ${e.code}"];
    } catch (e) {
      return [false, 'Error: No Internet Connection || User Returned Back.'];
    }
  
  }

  static _saveData(User firebaseUser) {
    UserModel user = UserModel.fromFirebase(firebaseUser);
    userRef.doc(firebaseUser.uid).set(user.toMap());
    service.setUid(user.uid!);
    service.setUserName(user.name!);
    service.setPhotoUrl(user.photoUrl!);
    service.setBucks(100);
  }
}
