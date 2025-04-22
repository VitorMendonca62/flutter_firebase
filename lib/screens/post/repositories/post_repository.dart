import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/models/post/post_model.dart';

class PostRepository {
  Future<PostModel?> getOne(String postId) async {
    final postsCollection = FirebaseFirestore.instance.collection('home');
    try {
      final snapshot = await postsCollection.doc(postId).get();

      return snapshot.exists
          ? PostModel.fromDocumentSnapshot(
              snapshot,
            )
          : null;
    } catch (e) {
      Exception("Erro ao pegar post");
      return null;
    }
  }

  changeLikePost(String postId, String type) async {
    final postDocument =
        FirebaseFirestore.instance.collection('home').doc(postId);
    final currentUser = FirebaseAuth.instance.currentUser;

    try {
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
    } catch (e) {
      Exception("Erro ao pegar posts");
      return null;
    }
  }
}
