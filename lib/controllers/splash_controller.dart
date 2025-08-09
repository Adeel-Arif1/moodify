import 'package:zee_palm_task/constants/constants.dart';
import 'package:zee_palm_task/packages/packages.dart';

class SplashController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  // Observables
  RxBool isLoading = true.obs;
  RxString loadingText = 'Initializing...'.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 2), () {
      authService.checkUserLoggedIn();
    });
    super.onInit();
  }
}
