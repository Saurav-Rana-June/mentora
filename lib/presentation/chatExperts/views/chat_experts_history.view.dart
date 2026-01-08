import 'package:Mentora/presentation/chatExperts/controllers/chat_experts.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';
import '../../../widgets/buttons/custom_back_button.widet.dart';

class ChatExpertHistoryView extends GetView<ChatExpertsController> {
  const ChatExpertHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.s12.symmetric.horizontal,
          vertical: Spacing.s4.symmetric.horizontal,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: primary.withValues(alpha: 0.15),
              ),
              child: Row(
                children: [
                  Obx(
                    () => Expanded(
                      child: InkWell(
                        onTap: () {
                          controller.isChatsSelected.value = true;
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          decoration: BoxDecoration(
                            color: controller.isChatsSelected.value
                                ? primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: Spacing.s12.symmetric.horizontal,
                            vertical: Spacing.s4.symmetric.horizontal,
                          ),
                          child: Center(
                            child: Text(
                              "Chats",
                              textAlign: TextAlign.center,
                              style: r16.copyWith(
                                color: controller.isChatsSelected.value
                                    ? white
                                    : primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Expanded(
                      child: InkWell(
                        onTap: () {
                          controller.isChatsSelected.value = false;
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          decoration: BoxDecoration(
                            color: controller.isChatsSelected.value
                                ? Colors.transparent
                                : primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: Spacing.s12.symmetric.horizontal,
                            vertical: Spacing.s4.symmetric.horizontal,
                          ),
                          child: Center(
                            child: Text(
                              "Calls",
                              textAlign: TextAlign.center,
                              style: r16.copyWith(
                                color: controller.isChatsSelected.value
                                    ? primary
                                    : white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomBackButton(icon: MyIcons.chevronLeft),

          Text(
            "History",
            textAlign: TextAlign.center,
            style: r18.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),

          Row(
            children: [
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  splashColor: primary.withValues(alpha: 0.3),
                  onTap: () {
                    Get.to(
                      () => ChatExpertHistoryView(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: SizedBox(
                    height: 30.h,
                    width: 30.h,
                    child: Center(
                      child: Text(
                        MyIcons.magnifyingGlass,
                        style: TextStyle(
                          fontFamily: 'FontAwesomeLight',
                          fontSize: 20,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacing.s8.w,

              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  splashColor: primary.withValues(alpha: 0.3),
                  onTap: () {
                    Get.to(
                      () => ChatExpertHistoryView(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: SizedBox(
                    height: 30.h,
                    width: 30.h,
                    child: Center(
                      child: Text(
                        '\u{f142}', // Change Icon :-  ellipsis-vertical
                        style: TextStyle(
                          fontFamily: 'FontAwesomeLight',
                          fontSize: 20,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).primaryColorLight,
    );
  }
}
