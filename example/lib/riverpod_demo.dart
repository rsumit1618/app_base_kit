import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final riverpodCounterViewModelProvider =
    Provider.autoDispose<RiverpodCounterViewModel>((ref) {
      final viewModel = RiverpodCounterViewModel();

      ref.onDispose(viewModel.dispose);

      return viewModel;
    });

final class RiverpodCounterViewModel extends AppBaseViewModel<int> {
  RiverpodCounterViewModel();

  Future<void> load() async {
    setLoading();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    setData(100);
  }

  void increment() {
    final current = state;
    final value = current is AppSuccessState<int> ? current.data : 100;

    setData(value + 1);
  }

  void fail() {
    setError('Riverpod powered failure state');
  }

  void reset() {
    setData(100);
  }
}

class RiverpodCounterDemo extends ConsumerStatefulWidget {
  const RiverpodCounterDemo({super.key});

  @override
  ConsumerState<RiverpodCounterDemo> createState() =>
      _RiverpodCounterDemoState();
}

class _RiverpodCounterDemoState extends ConsumerState<RiverpodCounterDemo> {
  final ValueNotifier<RiverpodCounterViewModel?> _modelListenable =
      ValueNotifier<RiverpodCounterViewModel?>(null);

  @override
  void dispose() {
    _modelListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RiverpodCounterViewModel>(riverpodCounterViewModelProvider, (
      previous,
      next,
    ) {
      _modelListenable.value = next;
    });

    final model = ref.watch(riverpodCounterViewModelProvider);
    if (!identical(_modelListenable.value, model)) {
      _modelListenable.value = model;
    }

    return AppBaseWidget<RiverpodCounterViewModel>(
      modelListenable: _modelListenable,
      onModelReady: (model) {
        debugPrint('Riverpod VM ready');
        model.load();
      },
      builder: (context, model, child) {
        if (model == null) {
          return const SizedBox.shrink();
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Counter with Riverpod',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                StreamBuilder<AppBaseState<int>>(
                  stream: model.stateStream,
                  initialData: model.state,
                  builder: (context, snapshot) {
                    return _CounterStateText(state: snapshot.requireData);
                  },
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: model.increment,
                      icon: const Icon(Icons.add),
                      label: const Text('Increment'),
                    ),
                    OutlinedButton.icon(
                      onPressed: model.fail,
                      icon: const Icon(Icons.error_outline),
                      label: const Text('Error'),
                    ),
                    TextButton.icon(
                      onPressed: model.reset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CounterStateText extends StatelessWidget {
  const _CounterStateText({required this.state});

  final AppBaseState<int> state;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      AppInitialState<int>() => const Text('Waiting for view model...'),
      AppLoadingState<int>() => const Text('Loading...'),
      AppSuccessState<int>(:final data) => Text(
        'Value: $data',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      AppEmptyState<int>(:final message) => Text('Empty: $message'),
      AppErrorState<int>(:final message) => Text('Error: $message'),
    };
  }
}
