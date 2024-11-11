import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signOut() async {
    _auth.signOut();
  }

  Future<List<Map<String, dynamic>>> getUserInfo() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection("Users")
        .where("uid", isEqualTo: _auth.currentUser!.uid)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
