import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/models/comment/comment_model.dart';
import 'package:flutter_firebase/models/post/post_model.dart';

class PostRepository {
  Future<PostModel?> getOne(String postId) async {
    final postsCollection = FirebaseFirestore.instance.collection('home');
    final snapshot = await postsCollection.doc(postId).get();

    return snapshot.exists
        ? PostModel.fromDocumentSnapshot(
            snapshot,
          )
        : null;
  }

  changeLikePost(String postId, String type) async {
    final postDocument =
        FirebaseFirestore.instance.collection('home').doc(postId);
    final currentUser = FirebaseAuth.instance.currentUser;

    final likeCollection =
        (await postDocument.get()).reference.collection("likes");

    if (type == "like") {
      likeCollection.doc(currentUser!.uid).set({});
      postDocument.update({
        'likes': FieldValue.increment(1),
      });
    } else {
      likeCollection.doc(currentUser!.uid).delete();
      postDocument.update({
        'likes': FieldValue.increment(-1),
      });
    }
  }

  Future<Stream<List<CommentModel>?>?> getComments(
    String postId,
  ) async {
    // FirebaseFirestore.instance.clearPersistence();

    final postDocument =
        FirebaseFirestore.instance.collection('home').doc(postId);
    final commentCollection =
        (await postDocument.get()).reference.collection("comments");

    return commentCollection
        .orderBy('createdAt', descending: false)
        .snapshots(
          includeMetadataChanges: true,
        )
        .asyncMap(
          (snapshot) async => await Future.wait(
            snapshot.docs.map((doc) async {
              return CommentModel.fromDocumentSnapshot(doc);
            }).toList(),
          ),
        );
  }

  addComment(String postId, String comment, int index) async {
    final postDocument =
        FirebaseFirestore.instance.collection('home').doc(postId);
    final currentUser = FirebaseAuth.instance.currentUser;

    final commentCollection =
        (await postDocument.get()).reference.collection("comments");

    commentCollection.doc("$index-${currentUser!.uid}").set({
      "content": comment,
      "author": currentUser.displayName,
      "authorPhoto": currentUser.photoURL,
      "createdAt": Timestamp.now(),
    });

    postDocument.update({
      'comments': FieldValue.increment(1),
    });
  }
}
