import 'package:flutter/material.dart';

import 'app_base_scaffold.dart';
import 'app_base_widget.dart';
import 'app_base_view_model.dart';

/// Base page with Flutter-first VM attachment and lifecycle.
///
/// - View model comes from a [ValueNotifier<VM?>]

/// - [onModelReady] is called once when the VM becomes available
/// - Default UI renders via [AppBaseScaffold]
abstract class AppBaseStatefulPage<VM extends AppBaseViewModel<dynamic>>
    extends StatefulWidget {
  const AppBaseStatefulPage({super.key});

  /// Listenable for the view model.
  ///
  /// Return `null` while loading; return a non-null VM when ready.
  ValueNotifier<VM?> provideViewModelListenable();

  /// Called once when the VM becomes available.
  void onModelReady(VM model) {}

  /// Hook to build the page body.
  Widget buildBody(BuildContext context, VM model);

  /// Optional app bar.
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  /// Optional floating action button.
  Widget? buildFloatingActionButton(BuildContext context, VM model) => null;

  /// Optional bottom navigation.
  Widget? buildBottomNavigationBar(BuildContext context, VM model) => null;

  /// Optional drawer.
  Widget? buildDrawer(BuildContext context) => null;

  /// Optional end drawer.
  Widget? buildEndDrawer(BuildContext context) => null;

  /// Optional bottom sheet.
  Widget? buildBottomSheet(BuildContext context) => null;

  /// Optional background color.
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

  Widget? buildCustomScaffold(BuildContext context, VM model) => null;

  @override
  State<AppBaseStatefulPage<VM>> createState() =>
      _AppBaseStatefulPageState<VM>();
}

class _AppBaseStatefulPageState<VM extends AppBaseViewModel<dynamic>>
    extends State<AppBaseStatefulPage<VM>> {
  bool _isModelReadyCalled = false;

  @override
  void dispose() {
    _isModelReadyCalled = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBaseWidget<VM>(
      modelListenable: widget.provideViewModelListenable(),
      onModelReady: (model) {
        // Keep reference if needed in the future.

        if (_isModelReadyCalled) return;
        _isModelReadyCalled = true;
        widget.onModelReady(model);
      },
      builder: (context, model, child) {
        final vm = model;
        if (vm == null) {
          // Provider might briefly be in loading state; show an empty scaffold.
          return const SizedBox.shrink();
        }

        final custom = widget.buildCustomScaffold(context, vm);
        if (custom != null) return custom;

        return AppBaseScaffold(
          appBar: widget.buildAppBar(context),
          body: widget.buildBody(context, vm),
          floatingActionButton: widget.buildFloatingActionButton(context, vm),
          bottomNavigationBar: widget.buildBottomNavigationBar(context, vm),
          drawer: widget.buildDrawer(context),
          endDrawer: widget.buildEndDrawer(context),
          bottomSheet: widget.buildBottomSheet(context),
          backgroundColor: widget.backgroundColor(context),
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          extendBody: widget.extendBody,
          extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
          safeArea: widget.safeArea,
          safeAreaMinimum: widget.safeAreaMinimum,
          safeAreaTop: widget.safeAreaTop,
          safeAreaBottom: widget.safeAreaBottom,
          safeAreaLeft: widget.safeAreaLeft,
          safeAreaRight: widget.safeAreaRight,
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
          floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
          persistentFooterButtons: widget.buildPersistentFooterButtons(context),
        );
      },
    );
  }
}
