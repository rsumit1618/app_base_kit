# base_app_kit example

This example demonstrates two ways to use `base_app_kit`.

## Flutter-First Usage

The first tab uses `AppBaseStatefulPage` directly. The page owns a `CounterNoRiverpodViewModel`, calls `load()` from `onModelReady`, and renders `AppBaseState<int>` through a `StreamBuilder`.

## Riverpod Usage

The second tab keeps Riverpod in the app layer. `flutter_riverpod` creates and disposes `RiverpodCounterViewModel`, then the UI bridges that model into `AppBaseWidget` with a `ValueNotifier`.

This keeps the package neutral while still showing how it fits a Riverpod project.

## Run

```bash
flutter pub get
flutter run
```

## Test

```bash
flutter test
```
