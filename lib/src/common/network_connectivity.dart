import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Utility class for checking network connectivity status
class NetworkConnectivity {
  static final NetworkConnectivity _instance = NetworkConnectivity._internal();
  factory NetworkConnectivity() => _instance;
  NetworkConnectivity._internal();

  final Connectivity _connectivity = Connectivity();
  StreamController<bool>? _connectionStatusController;

  /// Stream of connectivity status (true = connected, false = disconnected)
  Stream<bool> get onConnectivityChanged {
    _connectionStatusController ??= StreamController<bool>.broadcast();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final isConnected = results.isNotEmpty && 
          results.any((result) => result != ConnectivityResult.none);
      _connectionStatusController!.add(isConnected);
    });
    return _connectionStatusController!.stream;
  }

  /// Check if device is currently connected to internet
  Future<bool> isConnected() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      return results.isNotEmpty && 
          results.any((result) => result != ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _connectionStatusController?.close();
    _connectionStatusController = null;
  }
}
