import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controller/db_controller.dart';

import '../components/toast_util.dart';
import '../enums/toast_option.dart';
import '../model/user_data.dart';

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

  Stream<User?> get authState => _auth.authStateChanges();
  User? get user => _auth.currentUser; //_firebaseUser.value;

  static AuthService get to => Get.find<AuthService>();

  showSnack(String title, String error) {
    Get.snackbar(
      title,
      error,
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  createUser(UserData userObj, String password) async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
              email: userObj.email!, password: password))
          .user;

      if (user != null) {
        userObj.uidAuth = user.uid;
        DBController.to.addUser(userObj);
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
    getVerificationStatus();
  }

  getVerificationStatus() {
    if (_auth.currentUser != null) {
      isEmailVerified.value = _auth.currentUser!.emailVerified;
    }
  }

  logout() async {
    try {
      userIsAuthenticated.value = false;
      isEmailVerified.value = false;
      DBController.to.eraseDataOnLogout();
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnack('Erro ao sair!', e.code);
    }
  }

  toggle() {
    userIsAuthenticated.value = !userIsAuthenticated.value;
  }
}
