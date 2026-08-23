import 'package:flutter/material.dart';

class CustomScreenWrapper extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final bool useSafeArea;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool safeAreaLeft;
  final bool safeAreaRight;
  final Key? scaffoldKey;
  
  // PopScope parameters
  final bool? canPop;
  final PopInvokedWithResultCallback? onPopInvokedWithResult;

  const CustomScreenWrapper({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.useSafeArea = true,
    this.safeAreaTop = false,
    this.safeAreaBottom = true,
    this.safeAreaLeft = true,
    this.safeAreaRight = true,
    this.scaffoldKey,
    this.canPop,
    this.onPopInvokedWithResult,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget mainWidget = Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor ?? theme.primaryColorLight,
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );

    if (canPop != null || onPopInvokedWithResult != null) {
      mainWidget = PopScope(
        canPop: canPop ?? true,
        onPopInvokedWithResult: onPopInvokedWithResult,
        child: mainWidget,
      );
    }

    if (useSafeArea) {
      mainWidget = SafeArea(
        top: safeAreaTop,
        bottom: safeAreaBottom,
        left: safeAreaLeft,
        right: safeAreaRight,
        child: mainWidget,
      );
    }

    return mainWidget;
  }
}
