# app_base_kit

`app_base_kit` is a lightweight Flutter package for the base layer that many projects repeat: view-model state, lifecycle wiring, scaffold/page shells, result objects, use cases, and pagination state.

The package is Flutter-first. It does not depend on Riverpod, Provider, Bloc, GetX, or any project-specific service locator. You can use it directly, or bridge it into your preferred state-management package from the app layer.

## What It Solves

- Standard VM states: initial, loading, success, empty, and error.
- A small `AppBaseViewModel<T>` with a broadcast state stream.
- `AppBaseWidget` for one-time `onModelReady` lifecycle wiring.
- `AppBaseStatefulPage` and `AppBasePage` for consistent page/scaffold setup.
- `AppResult<T>` and `AppFailure` for use-case responses.
- `AppPaginationState<T>` for simple list pagination screens.

## Install

```yaml
dependencies:
  app_base_kit: ^0.0.2
```

Then import:

```dart
import 'package:app_base_kit/app_base_kit.dart';
```

## Usage Without Riverpod

Use the package directly when a page can own its view model.

```dart
class CounterViewModel extends AppBaseViewModel<int> {
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
}

class CounterPage extends AppBaseStatefulPage<CounterViewModel> {
  @override
  ValueNotifier<CounterViewModel?> provideViewModelListenable() {
    return ValueNotifier<CounterViewModel?>(CounterViewModel());
  }

  @override
  void onModelReady(CounterViewModel model) {
    model.load();
  }

  @override
  Widget buildBody(BuildContext context, CounterViewModel model) {
    return StreamBuilder<AppBaseState<int>>(
      stream: model.stateStream,
      initialData: model.state,
      builder: (context, snapshot) {
        return switch (snapshot.requireData) {
          AppLoadingState<int>() => const Text('Loading...'),
          AppSuccessState<int>(:final data) => Text('Value: $data'),
          AppEmptyState<int>(:final message) => Text(message),
          AppErrorState<int>(:final message) => Text(message),
          AppInitialState<int>() => const SizedBox.shrink(),
        };
      },
    );
  }
}
```

## Usage With Riverpod

Keep Riverpod in the app, not in this package. Create the view model with a provider, dispose it from the provider, then pass the model to `AppBaseWidget` through a `ValueNotifier`.

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
```

```dart
final counterViewModelProvider = Provider.autoDispose<CounterViewModel>((ref) {
  final model = CounterViewModel();
  ref.onDispose(model.dispose);
  return model;
});

class CounterRiverpodView extends ConsumerStatefulWidget {
  const CounterRiverpodView({super.key});

  @override
  ConsumerState<CounterRiverpodView> createState() => _CounterRiverpodViewState();
}

class _CounterRiverpodViewState extends ConsumerState<CounterRiverpodView> {
  final modelListenable = ValueNotifier<CounterViewModel?>(null);

  @override
  void dispose() {
    modelListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(counterViewModelProvider);
    modelListenable.value = model;

    return AppBaseWidget<CounterViewModel>(
      modelListenable: modelListenable,
      onModelReady: (model) => model.load(),
      builder: (context, model, child) {
        if (model == null) return const SizedBox.shrink();
        return TextButton(
          onPressed: model.increment,
          child: const Text('Increment'),
        );
      },
    );
  }
}
```

See the runnable app in [`example/`](example/) for full no-Riverpod and Riverpod demos.

## Comparison With A Project Kickstart

This package is intended to extract the reusable base dependencies from a kickstart/starter project without forcing the starter project's full stack onto every app.

| Kickstart concern | In a full project kickstart | In `app_base_kit` |
| --- | --- | --- |
| Base VM state | Usually copied into each app | Provided as `AppBaseState` and `AppBaseViewModel` |
| Page lifecycle | Often tied to a chosen state manager | Provided through `AppBaseWidget` and `AppBaseStatefulPage` |
| Scaffold setup | Repeated per screen | Centralized in `AppBaseScaffold` and overridable page hooks |
| Result/use-case contract | Recreated per app | Provided as `AppResult`, `AppFailure`, and `AppUseCase` |
| Pagination state | Recreated per list feature | Provided as `AppPaginationState` |
| State management | Kickstart may choose Riverpod/Bloc/GetX | Package stays neutral; apps add their own integration |
| App-specific services | Usually includes routing, DI, network, storage | Intentionally excluded from this package |

Use `app_base_kit` when you want the architecture base from a kickstart but still want each app to choose its own routing, dependency injection, networking, storage, and state-management tools.

## Publish Requirements

Before publishing to pub.dev:

- Replace placeholder repository links if the GitHub repo changes.
- Keep `version` in `pubspec.yaml` and `CHANGELOG.md` aligned.
- Keep `LICENSE` valid and confirm the copyright holder.
- Run `dart format .`.
- Run `flutter analyze`.
- Run `flutter test`.
- Run `flutter pub publish --dry-run`.
- Review `pubspec.yaml` for description, homepage, repository, issue tracker, documentation, and topics.
- Ensure the package has no accidental generated build output or private files.
- Confirm the example app compiles after `flutter pub get` inside `example/`.

Publish command:

```bash
flutter pub publish
```

## API Surface

- `AppBaseController`
- `AppBasePage`
- `AppBaseScaffold`
- `AppBaseState` and concrete state classes
- `AppBaseStatefulPage`
- `AppBaseViewModel`
- `AppBaseWidget`
- `AppPaginationState`
- `AppFailure`
- `AppResult`
- `AppUseCase`
- `NoParams`

## Links

- Source: <https://github.com/rsumit1618/app_base_kit>
- Issues: <https://github.com/rsumit1618/app_base_kit/issues>
