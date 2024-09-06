import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String username;
  final String uid;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.username,
    required this.uid,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'uid': uid,
        'bio': bio,
        'photoUrl': photoUrl,
        'followers': followers,
        'following': following,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
 
    return User(
      email: snapshot['email'],
      username: snapshot['username'],
      uid: snapshot['uid'],
      bio: snapshot['bio'],
      photoUrl: snapshot['photoUrl'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
