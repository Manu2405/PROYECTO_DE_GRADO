import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:async';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/recover_password_screen.dart';
import 'screens/auth/profile_screen.dart';
import 'screens/adulto_mayor/dashboard_adulto_screen.dart';
import 'screens/familiar_cuidador/dashboard_familiar_screen.dart';
import 'screens/medico/dashboard_medico_screen.dart';
import 'screens/admin/dashboard_admin_screen.dart';

void main() {
  runApp(const VitaSeniorApp());
}

class VitaSeniorApp extends StatelessWidget {
  const VitaSeniorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VitaSenior',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/recover-password': (context) => const RecoverPasswordScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/adulto': (context) => const DashboardAdultoScreen(),
        '/familiar': (context) => const DashboardFamiliarScreen(),
        '/medico': (context) => const DashboardMedicoScreen(),
        '/admin': (context) => const DashboardAdminScreen(),
      },
      builder: (context, child) {
        return ConnectivityWrapper(child: child!);
      },
    );
  }
}
// Wrapper principal que provee el servicio de conectividad
class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  
  const ConnectivityWrapper({super.key, required this.child});
  
  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late ConnectivityService _connectivityService;
  
  @override
  void initState() {
    super.initState();
    _connectivityService = ConnectivityService();
  }
  
  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return ConnectivityProvider(
      connectivityService: _connectivityService,
      child: Stack(
        children: [
          widget.child,
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: YouTubeStyleConnectionBar(),
          ),
        ],
      ),
    );
  }
}

// Barra estilo YouTube en la parte inferior
class YouTubeStyleConnectionBar extends StatefulWidget {
  const YouTubeStyleConnectionBar({super.key});
  
  @override
  State<YouTubeStyleConnectionBar> createState() => _YouTubeStyleConnectionBarState();
}

class _YouTubeStyleConnectionBarState extends State<YouTubeStyleConnectionBar> {
  late ConnectivityService _connectivityService;
  bool _showConnectedBar = false;
  Timer? _hideTimer;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _connectivityService = ConnectivityProvider.of(context);
    _connectivityService.addListener(_onConnectionChanged);
    _onConnectionChanged();
  }
  
  void _onConnectionChanged() {
    setState(() {
      if (_connectivityService.isConnected) {
        _showConnectedBar = true;
        _hideTimer?.cancel();
        _hideTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showConnectedBar = false;
            });
          }
        });
      } else {
        _showConnectedBar = false;
        _hideTimer?.cancel();
      }
    });
  }
  
  @override
  void dispose() {
    _hideTimer?.cancel();
    _connectivityService.removeListener(_onConnectionChanged);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (!_connectivityService.isConnected) {
      return _buildDisconnectedBar();
    }
    if (_showConnectedBar) {
      return _buildConnectedBar();
    }
    return const SizedBox.shrink();
  }
  
  Widget _buildConnectedBar() {
    return FadeInUp(
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.green.shade600,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Conectado a internet',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 12),
            Text(
              'Online',
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDisconnectedBar() {
    return FadeInUp(
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade700, Colors.red.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedIcon(),
            const SizedBox(width: 12),
            const Text(
              'Sin conexión a internet',
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _connectivityService.checkConnectivity(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text('Reintentar', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
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
          child: const Icon(Icons.wifi_off, color: Colors.white, size: 20),
        );
      },
    );
  }
}

// Service de conectividad mejorado
class ConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  
  bool _isConnected = true;
  bool get isConnected => _isConnected;
  
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
      notifyListeners();
    }
  }
  
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final bool wasConnected = _isConnected;
    
    if (results.isEmpty || results.first == ConnectivityResult.none) {
      _isConnected = false;
    } else {
      _isConnected = true;
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

// Provider personalizado
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