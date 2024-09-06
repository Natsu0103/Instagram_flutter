import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:instagram/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // Sign Up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Something went wrong";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          file.isNotEmpty) {
        // Register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage("profilePics", file, false);

        // Add user to Firestore

        model.User user = model.User(
          email: email,
          username: username,
          uid: cred.user!.uid,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "Successfully registered";
      } else {
        res = "Please fill in all the fields";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = "Invalid email";
      } else if (err.code == 'email-already-in-use') {
        res = "Email already in use";
      } else if (err.code == 'weak-password') {
        res = "Your password should be at least 6 characters";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // Sign In
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Something went wrong";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please fill in all the fields";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        res = "User not found";
      } else if (err.code == 'wrong-password') {
        res = "Wrong password";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

   Future<void> signOut() async {
    await _auth.signOut();
  }
}
