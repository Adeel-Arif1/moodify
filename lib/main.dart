import 'package:firebase_core/firebase_core.dart';
import 'package:zee_palm_task/firebase_options.dart';
import 'package:zee_palm_task/packages/packages.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashPage(),
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(
          () => SplashController(),
        );
        Get.lazyPut(() => AuthController());
      }),
    );
  }
}
