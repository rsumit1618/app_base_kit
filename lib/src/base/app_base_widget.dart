import 'package:flutter/widgets.dart';

/// Flutter-first widget that listens to a [ValueNotifier] containing a

/// view-model and invokes [onModelReady] once when the model becomes
/// available.
///
/// This mirrors the lifecycle wiring used in the `kickstart` project.
class AppBaseWidget<VM> extends StatefulWidget {
  const AppBaseWidget({
    super.key,
    required this.modelListenable,
    required this.builder,
    this.onModelReady,
    this.child,
  });

  /// Notifier that holds the current view-model.

  ///
  /// Return `null` while loading; return a non-null VM when ready.
  final ValueNotifier<VM?> modelListenable;

  /// Called once after the first non-null model becomes available.
  final void Function(VM model)? onModelReady;

  /// Builds the UI for the current [VM].
  final Widget Function(BuildContext context, VM? model, Widget? child) builder;

  /// Optional child for widget tree optimization.
  final Widget? child;

  @override
  State<AppBaseWidget<VM>> createState() => _AppBaseWidgetState<VM>();
}

class _AppBaseWidgetState<VM> extends State<AppBaseWidget<VM>> {
  VM? _model;
  VM? _readyModel;
  bool _readyCallbackScheduled = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VM?>(
      valueListenable: widget.modelListenable,
      builder: (context, model, child) {
        _model = model;

        if (_model != null) {
          _scheduleModelReady(_model as VM);
        }

        return widget.builder(context, _model, child);
      },
      child: widget.child,
    );
  }

  void _scheduleModelReady(VM model) {
    if (widget.onModelReady == null || identical(_readyModel, model)) return;
    if (_readyCallbackScheduled) return;

    _readyCallbackScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _readyCallbackScheduled = false;

      final latestModel = _model;
      if (latestModel == null || identical(_readyModel, latestModel)) return;

      _readyModel = latestModel;
      widget.onModelReady?.call(latestModel);
    });
  }
}
