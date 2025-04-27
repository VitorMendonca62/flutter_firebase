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

  changeLikePost(String postId, String type, bool isRestrict) async {
    try {
      final collection = FirebaseFirestore.instance.collection(
        isRestrict ? "restrict" : 'home',
      );
      final postDocument = collection.doc(postId);
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
    } on FirebaseException catch (e) {
      String message;
      if (isRestrict) {
        switch (e.code) {
          case 'permission-denied':
            message = 'Você precisa validar seu email para ter permissão';
            break;
          default:
            message = 'Erro ao criar post: ${e.message}';
        }
      } else {
        switch (e.code) {
          case 'permission-denied':
            message = 'Você precisa estar logado';
            break;
          default:
            message = 'Erro ao criar post: ${e.message}';
        }
      }
      throw Exception(message);
    }
  }

  Future<Stream<List<CommentModel>?>?> getComments(
    String postId,
    bool isRestrict,
  ) async {
    // FirebaseFirestore.instance.clearPersistence();

    try {
      final collection = FirebaseFirestore.instance.collection(
        isRestrict ? "restrict" : 'home',
      );
      final postDocument = collection.doc(postId);
      final commentCollection =
          (await postDocument.get()).reference.collection("comments");

      return commentCollection
          .orderBy('createdAt', descending: true)
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
    } on FirebaseException catch (e) {
      String message;
      if (isRestrict) {
        switch (e.code) {
          case 'permission-denied':
            message = 'Você precisa validar seu email para ter permissão';
            break;
          default:
            message = 'Erro ao criar post: ${e.message}';
        }
      } else {
        switch (e.code) {
          case 'permission-denied':
            message = 'Você precisa estar logado';
            break;
          default:
            message = 'Erro ao criar post: ${e.message}';
        }
      }
      throw Exception(message);
    }
  }

  addComment(
    String postId,
    String comment,
    int index,
    bool isRestrict,
  ) async {
    try {
      final collection = FirebaseFirestore.instance.collection(
        isRestrict ? "restrict" : 'home',
      );
      final postDocument = collection.doc(postId);
      final currentUser = FirebaseAuth.instance.currentUser;

      final commentCollection =
          (await postDocument.get()).reference.collection("comments");

      final createdAt = Timestamp.now();
      commentCollection.doc("$index-${currentUser!.uid}").set({
        "content": comment,
        "author": currentUser.displayName,
        "authorPhoto": currentUser.photoURL,
        "createdAt": createdAt,
      });

      postDocument.update({
        'comments': FieldValue.increment(1),
      });

      return CommentModel(
        content: comment,
        author: currentUser.displayName!,
        authorPhoto: currentUser.photoURL!,
        createdAt: createdAt.toDate(),
      );
    } on FirebaseException catch (e) {
      String message;
      if (isRestrict) {
        switch (e.code) {
          case 'permission-denied':
            message = 'Você precisa validar seu email para ter permissão';
            break;
          default:
            message = 'Erro ao criar post: ${e.message}';
        }
      } else {
        switch (e.code) {
          case 'permission-denied':
            message = 'Você precisa estar logado';
            break;
          default:
            message = 'Erro ao criar post: ${e.message}';
        }
      }
      throw Exception(message);
    }
  }

  createPost(
    String title,
    String content,
    List<String> photos,
    Timestamp timeNow,
    bool isRestrict,
  ) async {
    try {
      final collection = FirebaseFirestore.instance.collection(
        isRestrict ? "restrict" : 'home',
      );
      final currentUser = FirebaseAuth.instance.currentUser;

      await collection.add({
        "title": title,
        "content": content,
        "authorId": currentUser!.uid,
        "author": currentUser.displayName,
        "authorPhoto": currentUser.photoURL,
        "comments": 0,
        "likes": 0,
        "createdAt": timeNow,
        "updatedAt": timeNow,
        "photos": photos,
      });
    } on FirebaseException catch (e) {
      String message;
      if (isRestrict) {
        switch (e.code) {
          case 'permission-denied':
            message = 'Você precisa validar seu email para ter permissão';
            break;
          default:
            message = 'Erro ao criar post: ${e.message}';
        }
      } else {
        switch (e.code) {
          case 'permission-denied':
            message = 'Você precisa estar logado';
            break;
          default:
            message = 'Erro ao criar post: ${e.message}';
        }
      }
      throw Exception(message);
    }
  }

  delete(String postId, bool isRestrict) async {
    try {
      final collection = FirebaseFirestore.instance.collection(
        isRestrict ? "restrict" : 'home',
      );
      final postDocument = collection.doc(postId);

      await postDocument.delete();
    } on FirebaseException catch (e) {
      String message;
      if (isRestrict) {
        switch (e.code) {
          case 'permission-denied':
            message = 'Você precisa validar seu email para ter permissão';
            break;
          default:
            message = 'Erro ao criar post: ${e.message}';
        }
      } else {
        switch (e.code) {
          case 'permission-denied':
            message = 'Você precisa estar logado';
            break;
          default:
            message = 'Erro ao criar post: ${e.message}';
        }
      }
      throw Exception(message);
    }
  }

  editPost(
    String postId,
    String? title,
    String? content,
    List<dynamic> oldPhotos,
    List<String>? newPhotos,
    Timestamp timeNow,
    bool isRestrict,
  ) async {
    try {
      final collection = FirebaseFirestore.instance.collection(
        isRestrict ? "restrict" : 'home',
      );

      List<dynamic> photos = oldPhotos;

      if (newPhotos != null) {
        photos = [...photos, ...newPhotos];
      }

      final Map<String, dynamic> updatedData = {
        if (title != null) "title": title,
        if (content != null) "content": content,
        "photos": photos,
        "updatedAt": timeNow,
      };

      await collection.doc(postId).update(updatedData);
    } on FirebaseException catch (e) {
      String message;
      if (isRestrict) {
        switch (e.code) {
          case 'permission-denied':
            message = 'Você precisa validar seu email para ter permissão';
            break;
          case 'not-found':
            message = 'Post não encontrado';
            break;
          default:
            message = 'Erro ao criar post: ${e.message}';
        }
      } else {
        switch (e.code) {
          case 'permission-denied':
            message = 'Você precisa estar logado';
            break;
          case 'not-found':
            message = 'Post não encontrado';
            break;
          default:
            message = 'Erro ao criar post: ${e.message}';
        }
      }
      throw Exception(message);
    }
  }
}
