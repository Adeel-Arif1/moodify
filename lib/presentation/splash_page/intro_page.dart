import 'package:zee_palm_task/packages/packages.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 800;
    final isTablet = size.width > 600 && size.width <= 800;

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: isWeb ? 100 : 24, vertical: 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Name
            Text(
              "Welcome to Moodify",
              style: GoogleFonts.poppins(
                fontSize: isWeb ? 42 : isTablet ? 32 : 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // About Text
            Text(
              "Your personal wellness companion.\n\n"
              "Best wellness app, curated for your mood — "
              "helping you relax, focus, or feel energized "
              "with short, uplifting videos.",
              style: GoogleFonts.poppins(
                fontSize: isWeb ? 18 : 14,
                color: Colors.white70,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Get Started Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? 50 : 30,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Get.offAllNamed('/home'); // Replace with your actual home route
              },
              child: Text(
                "Get Started",
                style: GoogleFonts.poppins(
                  fontSize: isWeb ? 20 : 16,
                  color: const Color(0xFF667eea),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
