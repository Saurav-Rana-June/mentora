import 'package:Mentora/presentation/chatExperts/views/chat_expert_chat.view.dart';
import 'package:Mentora/presentation/chatExperts/views/chat_experts_history.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';
import 'package:my_spacing/spacing.enum.dart';

import '../../infrastructure/theme/theme.dart';
import '../../widgets/buttons/custom_back_button.widet.dart';
import 'controllers/chat_experts.controller.dart';

class ChatExpertsScreen extends GetView<ChatExpertsController> {
  final bool showAppBar;
  final bool showBackButton;

  ChatExpertsScreen({
    super.key,
    this.showAppBar = true,
    this.showBackButton = true,
  });

  @override
  final controller = Get.put(ChatExpertsController());

  @override
  Widget build(BuildContext context) {
    final body = buildBody(context);
    if (!showAppBar) {
      return Container(
        color: Theme.of(context).primaryColorLight,
        child: body,
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: body,
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView.builder(
      itemCount: controller.expertsList.length,
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s12.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.horizontal,
      ),
      itemBuilder: (context, index) {
        final expert = controller.expertsList[index];
        return buildExpertTile(
          context,
          expert.image ?? "",
          expert.name ?? "",
          expert.speciality ?? "",
          expert.callFeature ?? false,
          expert.videoCallFeature ?? false,
          () {
            Get.to(
              () => ChatExpertChatView(expert: expert),
              transition: Transition.rightToLeft,
            );
          },
        );
      },
    );
  }

  InkWell buildExpertTile(
    BuildContext context,
    String image,
    String name,
    String speciality,
    bool callFeature,
    bool videoCallFeature,
    void Function()? onTap,
  ) {
    return InkWell(
      onTap: onTap,
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
                      speciality,
                      textAlign: TextAlign.center,
                      style: r14.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.s12.w,

              Row(
                children: [
                  if (callFeature)
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
                              '\u{f095}', // Change Icon :- phone
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
                  if (callFeature) Spacing.s4.w,

                  if (videoCallFeature)
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
                              '\u{f03d}', // Change Icon :- video
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
                ],
              ),
            ],
          ),
          Spacing.s4.h,

          Divider(),
        ],
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
            "Talk with Experts",
            textAlign: TextAlign.center,
            style: h3.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),

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
                    '\u{f1da}', // Change Icon :-  clock-rotate-left
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
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).primaryColorLight,
    );
  }
}
