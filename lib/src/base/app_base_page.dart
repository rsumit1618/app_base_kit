import 'package:flutter/material.dart';

import 'app_base_scaffold.dart';

abstract class AppBasePage extends StatelessWidget {
  const AppBasePage({super.key});

  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  Widget buildBody(BuildContext context);

  Widget? buildFloatingActionButton(BuildContext context) => null;

  Widget? buildBottomNavigationBar(BuildContext context) => null;

  Widget? buildDrawer(BuildContext context) => null;

  Widget? buildEndDrawer(BuildContext context) => null;

  Widget? buildBottomSheet(BuildContext context) => null;

  Color? backgroundColor(BuildContext context) => null;

  bool get resizeToAvoidBottomInset => true;

  bool get extendBody => false;

  bool get extendBodyBehindAppBar => false;

  bool get safeArea => false;

  EdgeInsets get safeAreaMinimum => EdgeInsets.zero;

  bool get safeAreaTop => true;

  bool get safeAreaBottom => true;

  bool get safeAreaLeft => true;

  bool get safeAreaRight => true;

  FloatingActionButtonLocation? get floatingActionButtonLocation => null;

  FloatingActionButtonAnimator? get floatingActionButtonAnimator => null;

  List<Widget>? buildPersistentFooterButtons(BuildContext context) => null;

  Widget? buildCustomScaffold(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    final customScaffold = buildCustomScaffold(context);

    if (customScaffold != null) {
      return customScaffold;
    }

    return AppBaseScaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
      floatingActionButton: buildFloatingActionButton(context),
      bottomNavigationBar: buildBottomNavigationBar(context),
      drawer: buildDrawer(context),
      endDrawer: buildEndDrawer(context),
      bottomSheet: buildBottomSheet(context),
      backgroundColor: backgroundColor(context),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      safeArea: safeArea,
      safeAreaMinimum: safeAreaMinimum,
      safeAreaTop: safeAreaTop,
      safeAreaBottom: safeAreaBottom,
      safeAreaLeft: safeAreaLeft,
      safeAreaRight: safeAreaRight,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: buildPersistentFooterButtons(context),
    );
  }
}
