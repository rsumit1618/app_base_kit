import 'package:app_base_kit/app_base_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final class TestViewModel extends AppBaseViewModel<String> {}

void main() {
  test('AppResult success fold returns success value', () {
    const result = AppSuccess<int>(10);

    final value = result.fold(
      onSuccess: (data) => data,
      onFailure: (_) => 0,
    );

    expect(value, 10);
    expect(result.isSuccess, true);
    expect(result.isFailure, false);
  });

  test('AppResult failure fold returns failure message', () {
    const result = AppFailureResult<int>(
      AppFailure(message: 'Failed'),
    );

    final value = result.fold(
      onSuccess: (data) => '$data',
      onFailure: (failure) => failure.message,
    );

    expect(value, 'Failed');
    expect(result.isSuccess, false);
    expect(result.isFailure, true);
  });

  test('AppPaginationState copyWith updates values', () {
    const state = AppPaginationState<int>();

    final updated = state.copyWith(
      items: [1, 2, 3],
      page: 2,
      isLoading: true,
    );

    expect(updated.items.length, 3);
    expect(updated.page, 2);
    expect(updated.isLoading, true);
  });

  test('AppBaseViewModel emits states', () async {
    final viewModel = TestViewModel();

    viewModel.setLoading();
    expect(viewModel.state, isA<AppLoadingState<String>>());

    viewModel.setData('Hello');
    expect(viewModel.state, isA<AppSuccessState<String>>());

    viewModel.setError('Error');
    expect(viewModel.state, isA<AppErrorState<String>>());

    await viewModel.dispose();
    expect(viewModel.isDisposed, true);
  });

  testWidgets('AppBaseScaffold renders body', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppBaseScaffold(
          body: Text('Base Body'),
        ),
      ),
    );

    expect(find.text('Base Body'), findsOneWidget);
  });

  testWidgets('AppBasePage can override scaffold', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: _CustomPage(),
      ),
    );

    expect(find.text('Custom Scaffold'), findsOneWidget);
  });
}

class _CustomPage extends AppBasePage {
  const _CustomPage();

  @override
  Widget buildBody(BuildContext context) {
    return const Text('Body');
  }

  @override
  Widget? buildCustomScaffold(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Custom Scaffold'),
      ),
    );
  }
}
