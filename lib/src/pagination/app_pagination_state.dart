final class AppPaginationState<T> {
  final List<T> items;
  final int page;
  final bool isLoading;
  final bool isRefreshing;
  final bool hasMore;
  final String? errorMessage;

  const AppPaginationState({
    this.items = const [],
    this.page = 1,
    this.isLoading = false,
    this.isRefreshing = false,
    this.hasMore = true,
    this.errorMessage,
  });

  AppPaginationState<T> copyWith({
    List<T>? items,
    int? page,
    bool? isLoading,
    bool? isRefreshing,
    bool? hasMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AppPaginationState<T>(
      items: items ?? this.items,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
