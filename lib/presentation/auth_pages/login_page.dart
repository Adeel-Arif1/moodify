import 'package:zee_palm_task/constants/constants.dart';
import 'package:zee_palm_task/packages/packages.dart';
import 'package:zee_palm_task/presentation/auth_pages/signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 800;
    final isTablet = size.width > 600 && size.width <= 800;

    return Scaffold(
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
                      'Welcome Back',
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
                      'Sign in to your account',
                      style: GoogleFonts.poppins(
                        fontSize: isWeb ? 16 : 14,
                        color: const Color(0xFF6B7280),
                      ),
                    ),

                    SizedBox(height: isWeb ? 40 : 32),

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

                    SizedBox(height: isWeb ? 32 : 24),

                    // Login Button
                    Obx(() => CustomButton(
                          text: 'Sign In',
                          isLoading: authController.isAuthenticating.value,
                          onPressed: () {
                            // Handle login
                            _handleLogin(authController);
                          },
                        )),

                    SizedBox(height: isWeb ? 32 : 24),

                    // Divider
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFE5E7EB),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFE5E7EB),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: isWeb ? 32 : 24),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.poppins(
                            fontSize: isWeb ? 14 : 12,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            authController.clearValues();
                            Get.to(() => SignupPage());
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Sign Up',
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
    );
  }

  void _handleLogin(AuthController controller) {
    // Add your login logic here
    if (controller.emailAddressController.value.text.isEmpty ||
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

    controller.isAuthenticating.value = true;

    authService.loginUser();
  }
}
