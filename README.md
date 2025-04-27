# Flutter Firebase - Capyba Challenge

<div style="display: flex; gap: 10px;">
<img src="https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white&style=for-the-badge" width="150">
<img src="https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=000000&style=for-the-badge" width="150">
</div>

## Descrição
Aplicativo desenvolvido em Flutter utilizando Firebase como backend, seguindo a arquitetura BLoC Pattern para gerenciamento de estado. O app permite interação social através de posts, comentários e likes.

## Pré-requisitos
- Flutter SDK: 3.19.3
- Firebase Core: ^2.24.2
- Dart SDK: '>=3.2.3 <4.0.0'
- Git


## Pacotes Utilizados
- Flutter Bloc: ^8.1.3
- Firebase Auth: ^4.15.3
- Cloud Firestore: ^4.13.6
- Image Picker: ^1.0.4
- Cached Network Image: ^3.3.0
- Provider: ^6.1.1

## Inicialização do Projeto

1. Clone o repositório:
```bash
git clone https://github.com/VitorMendonca62/flutter_firebase.git
```

2. Configure o Firebase:
```bash
flutter pub add firebase_core
flutterfire configure
```

3. Adicione seu arquivo `google-services.json` em:
```
android/app/google-services.json
```

4. Instale as dependências:
```bash
flutter pub get
```

5. Execute o projeto:
```bash
flutter run
```

## Estrutura do Projeto
```
lib/
lib/
├── models/
│   ├── comment/
│   ├── post/
├── screens/
│   ├── galery_page.dart
│   ├── auth/
│   │   ├── blocs/
│   │   └── pages/
│   ├── post/
│   ├── posts/
│   └── profile/
├── utils/
├── widgets/
├── colors.dart
├── constants.dart
├── firebase_options.dart
├── main.dart
├── routes.dart
├── guards/
```

## Funcionalidades

### Autenticação
- Login com email/senha
- Login com Google
- Registro de usuários

### Posts
- Criação de posts com imagens
- Feed de posts
- Feed de posts restristos
- Likes e comentários

### Perfil
- Edição de perfil
- Visualização de perfil
- Validação de email
- Alteração de senha

## Padrão BLoC
O projeto utiliza o BLoC Pattern para:
- Gerenciamento de estado
- Separação de responsabilidades
- Fluxo de dados unidirecional

## Como Contribuir
1. Faça um Fork
2. Crie sua branch (`git checkout -b feature/NovaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/NovaFeature`)
5. Abra um Pull Request

## Screenshots
<div style="display: flex; flex-wrap: wrap; gap: 10px;">

### Telas do Aplicativo
<img src="assets/screenshots/login.jpg" width="200" alt="Tela de Login">
<img src="assets/screenshots/resgistro.jpg" width="200" alt="Tela de Registro">
<img src="assets/screenshots/feed.jpg" width="200" alt="Feed de Posts">
<img src="assets/screenshots/adicionar-foto.jpg" width="200" alt="Adicionar Foto">
<img src="assets/screenshots/criacao-de-posts.jpg" width="200" alt="Criar Post">
<img src="assets/screenshots/perfil.jpg" width="200" alt="Tela de Perfil">
<img src="assets/screenshots/area-teste.jpg" width="200" alt="Área de Teste">

</div>