// splash_page.dart

import 'package:zee_palm_task/packages/packages.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 800;
    final isTablet = size.width > 600 && size.width <= 800;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Obx(() => controller.hasError.value
              ? _buildErrorView(controller, isWeb, isTablet)
              : _buildLoadingView(controller, isWeb, isTablet)),
        ),
      ),
    );
  }

  Widget _buildLoadingView(
      SplashController controller, bool isWeb, bool isTablet) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo
        Center(
          child: FadeInDown(
            duration: const Duration(milliseconds: 800),
            child: Container(
              width: _getLogoSize(isWeb, isTablet),
              height: _getLogoSize(isWeb, isTablet),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.eco, // Replace with your app icon
                size: _getLogoSize(isWeb, isTablet) * 0.5,
                color: const Color(0xFF667eea),
              ),
            ),
          ),
        ),

        SizedBox(height: isWeb ? 40 : 30),

        // App Name
        FadeInUp(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 200),
          child: Text(
            'Moodify',
            style: GoogleFonts.poppins(
              fontSize: isWeb
                  ? 42
                  : isTablet
                      ? 32
                      : 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        SizedBox(height: isWeb ? 16 : 12),

        SizedBox(height: isWeb ? 60 : 50),

        // Loading Animation
        FadeInUp(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 600),
          child: Column(
            children: [
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(
      SplashController controller, bool isWeb, bool isTablet) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Error Icon
        FadeIn(
          child: Icon(
            Icons.error_outline,
            size: isWeb ? 80 : 60,
            color: Colors.white,
          ),
        ),

        SizedBox(height: isWeb ? 30 : 20),

        // Error Title
        FadeInUp(
          delay: const Duration(milliseconds: 200),
          child: Text(
            'Oops! Something went wrong',
            style: GoogleFonts.poppins(
              fontSize: isWeb
                  ? 24
                  : isTablet
                      ? 20
                      : 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: isWeb ? 16 : 12),

        // Error Message
        FadeInUp(
          delay: const Duration(milliseconds: 400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Please check your internet connection and try again.',
              style: GoogleFonts.poppins(
                fontSize: isWeb ? 14 : 12,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        SizedBox(height: isWeb ? 40 : 30),
      ],
    );
  }

  double _getLogoSize(bool isWeb, bool isTablet) {
    if (isWeb) return 100;
    if (isTablet) return 80;
    return 60;
  }
}
