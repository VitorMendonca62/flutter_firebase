import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  Future<void> updateUser(
    String? displayName,
    String? photoURL,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      if (displayName != null) user.updateDisplayName(displayName);
      if (photoURL != null) user.updatePhotoURL(photoURL);
      await user.reload();
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Usuário não encontrado.';
          break;
        case 'user-disabled':
          message = 'A conta do usuário foi desativada.';
          break;
        case 'requires-recent-login':
          message = 'Faça login novamente para atualizar o perfil.';
          break;
        case 'network-request-failed':
          message = 'Sem conexão com a internet. Tente novamente.';
          break;
        default:
          message = 'Erro ao atualizar o perfil: ${e.message}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Erro inesperado ao atualizar o perfil: $e');
    }
  }

  Future<void> updatePassword(
    String newPassword,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.updatePassword(newPassword);
      await user.reload();
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'requires-recent-login':
          message = 'Faça login novamente para atualizar o perfil.';
          break;
        default:
          message = 'Erro ao atualizar o perfil: ${e.message}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Erro inesperado ao atualizar o perfil: $e');
    }
  }
}
