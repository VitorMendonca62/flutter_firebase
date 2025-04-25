import 'package:firebase_auth/firebase_auth.dart';

class ValidationEmailRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> validateEmail() async {
    try {
      final User user = _auth.currentUser!;

      if (!user.emailVerified) {
        await user.sendEmailVerification();
        return;
      }
      throw Exception("O email do usuário já está validado");
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Usuário não encontrado.';
          break;
        case 'user-disabled':
          message = 'Essa conta foi desativada.';
          break;
        case 'requires-recent-login':
          message =
              'Por segurança, faça login novamente para enviar o e-mail de verificação.';
          break;
        case 'network-request-failed':
          message =
              'Sem conexão com a internet. Verifique sua rede e tente novamente.';
          break;
        case 'too-many-requests':
          message =
              'Muitas tentativas. Aguarde alguns instantes e tente novamente.';
          break;
        default:
          message = 'Erro ao enviar e-mail de verificação: ${e.message}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Erro inesperado ao enviar e-mail de verificação: $e');
    }
  }
}
