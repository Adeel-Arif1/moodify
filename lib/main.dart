import 'package:firebase_core/firebase_core.dart';
import 'package:zee_palm_task/controllers/upload_controler.dart';
import 'package:zee_palm_task/firebase_options.dart';
import 'package:zee_palm_task/packages/packages.dart';
import 'package:zee_palm_task/controllers/mood_controller.dart';
import 'package:zee_palm_task/controllers/home_controller.dart';
import 'package:zee_palm_task/presentation/home_page/home_page.dart';
import 'package:zee_palm_task/presentation/home_page/profile_page.dart';

import 'package:zee_palm_task/presentation/upload_video.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moodify App',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFFA78BFA),
          surface: const Color(0xFF374151),
          background: const Color(0xFF1F2937),
          error: const Color(0xFFF87171),
        ),
        scaffoldBackgroundColor: const Color(0xFF1F2937),
        useMaterial3: true,
        fontFamily: 'Poppins',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF6366F1),
          ),
        ),
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashPage()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/upload', page: () => const UploadVideoPage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
      ],
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => SplashController());
        Get.lazyPut(() => AuthController());
        Get.lazyPut(() => MoodController());
        Get.lazyPut(() => HomeController());
        Get.lazyPut(() => UploadController());
      }),
    );
  }
}