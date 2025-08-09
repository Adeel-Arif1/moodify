import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zee_palm_task/packages/packages.dart';

class AuthController extends GetxController {
  RxString userName = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isAuthenticating = false.obs; // Added for loading state
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool showPassword = false.obs; // Added for password visibility toggle

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        FirebaseFirestore.instance
            .collection('zee_palm_users')
            .doc(user.uid)
            .get()
            .then((doc) {
          userName.value = doc.data()?['name'] ?? 'User';
        });
      } else {
        userName.value = '';
      }
    });
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailAddressController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      isAuthenticating.value = true;
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('zee_palm_users')
          .doc(credential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      userName.value = name;
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Sign-up failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF87171),
        colorText: Colors.white,
      );
    } finally {
      isAuthenticating.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isAuthenticating.value = true;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Sign-in failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF87171),
        colorText: Colors.white,
      );
    } finally {
      isAuthenticating.value = false;
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Get.offAllNamed('/splash');
  }

  void clearValues() {
    usernameController.clear();
    emailAddressController.clear();
    passwordController.clear();
    showPassword.value = false;
  }
}
