import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthImpl {
  static Future<Either <String, bool>> login({required String email, required String password}) async {
    try{
      UserCredential userCredentials = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
      if(userCredentials.user !=null){
        return right(true);
      }else{
        return left ("This User is not registered ");
      }
    }on FirebaseException catch(e){
      return left(e.message.toString());
    }
  }

}
