import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/models/post/post_model.dart';

class PostsRepository {
  final postsCollection = FirebaseFirestore.instance.collection('home');

  Stream<List<PostModel>>? getAll() {
    try {
      return postsCollection.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => PostModel.fromDocumentSnapshot(doc))
          .toList());
    } catch (e) {
      Exception("Erro ao pegar posts");
      return null;
    }
  }
}
