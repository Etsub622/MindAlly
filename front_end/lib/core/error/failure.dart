abstract class Failure {
  final String message;
  Failure({required this.message});
}

class ServerFailure extends Failure {
  @override
  final String message;
  ServerFailure({required this.message}) : super(message: message);
}

class NetworkFailure extends Failure {
  @override
  final String message;
  NetworkFailure({required this.message}) : super(message: message);
}

class CacheFailure extends Failure {
  @override
  final String message;
  CacheFailure({required this.message}) : super(message: message);
}
