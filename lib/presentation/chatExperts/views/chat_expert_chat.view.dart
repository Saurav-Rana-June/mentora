import 'package:Mentora/data/model/expert.model.dart';
import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/fields/custom_textfield.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:my_icons/icons.dart';
import 'package:my_spacing/my_spacing.dart';

import '../../../widgets/buttons/custom_back_button.widet.dart';
import '../../../widgets/others/custom.primary.appbar.dart';
import '../../../widgets/others/custom.screen.wrapper.dart';
import '../controllers/chat_experts.controller.dart';

class ChatExpertChatView extends GetView<ChatExpertsController> {
  final Expert expert;
  const ChatExpertChatView({super.key, required this.expert});

  @override
  Widget build(BuildContext context) {
    return CustomScreenWrapper(
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

  PreferredSizeWidget buildAppbar(BuildContext context) {
    return CustomPrimaryAppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomBackButton(icon: MyIcons.chevronLeft),
              Spacing.s8.w,

              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 180),
                child: Text(
                  expert.name ?? "",
                  textAlign: TextAlign.center,
                  style: r18.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          Row(
            children: [
              if (expert.callFeature ?? false)
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
              if (expert.callFeature ?? false) Spacing.s8.w,

              if (expert.videoCallFeature ?? false)
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
              Spacing.s8.w,

              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  splashColor: primary.withValues(alpha: 0.3),
                  onTap: () {},
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
