import 'package:firebase_auth/firebase_auth.dart';

class AuthService {


  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  // CustomerModel _customerFromFirebaseUser(User firebaseUser){
  //   return firebaseUser != null ? CustomerModel() : null;
  // }

  Stream<User> get user{
    return _auth.authStateChanges();
  }

  // sign in with phone


  // sign out

  Future signOut() async{
    try{
      print('user logged out');
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}