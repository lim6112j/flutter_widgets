class RouteResult<T> {
  final bool success;
  final T? data;
  final String? error;

  const RouteResult.success(this.data)
      : success = true,
        error = null;

  const RouteResult.failure(this.error)
      : success = false,
        data = null;

  bool get isSuccess => success;
  bool get isFailure => !success;
}
