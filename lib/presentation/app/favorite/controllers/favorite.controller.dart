import 'package:get/get.dart';

class FavoriteController extends GetxController {
  RxInt selectedIndex = 0.obs;

  RxList<String> categories = <String>[
    'All',
    'Meditations',
    'Breathing',
    'Articles',
  ].obs;
}
