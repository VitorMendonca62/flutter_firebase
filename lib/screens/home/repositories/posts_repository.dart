import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/models/post/post_model.dart';

class PostsRepository {
  Stream<List<PostModel>>? getAll() {
    // FirebaseFirestore.instance.clearPersistence();
    final postsCollection = FirebaseFirestore.instance.collection('home');
    try {
      return postsCollection
          .orderBy('createdAt', descending: true)
          .snapshots(
            includeMetadataChanges: true,
          )
          .asyncMap((snapshot) async =>
              await Future.wait(snapshot.docs.map((doc) async {
                return PostModel.fromDocumentSnapshot(doc);
              }).toList()));
    } catch (e) {
      Exception("Erro ao pegar posts");
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
