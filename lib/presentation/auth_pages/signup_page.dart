import 'package:zee_palm_task/constants/constants.dart';
import 'package:zee_palm_task/packages/packages.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 800;
    final isTablet = size.width > 600 && size.width <= 800;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        authController.clearValues();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWeb ? 0 : 24,
                vertical: 20,
              ),
              child: Container(
                width: isWeb ? 400 : double.infinity,
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 400 : double.infinity,
                ),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        width: isWeb
                            ? 80
                            : isTablet
                                ? 70
                                : 60,
                        height: isWeb
                            ? 80
                            : isTablet
                                ? 70
                                : 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF667eea),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF667eea).withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.eco,
                          size: (isWeb
                                  ? 80
                                  : isTablet
                                      ? 70
                                      : 60) *
                              0.5,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: isWeb ? 40 : 30),

                      // Welcome Text
                      Text(
                        'Create Account',
                        style: GoogleFonts.poppins(
                          fontSize: isWeb
                              ? 32
                              : isTablet
                                  ? 28
                                  : 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Sign up to get started',
                        style: GoogleFonts.poppins(
                          fontSize: isWeb ? 16 : 14,
                          color: const Color(0xFF6B7280),
                        ),
                      ),

                      SizedBox(height: isWeb ? 40 : 32),

                      // Username Field
                      CustomTextField(
                        controller: authController.usernameController.value,
                        label: 'Username',
                        hint: 'Enter your username',
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          if (value.length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Email Field
                      CustomTextField(
                        controller: authController.emailAddressController.value,
                        label: 'Email Address',
                        hint: 'Enter your email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      Obx(() => CustomTextField(
                            controller: authController.passwordController.value,
                            label: 'Password',
                            hint: 'Enter your password',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            obscureText: !authController.showPassword.value,
                            onTogglePassword: () {
                              authController.showPassword.value =
                                  !authController.showPassword.value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          )),

                      const SizedBox(height: 20),

                      // Terms and Conditions
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: const Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  fontSize: isWeb ? 12 : 11,
                                  color: const Color(0xFF6B7280),
                                ),
                                children: [
                                  const TextSpan(
                                      text: 'By signing up, you agree to our '),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF667eea),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF667eea),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: isWeb ? 32 : 24),

                      // Signup Button
                      Obx(() => CustomButton(
                            text: 'Create Account',
                            isLoading: authController.isAuthenticating.value,
                            onPressed: () {
                              _handleSignup(authController);
                            },
                          )),

                      SizedBox(height: isWeb ? 40 : 32),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: GoogleFonts.poppins(
                              fontSize: isWeb ? 14 : 12,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back(); // Navigate back to login
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.poppins(
                                fontSize: isWeb ? 14 : 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF667eea),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignup(AuthController controller) {
    if (controller.usernameController.value.text.isEmpty ||
        controller.emailAddressController.value.text.isEmpty ||
        controller.passwordController.value.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(controller.emailAddressController.value.text)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
      return;
    }

    authService.createAccount();
    controller.isAuthenticating.value = true;
  }
}
