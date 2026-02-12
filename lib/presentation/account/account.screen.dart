import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/widgets/others/custom.primary.card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'controllers/account.controller.dart';

class AccountScreen extends GetView<AccountController> {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: buildAppbar(context),
      body: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.s8.symmetric.horizontal,
            vertical: Spacing.s4.symmetric.horizontal,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '\u{f521}', // Change icon :- crown
                        style: TextStyle(
                          fontFamily: 'FontAwesomeSolid',
                          fontSize: 22,
                          color: primary,
                        ),
                      ),
                    ),
                    Spacing.s12.w,

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Upgrade Plan Now!",
                            textAlign: TextAlign.center,
                            style: r16.copyWith(
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacing.s4.h,
                          Text(
                            "Enjoy all the benefits and explore more possiblities",
                            style: r12.copyWith(
                              color: white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.s16.h,

              buildProfileDetailsSection(context),
              Spacing.s16.h,

              CustomPrimaryCard(
                child: Column(
                  children: [
                    buildOptionRow(
                      context,
                      '\u{f336}', // Change icon :- badge-check
                      "My Badges",
                    ),
                    Spacing.s12.h,

                    buildOptionRow(
                      context,
                      '\u{f017}', // Change icon :- clock
                      "Daily Reminder",
                    ),
                    Spacing.s12.h,

                    buildOptionRow(
                      context,
                      '\u{f013}', // Change icon :- gear
                      "Preferences",
                    ),
                  ],
                ),
              ),
              Spacing.s16.h,

              CustomPrimaryCard(
                child: Column(
                  children: [
                    buildOptionRow(
                      context,
                      '\u{f2f7}', // Change icon :- shield-check
                      "Account & Security",
                    ),
                    Spacing.s12.h,

                    buildOptionRow(
                      context,
                      '\u{f09d}', // Change icon :- credit-card
                      "Payment Methods",
                    ),
                    Spacing.s12.h,

                    buildOptionRow(
                      context,
                      '\u{f005}', // Change icon :- star
                      "Billing and Subscription",
                    ),
                    Spacing.s12.h,

                    buildOptionRow(
                      context,
                      '\u{f0c1}', // Change icon :- link
                      "Linked Accounts",
                    ),
                    Spacing.s12.h,

                    buildOptionRow(
                      context,
                      '\u{f06e}', // Change icon :- eye
                      "App Appearance",
                    ),
                    Spacing.s12.h,

                    buildOptionRow(
                      context,
                      '\u{f1fe}', // Change icon :- chart-area
                      "Data & Analytics",
                    ),
                  ],
                ),
              ),
              Spacing.s16.h,

              CustomPrimaryCard(
                child: Column(
                  children: [
                    buildOptionRow(
                      context,
                      '\u{f336}', // Change icon :- badge-check
                      "My Badges",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildOptionRow(BuildContext context, String icon, String label) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Text(
            icon,
            style: TextStyle(
              fontFamily: 'FontAwesomeRegular',
              fontSize: 20,
              color: primary,
            ),
          ),
          Spacing.s12.w,
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: r14.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\u{f054}', // Change icon :- chevron-right
                  style: TextStyle(
                    fontFamily: 'FontAwesomeLight',
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomPrimaryCard buildProfileDetailsSection(BuildContext context) {
    return CustomPrimaryCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              "https://austinfilm.s3.us-east-2.amazonaws.com/wp-content/uploads/2019/07/29115643/john-doe-jim-herrington-cropped-1024x675.jpg",
            ),
          ),
          Spacing.s8.w,
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "John Doe",
                      textAlign: TextAlign.center,
                      style: r16.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "johndoe@example.com",
                      textAlign: TextAlign.center,
                      style: r14.copyWith(
                        color: Theme.of(context).textTheme.bodySmall!.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                Text(
                  '\u{f054}', // Change icon :- chevron-right
                  style: TextStyle(
                    fontFamily: 'FontAwesomeLight',
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // return CustomPrimaryCard(
    //   child: Column(
    //     children: [
    //       Stack(
    //         alignment: Alignment.bottomRight,
    //         children: [
    //           Container(
    //             decoration: BoxDecoration(
    //               shape: BoxShape.circle,
    //               boxShadow: [
    //                 BoxShadow(
    //                   color: const Color.fromRGBO(0, 0, 0, 0.05),
    //                   offset: const Offset(0, 1),
    //                   blurRadius: 10,
    //                   spreadRadius: 0,
    //                 ),
    //                 BoxShadow(
    //                   color: const Color.fromRGBO(0, 0, 0, 0.05),
    //                   offset: const Offset(0, 1),
    //                   blurRadius: 10,
    //                   spreadRadius: 0,
    //                 ),
    //               ],
    //             ),
    //             child: const CircleAvatar(
    //               radius: 60,
    //               backgroundImage: NetworkImage(
    //                 "https://austinfilm.s3.us-east-2.amazonaws.com/wp-content/uploads/2019/07/29115643/john-doe-jim-herrington-cropped-1024x675.jpg",
    //               ),
    //             ),
    //           ),

    //           IconButton(
    //             onPressed: () {},
    //             constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
    //             style: IconButton.styleFrom(
    //               backgroundColor: Theme.of(context).primaryColor,
    //               shape: const CircleBorder(),
    //             ),
    //             icon: Text(
    //               '\u{f304}', // Change icon :- pen
    //               style: TextStyle(
    //                 fontFamily: 'FontAwesomeSolid',
    //                 fontSize: 16,
    //                 color: white,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       Spacing.s8.h,

    //       Text(
    //         "John Doe",
    //         textAlign: TextAlign.center,
    //         style: r18.copyWith(
    //           color: Theme.of(context).textTheme.bodyLarge!.color,
    //           fontWeight: FontWeight.w600,
    //         ),
    //       ),
    //       Text(
    //         "johndoe@example.com",
    //         textAlign: TextAlign.center,
    //         style: r14.copyWith(
    //           color: Theme.of(context).textTheme.bodySmall!.color,
    //           fontWeight: FontWeight.w500,
    //         ),
    //       ),
    //       Spacing.s8.h,

    //       ElevatedButton(
    //         onPressed: () {},
    //         style: ElevatedButton.styleFrom(
    //           elevation: 0,
    //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(30),
    //           ),
    //         ),
    //         child: Text(
    //           "Edit Profile",
    //           textAlign: TextAlign.center,
    //           style: r16.copyWith(color: white, fontWeight: FontWeight.w600),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 25,
            width: 25,
            child: Image.asset('assets/logos/logo.png', fit: BoxFit.fill),
          ),
          Text(
            "Account",
            textAlign: TextAlign.center,
            style: h2.copyWith(
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
              child: SizedBox(
                height: 30.h,
                width: 30.h,
                child: Center(
                  child: Text(
                    '\u{f142}', // Change Icon :-  ellipsis-vertical
                    style: TextStyle(
                      fontFamily: 'FontAwesomeLight',
                      fontSize: 20,
                      color: slate[500],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}
