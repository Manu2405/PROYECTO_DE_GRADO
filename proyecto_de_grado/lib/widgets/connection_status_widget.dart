import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../services/connectivity_service.dart';

class ConnectionStatusWidget extends StatelessWidget {
  final Widget child;
  
  const ConnectionStatusWidget({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return ConnectivityProvider(
      connectivityService: ConnectivityService(),
      child: Stack(
        children: [
          child,
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _ConnectionStatusOverlay(),
          ),
        ],
      ),
    );
  }
}

class _ConnectionStatusOverlay extends StatelessWidget {
  const _ConnectionStatusOverlay();
  
  @override
  Widget build(BuildContext context) {
    final connectivityService = ConnectivityProvider.of(context);
    
    if (connectivityService.isConnected) {
      return const SizedBox.shrink();
    }
    
    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade700, Colors.red.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedIcon(),
            const SizedBox(width: 12),
            const Text(
              'Sin conexión a internet',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Verifica tu red',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAnimatedIcon() {
    return TweenAnimationBuilder(
      duration: const Duration(seconds: 1),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.rotate(
          angle: value * 0.1 * 3.14159,
          child: const Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 20,
          ),
        );
      },
    );
  }
}

// Provider personalizado para compartir el servicio
class ConnectivityProvider extends InheritedWidget {
  final ConnectivityService connectivityService;
  
  const ConnectivityProvider({
    super.key,
    required this.connectivityService,
    required super.child,
  });
  
  static ConnectivityService of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ConnectivityProvider>();
    assert(provider != null, 'No ConnectivityProvider found in context');
    return provider!.connectivityService;
  }
  
  @override
  bool updateShouldNotify(ConnectivityProvider oldWidget) {
    return connectivityService != oldWidget.connectivityService;
  }
}