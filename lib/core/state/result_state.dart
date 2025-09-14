sealed class ResultState<T> {
  const ResultState();

  factory ResultState.loading() => Loading<T>();
  factory ResultState.success(T data) => Success<T>(data);
  factory ResultState.empty() => Empty<T>();
  factory ResultState.error(String message) => Error<T>(message);
}

class Loading<T> extends ResultState<T> {
  const Loading();
}

class Success<T> extends ResultState<T> {
  final T data;
  const Success(this.data);
}

class Empty<T> extends ResultState<T> {
  const Empty();
}

class Error<T> extends ResultState<T> {
  final String message;
  const Error(this.message);
}
