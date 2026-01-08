import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';
import '../../infrastructure/theme/theme.dart';
import '../../widgets/bottomsheets/clear_chat.bottomsheet.dart';
import '../../widgets/buttons/custom_back_button.widet.dart';
import '../../widgets/fields/custom_textfield.widget.dart';
import 'controllers/chat_a_i.controller.dart';

class ChatAIScreen extends GetView<ChatAIController> {
  ChatAIScreen({super.key});
  @override
  final controller = Get.put(ChatAIController());

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: controller.exportKey,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        appBar: buildAppbar(context),
        body: buildBody(context),
      ),
    );
  }

  Stack buildBody(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [buildChatArea(), buildMessageBoxArea(context)],
    );
  }

  Container buildMessageBoxArea(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.vertical,
      ),
      decoration: BoxDecoration(color: Theme.of(context).primaryColorLight),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              hintText: "Type a message...",
              controller: TextEditingController(),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              borderWidth: 1.2,
              borderColor: primary,
              validator: (value) {
                if (value == null || value.isEmpty) return "Title is required";
                return null;
              },
            ),
          ),
          Spacing.s8.w,
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: primary.withValues(alpha: 0.3),
              onTap: () {},
              child: Container(
                height: 43.h,
                width: 43.h,
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '\u{f1d8}', // Change icon :- paper-plane
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
                      fontSize: 18,
                      color: white,
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

  ListView buildChatArea() {
    return ListView.builder(
      itemCount: controller.messages.length,
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s12.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.horizontal,
      ),
      itemBuilder: (context, index) {
        final message = controller.messages[index];
        return Align(
          alignment: message.isMe
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 270),
            child: Container(
              margin: EdgeInsets.only(
                bottom: index + 1 == controller.messages.length
                    ? Spacing.s32.symmetric.horizontal
                    : Spacing.s8.symmetric.horizontal,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.s8.symmetric.horizontal,
                vertical: Spacing.s4.symmetric.horizontal,
              ),
              decoration: BoxDecoration(
                color: message.isMe
                    ? Theme.of(context).cardTheme.color
                    : primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: message.isMe
                      ? Radius.circular(12)
                      : Radius.circular(0),
                  bottomRight: message.isMe
                      ? Radius.circular(0)
                      : Radius.circular(12),
                ),
              ),
              child: Text(
                message.message,
                style: r16.copyWith(
                  color: message.isMe
                      ? Theme.of(context).textTheme.bodyLarge!.color
                      : white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      title: Obx(
        () => controller.isSearching.value
            ? buildSearchAppbar(context)
            : buildNormalAppbar(context),
      ),
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).primaryColorLight,
    );
  }

  Row buildSearchAppbar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.s8.symmetric.horizontal,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  MyIcons.magnifyingGlass,
                  style: TextStyle(
                    fontFamily: 'FontAwesomeLight',
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall!.color!.withValues(alpha: .5),
                  ),
                ),
                Expanded(
                  child: CustomTextFormField(
                    hintText: "Search here...",
                    fillColor: Colors.transparent,
                    controller: TextEditingController(),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    contentPadding: EdgeInsetsGeometry.symmetric(horizontal: 6),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Title is required";
                      return null;
                    },
                  ),
                ),
                Text(
                  '\u{f078}', // Change Icon :-  chevron-down
                  style: TextStyle(
                    fontFamily: 'FontAwesomeLight',
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall!.color!.withValues(alpha: .75),
                  ),
                ),
                Spacing.s12.w,
                Text(
                  '\u{f077}', // Change Icon :-  chevron-up
                  style: TextStyle(
                    fontFamily: 'FontAwesomeLight',
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall!.color!.withValues(alpha: .75),
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacing.s12.w,

        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            splashColor: primary.withValues(alpha: 0.3),
            onTap: () {
              controller.isSearching.value = false;
            },
            child: Container(
              height: 30.h,
              width: 30.h,
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  MyIcons.xmark,
                  style: TextStyle(
                    fontFamily: 'FontAwesomeLight',
                    fontSize: 18,
                    color: Theme.of(context).textTheme.bodySmall!.color!,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildNormalAppbar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomBackButton(icon: MyIcons.chevronLeft),

        Text(
          "Chat with Mentora",
          textAlign: TextAlign.center,
          style: h3.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.w600,
          ),
        ),

        buildOptionsDropdownButtton(context),
      ],
    );
  }

  PopupMenuButton<String> buildOptionsDropdownButtton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Text(
        '\u{f142}', // Change Icon :-  ellipsis-vertical
        style: TextStyle(
          fontFamily: 'FontAwesomeLight',
          fontSize: 20,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
      ),
      color: Theme.of(context).cardColor,
      onSelected: (value) {
        switch (value) {
          case 'search':
            controller.isSearching.value = true;
            break;
          case 'export':
            controller.exportChat(controller.exportKey);
            break;
          case 'clear':
            Get.bottomSheet(
              ClearChatBottomsheet(onConfirm: () {}),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            );
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'search',
          child: Row(
            children: [
              Text(
                MyIcons.magnifyingGlass,
                style: TextStyle(
                  fontFamily: 'FontAwesomeLight',
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              Spacing.s12.w,
              Text(
                'Search',
                style: r16.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'export',
          child: Row(
            children: [
              Text(
                '\u{f08b}', // Change Icon :-  arrow-right-from-bracket
                style: TextStyle(
                  fontFamily: 'FontAwesomeLight',
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              Spacing.s12.w,
              Text(
                'Export Chat',
                style: r16.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'clear',
          child: Row(
            children: [
              Text(
                MyIcons.trash,
                style: TextStyle(
                  fontFamily: 'FontAwesomeLight',
                  fontSize: 16,
                  color: dangerColor,
                ),
              ),
              Spacing.s12.w,
              Text(
                'Clear Chat',
                style: r16.copyWith(
                  color: dangerColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
