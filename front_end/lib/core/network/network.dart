import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnection internetChecker;
  NetworkInfoImpl(this.internetChecker);
  @override
  Future<bool> get isConnected {
    return internetChecker.hasInternetAccess;
  }
}
