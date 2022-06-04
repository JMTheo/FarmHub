import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/toast_util.dart';
import '../enums/ToastOptions.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User?> _firebaseUser = Rxn<User>();

  var userIsAuthenticated = false.obs;
  var isEmailVerified = false.obs;
  var canResendEmail = false.obs;

  @override
  void init() {
    super.onInit();

    _firebaseUser.bindStream(_auth.authStateChanges());

    ever(_firebaseUser, (User? user) {
      if (user != null) {
        userIsAuthenticated.value = true;
      } else {
        userIsAuthenticated.value = false;
      }
    });
  }

  toggle() {
    userIsAuthenticated.value = !userIsAuthenticated.value;
  }

  User? get user => _firebaseUser.value;
  static AuthService get to => Get.find<AuthService>();

  showSnack(String title, String error) {
    Get.snackbar(
      title,
      error,
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  //TODO: adiciona os dados no Cloud Firestore
  Future addUser(String uid, String name, String surname, String cpf) async {
    final user = <String, String>{
      "name": name,
      "surname": surname,
      "cpf": cpf,
      "uid_auth": uid,
    };

    // db.collection("users").add(user).then((DocumentReference doc) =>
    //     print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  createUser(String email, String password, String name, String surname,
      String cpf) async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        addUser(user.uid, name, surname, cpf);
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          ToastUtil(
            text: 'A senha deve conter ao menos 6 caracteres',
            type: ToastOption.error,
          ).getToast();
          break;
        case 'email-already-in-use':
          ToastUtil(
            text: 'Email já está cadastrado',
            type: ToastOption.error,
          ).getToast();
          break;
        default:
          ToastUtil(
            type: ToastOption.error,
            text: 'Erro inesperado, contate o adiministrador do aplicativo',
          ).getToast();
          break;
      }
    }
  }

  login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email, //Controller.text.trim().toLowerCase(),
          password: password //Controller.text.trim(),
          );
      ToastUtil(type: ToastOption.success, text: 'Sucesso ao logar!');
    } on FirebaseAuthException catch (e) {
      //Tratamento de erro
      switch (e.code) {
        case 'too-many-requests':
          ToastUtil(
            text:
                'Muitas tentativas para realizar o login, aguarde um monento!',
            type: ToastOption.error,
          ).getToast();
          break;
        case 'user-not-found':
        case 'wrong-password':
          ToastUtil(
            text: 'Email ou senha incorretos!',
            type: ToastOption.error,
          ).getToast();
          break;
        default:
          ToastUtil(
            type: ToastOption.error,
            text: 'Erro inesperado, contate o adiministrador do aplicativo',
          ).getToast();
          break;
      }
    }
  }

  forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ToastUtil(
        text: 'Email para resetar a senha enviado!',
        type: ToastOption.success,
      ).getToast();
    } on FirebaseAuthException catch (e) {
      ToastUtil(
        text: 'Erro ao resertar a senha: ${e.message}',
        type: ToastOption.success,
      ).getToast();
    }
  }

  Future sendVerificationEmail() async {
    try {
      user?.sendEmailVerification();

      canResendEmail.value = false;
      await Future.delayed(const Duration(seconds: 10));
      canResendEmail.value = true;
    } catch (e) {
      ToastUtil(
        text: 'Erro ao enviar a verificação de email: ${e.toString()}',
        type: ToastOption.success,
      ).getToast();
    }
  }

  Future checkEmailVerified() async {
    try {
      await _auth.currentUser!.reload();
    } on FirebaseAuthException catch (e) {
      ToastUtil(
        text: 'Erro ao verificar o email: ${e.toString()}',
        type: ToastOption.error,
      ).getToast();
    }
    print("checkEmailVerified: ${_auth.currentUser!.emailVerified}");

    getVerificationStatus();
  }

  getVerificationStatus() {
    isEmailVerified.value = _auth.currentUser!.emailVerified;
  }

  logout() async {
    try {
      await _auth.signOut();
      userIsAuthenticated.value = false;
      isEmailVerified.value = false;
    } on FirebaseAuthException catch (e) {
      showSnack('Erro ao sair!', e.code);
    }
  }
}
