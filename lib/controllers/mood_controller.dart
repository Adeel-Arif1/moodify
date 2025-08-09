import 'package:get/get.dart';
import 'package:zee_palm_task/controllers/home_controller.dart';

class MoodController extends GetxController {
  RxString selectedMood = 'All'.obs;
  final List<String> moods = [
    'All',
    'Happy',
    'Sad',
    'Stressed',
    'Relaxed',
    'Motivated',
    'Calm'
  ];

  void setMood(String mood) {
    selectedMood.value = mood;
    Get.find<HomeController>().fetchVideos();
  }
}
