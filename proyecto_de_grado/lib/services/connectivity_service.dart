import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  
  bool _isConnected = true;
  bool get isConnected => _isConnected;
  
  String _connectionType = 'Sin conexión';
  String get connectionType => _connectionType;
  
  ConnectivityService() {
    _initConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  
  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      _isConnected = false;
      _connectionType = 'Error de conexión';
      notifyListeners();
    }
  }
  
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final bool wasConnected = _isConnected;
    
    if (results.isEmpty || results.first == ConnectivityResult.none) {
      _isConnected = false;
      _connectionType = 'Sin conexión';
    } else {
      _isConnected = true;
      switch (results.first) {
        case ConnectivityResult.wifi:
          _connectionType = 'WiFi';
          break;
        case ConnectivityResult.mobile:
          _connectionType = 'Datos móviles';
          break;
        case ConnectivityResult.ethernet:
          _connectionType = 'Ethernet';
          break;
        case ConnectivityResult.vpn:
          _connectionType = 'VPN';
          break;
        case ConnectivityResult.bluetooth:
          _connectionType = 'Bluetooth';
          break;
        default:
          _connectionType = 'Conectado';
      }
    }
    
    if (wasConnected != _isConnected) {
      notifyListeners();
    }
  }
  
  Future<bool> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
      return _isConnected;
    } catch (e) {
      return false;
    }
  }
  
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}