import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'riverpod_demo.dart';

void main() {
  runApp(const ProviderScope(child: ExampleApp()));
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app_base_kit example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('app_base_kit examples'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'No Riverpod'),
              Tab(text: 'Riverpod'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _NonRiverpodSection(),
            Padding(
              padding: EdgeInsets.all(16),
              child: RiverpodCounterDemo(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _ExampleSection extends StatelessWidget {
  const _ExampleSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SectionHeader(title: title),
        Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ],
    );
  }
}

class _CounterCard extends StatelessWidget {
  const _CounterCard({
    required this.title,
    required this.state,
    required this.onIncrement,
    required this.onFail,
    required this.onReset,
  });

  final String title;
  final AppBaseState<int> state;
  final VoidCallback onIncrement;
  final VoidCallback onFail;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _CounterStateText(state: state),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: onIncrement,
                  icon: const Icon(Icons.add),
                  label: const Text('Increment'),
                ),
                OutlinedButton.icon(
                  onPressed: onFail,
                  icon: const Icon(Icons.error_outline),
                  label: const Text('Error'),
                ),
                TextButton.icon(
                  onPressed: onReset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CounterNoRiverpodViewModel extends AppBaseViewModel<int> {
  CounterNoRiverpodViewModel();

  Future<void> load() async {
    setLoading();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    setData(0);
  }

  void increment() {
    final current = state;
    final value = current is AppSuccessState<int> ? current.data : 0;

    setData(value + 1);
  }

  void fail() {
    setError('Non-Riverpod failure state');
  }

  void reset() {
    setData(0);
  }
}

class _NonRiverpodSection extends StatelessWidget {
  const _NonRiverpodSection();

  @override
  Widget build(BuildContext context) {
    return const _NonRiverpodCounterPage();
  }
}

class _NonRiverpodCounterPage
    extends AppBaseStatefulPage<CounterNoRiverpodViewModel> {
  const _NonRiverpodCounterPage();

  @override
  ValueNotifier<CounterNoRiverpodViewModel?> provideViewModelListenable() {
    return ValueNotifier<CounterNoRiverpodViewModel?>(
      CounterNoRiverpodViewModel(),
    );
  }

  @override
  void onModelReady(CounterNoRiverpodViewModel model) {
    debugPrint('Non-Riverpod VM ready');
    model.load();
  }

  @override
  Widget buildBody(BuildContext context, CounterNoRiverpodViewModel model) {
    return StreamBuilder<AppBaseState<int>>(
      stream: model.stateStream,
      initialData: model.state,
      builder: (context, snapshot) {
        return _ExampleSection(
          title: 'Flutter-first AppBaseStatefulPage',
          child: _CounterCard(
            title: 'Counter without Riverpod',
            state: snapshot.requireData,
            onIncrement: model.increment,
            onFail: model.fail,
            onReset: model.reset,
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
