abstract class DataState<T> {
  final T? data;
  final String? error;
  final int? errorType;
  const DataState({this.data, this.error, this.errorType});
}

class DataLoading<T> extends DataState<T> {
  const DataLoading() : super();
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataError<T> extends DataState<T> {
  const DataError(String error, {super.errorType}) : super(error: error);
}
