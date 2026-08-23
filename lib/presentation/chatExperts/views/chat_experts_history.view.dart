import 'package:Mentora/presentation/chatExperts/controllers/chat_experts.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.divider.dart';
import '../../../widgets/others/custom.primary.appbar.dart';
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
        ),
        child: Column(
          children: [
            Spacing.s8.h,
            buildTabbarSection(),
            Spacing.s8.h,
            Obx(
              () => controller.isChatsSelected.value
                  ? buildChatList()
                  : buildCallList(),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildChatList() {
    return Expanded(
      child: ListView.builder(
        itemCount: controller.chatsList.length,
        itemBuilder: (context, index) {
          final expert = controller.chatsList[index];
          return buildChatTile(
            context,
            expert.image ?? "",
            expert.name ?? "",
            expert.lastMessage ?? "",
            expert.time ?? "",
          );
        },
      ),
    );
  }

  Expanded buildCallList() {
    return Expanded(
      child: ListView.builder(
        itemCount: controller.callsList.length,
        itemBuilder: (context, index) {
          final expert = controller.callsList[index];
          return buildCallTile(
            context,
            expert.image ?? "",
            expert.name ?? "",
            expert.callOutgoing ?? false
                ? Text(
                    '\u{e091}', // Change Icon :- arrow-down-left
                    style: TextStyle(
                      fontFamily: 'FontAwesomeRegular',
                      fontSize: 13,
                      color: primary,
                    ),
                  )
                : Text(
                    '\u{e09f}', // Change Icon :- arrow-up-right
                    style: TextStyle(
                      fontFamily: 'FontAwesomeRegular',
                      fontSize: 13,
                      color: dangerColor,
                    ),
                  ),
            expert.time ?? "",
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                splashColor: primary.withValues(alpha: 0.3),
                onTap: () {},
                child: Container(
                  height: 30.h,
                  width: 30.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      expert.callFeature == true || expert.videoFeature == false
                          ? '\u{f095}' // Change Icon :- phone
                          : '\u{f03d}', // Change Icon :- video
                      style: TextStyle(
                        fontFamily: 'FontAwesomeSolid',
                        fontSize: 16,
                        color: primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InkWell buildChatTile(
    BuildContext context,
    String image,
    String name,
    String lastMessage,
    String time,
  ) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Spacing.s4.h,
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(image),
                backgroundColor: Theme.of(context).cardTheme.color,
              ),
              Spacing.s12.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: r16.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      lastMessage,
                      textAlign: TextAlign.center,
                      style: r14.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Spacing.s12.w,

              Text(
                time,
                textAlign: TextAlign.center,
                style: r14.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Spacing.s4.h,

          const CustomDivider(),
        ],
      ),
    );
  }

  InkWell buildCallTile(
    BuildContext context,
    String image,
    String name,
    Widget callIcon,
    String time,
    Widget callFeatureIconButton,
  ) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Spacing.s4.h,
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(image),
                backgroundColor: Theme.of(context).cardTheme.color,
              ),
              Spacing.s12.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: r16.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        callIcon,
                        Spacing.s8.w,
                        Text(
                          time,
                          textAlign: TextAlign.center,
                          style: r14.copyWith(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.color,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacing.s12.w,

              callFeatureIconButton,
            ],
          ),
          Spacing.s4.h,

          const CustomDivider(),
        ],
      ),
    );
  }

  Container buildTabbarSection() {
    return Container(
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
    );
  }

  PreferredSizeWidget buildAppbar(BuildContext context) {
    return CustomPrimaryAppBar(
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
      centerTitle: false,
      automaticallyImplyLeading: false,
    );
  }
}
