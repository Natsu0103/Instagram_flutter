import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String username;
  final String uid;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post({
    required this.caption,
    required this.username,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'caption': caption,
        'username': username,
        'uid': uid,
        'postId': postId,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'likes': likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      caption: snapshot['caption'],
      username: snapshot['username'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}
