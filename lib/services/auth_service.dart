import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<UserCredential?> signInAnonymously() async {

    try {

      UserCredential userCredential =
      await FirebaseAuth.instance
          .signInAnonymously();

      User? user = userCredential.user;

      if (user != null) {

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({

          'uid': user.uid,
          'role': 'guest',
          'isAnonymous': true,
          'isOnboardingCompleted': false,
          'createdAt': Timestamp.now(),

        });
      }

      return userCredential;

    } catch (e) {

      print(e);
      return null;
    }
  }
  Future<UserCredential?> signInWithGoogle() async {

    try {

      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {

        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (!doc.exists) {

          await _firestore.collection('users').doc(user.uid).set({

            'userId': user.uid,
            'username': user.displayName ?? '',
            'email': user.email ?? '',
            'phone': user.phoneNumber ?? '',
            'role': 'customer',
            'isOnboardingCompleted': false,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),

          });
        }
      }

      return userCredential;

    } catch (e) {

      print(e.toString());
      return null;
    }
  }
  Future<void> signOut() async {
    await GoogleSignIn().disconnect();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}