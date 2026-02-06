import 'package:Mentora/data/model/extras/page.model.dart';
import 'package:Mentora/presentation/home/home.screen.dart';
import 'package:Mentora/presentation/sleep/sleep.screen.dart';
import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import '../infrastructure/navigation/routes.dart';
import '../presentation/explore/explore.screen.dart';
import '../presentation/insights/insights.screen.dart';

class BottamNavController extends GetxController {
  static String TAG = "BottamNavController";
  RxInt tabIndex = 0.obs;
  List<PageModel> pages = <PageModel>[];

  @override
  void onInit() {
    super.onInit();
    prepareBottomNav();
  }

  prepareBottomNav() {
    pages = [
      PageModel(
        title: 'Home',
        icon: MyIcons.home,
        route: Routes.HOME,
        widget: HomeScreen(),
      ),
      PageModel(
        title: 'Explore',
        icon: '\u{f14e}', // Change Icon :- compass
        route: Routes.EXPLORE,
        widget: ExploreScreen(),
      ),
      PageModel(
        title: 'Sleep',
        icon: '\u{f186}', // Change Icon :- moon
        route: Routes.SLEEP,
        widget: SleepScreen(),
      ),
      PageModel(
        title: 'Insights',
        icon: '\u{f201}', // Change Icon :- chart-line
        route: Routes.INSIGHTS,
        widget: InsightsScreen(),
      ),
      PageModel(
        title: 'Account',
        icon: MyIcons.user,
        route: Routes.HOME,
        widget: HomeScreen(),
      ),
    ];
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}
