import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  Rx<TextEditingController> emailAddressController =
      TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;

  Rx<TextEditingController> usernameController = TextEditingController().obs;

  Rx<bool> isAuthenticating = false.obs;

  Rx<bool> showPassword = false.obs;

  clearValues() {
    emailAddressController.value.clear();
    passwordController.value.clear();
    usernameController.value.clear();
  }
}
