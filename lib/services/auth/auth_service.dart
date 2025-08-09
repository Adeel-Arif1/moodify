import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zee_palm_task/packages/packages.dart';
import 'package:zee_palm_task/presentation/home_page/home_page.dart';

class AuthService {
  final AuthController _authController = Get.find<AuthController>();
  // login user
  /// Login user with email and password
  Future<void> loginUser() async {
    try {
      _authController.isAuthenticating.value = true;

      // Sign in with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _authController.emailAddressController.value.text.trim(),
        password: _authController.passwordController.value.text.trim(),
      );

      _authController.isAuthenticating.value = false;

      Get.snackbar(
        'Success',
        'Welcome back!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
      );

      // Navigate to home
      Get.offAll(() => HomePage());
    } on FirebaseAuthException catch (e) {
      _authController.isAuthenticating.value = false;

      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later.';
          break;
        default:
          errorMessage = 'Login failed. Please try again.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    } catch (e) {
      _authController.isAuthenticating.value = false;
    }
  }

  // signup user
  /// Create account with email and password
  Future<void> createAccount() async {
    try {
      _authController.isAuthenticating.value = true;

      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _authController.emailAddressController.value.text.trim(),
        password: _authController.passwordController.value.text.trim(),
      );

      _authController.isAuthenticating.value = false;

      storeUserData(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      _authController.isAuthenticating.value = false;

      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists with that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    } catch (e) {
      _authController.isAuthenticating.value = false;

      Get.snackbar(
        'Error',
        'An unexpected error occurred.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    }
  }

  // store user data
  /// Store user data in Firestore zee_palm_users collection
  Future<void> storeUserData(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('zee_palm_users')
          .doc(userId)
          .set({
        'email': _authController.emailAddressController.value.text.trim(),
        'name': _authController.usernameController.value.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.log('User data stored successfully');
      Get.snackbar(
        'Success',
        'Account created successfully.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
      );
      Get.offAll(() => HomePage());
    } catch (e) {
      Get.log('Error storing user data: $e');
    }
  }

  // check if user already exist

  // get current user data

  // get user data by uid

  // check user is logged in or not

  checkUserLoggedIn() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Get.offAll(() => HomePage());
      } else {
        Get.offAll(() => LoginPage());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.log('Wrong password provided for that user.');
      }
    }
  }

  // signout function
  /// Sign out user
  void signOut() {
    try {
      FirebaseAuth.instance.signOut();
      Get.offAll(() => LoginPage());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.log('Wrong password provided for that user.');
      }
    }
  }
}
