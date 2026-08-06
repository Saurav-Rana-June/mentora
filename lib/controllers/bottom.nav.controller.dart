import 'package:Mentora/data/model/extras/page.model.dart';
import 'package:Mentora/presentation/home/home.screen.dart';
import 'package:Mentora/presentation/screens.dart';
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
        title: 'AI',
        icon: '\u{f544}', // Change Icon :- robot
        route: Routes.CHAT_A_I,
        widget: ChatAIScreen(showAppBar: true, showBackButton: false),
      ),
      PageModel(
        title: 'Sessions',
        icon: '\u{f073}', // Change Icon :- calendar
        route: Routes.SESSIONS,
        widget: SessionsScreen(),
      ),
      PageModel(
        title: 'Insights',
        icon: '\u{f201}', // Change Icon :- chart-line
        route: Routes.INSIGHTS,
        widget: InsightsScreen(),
      ),
    ];
  }

  void changeTabIndex(int index) {
    if (index == 2) {
      Get.to(
        () => ChatAIScreen(showAppBar: true, showBackButton: true),
        transition: Transition.rightToLeft,
      );
      return;
    }
    tabIndex.value = index;
  }
}
