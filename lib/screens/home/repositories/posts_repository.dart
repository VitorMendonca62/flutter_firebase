import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/models/post/post_model.dart';

class PostsRepository {
  Stream<List<PostModel>>? getAll(bool isRestrict) {
    final postsCollection = FirebaseFirestore.instance.collection(
      isRestrict ? "restrict" : 'home',
    );

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
      throw Exception("Erro ao pegar posts");
    }
  }

  changeLikePost(String postId, String type, bool isRestrict) async {
    final collection = FirebaseFirestore.instance.collection(
      isRestrict ? "restrict" : 'home',
    );

    final postDocument = collection.doc(postId);
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
      throw Exception(
        "Erro ao ${type == "like" ? "favoritar" : "desfavoritar"} o video",
      );
    }
  }
}
