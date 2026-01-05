import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';
import '../../infrastructure/theme/theme.dart';
import '../../widgets/buttons/custom_back_button.widet.dart';
import '../../widgets/fields/custom_textfield.widget.dart';
import 'controllers/chat_a_i.controller.dart';

class ChatAIScreen extends GetView<ChatAIController> {
  ChatAIScreen({super.key});
  @override
  final controller = Get.put(ChatAIController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: buildBody(context),
    );
  }

  Stack buildBody(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [buildChatArea(), buildMessageBoxArea(context)],
    );
  }

  Padding buildMessageBoxArea(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.s8.symmetric.horizontal,
        vertical: Spacing.s4.symmetric.vertical,
      ),
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
        return Container(
          width: 100,
          margin: EdgeInsets.only(bottom: Spacing.s8.symmetric.horizontal),
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
            vertical: Spacing.s4.symmetric.horizontal,
          ),
          decoration: BoxDecoration(color: primary),
          child: Text(
            message.message,
            style: r16.copyWith(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      },
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomBackButton(icon: MyIcons.xmark),

          Text(
            "Chat with Mentora",
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
              onTap: () {},
              child: Container(
                height: 40.h,
                width: 40.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '\u{f142}', // Change icon :- ellipsis-vertical
                    style: TextStyle(
                      fontFamily: 'FontAwesomeSolid',
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
