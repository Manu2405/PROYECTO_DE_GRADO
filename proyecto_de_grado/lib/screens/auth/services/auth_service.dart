import '../models/user_auth_model.dart';

class AuthService {
  static final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'email': 'carlos@vitasenior.com',
      'password': '123456',
      'name': 'Carlos',
      'lastName': 'Pérez',
      'role': 'Adulto Mayor',
      'phone': '+51 987 654 321',
      'photoUrl': null,
      'emailVerified': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 30)),
    },
    {
      'id': '2',
      'email': 'maria@vitasenior.com',
      'password': '123456',
      'name': 'María',
      'lastName': 'López',
      'role': 'Familiar/Cuidador',
      'phone': '+51 987 654 322',
      'photoUrl': null,
      'emailVerified': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 25)),
    },
    {
      'id': '3',
      'email': 'drroberto@vitasenior.com',
      'password': '123456',
      'name': 'Roberto',
      'lastName': 'Gómez',
      'role': 'Médico',
      'phone': '+51 987 654 323',
      'photoUrl': null,
      'emailVerified': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 20)),
    },
    {
      'id': '4',
      'email': 'admin@vitasenior.com',
      'password': 'admin123',
      'name': 'Admin',
      'lastName': 'Sistema',
      'role': 'Administrador',
      'phone': '+51 987 654 324',
      'photoUrl': null,
      'emailVerified': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 15)),
    },
  ];

  static UserAuthModel? _currentUser;

  static UserAuthModel? get currentUser => _currentUser;

  static Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final userData = _users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => throw Exception('Credenciales incorrectas'),
    );
    
    _currentUser = UserAuthModel(
      id: userData['id'],
      email: userData['email'],
      name: userData['name'],
      lastName: userData['lastName'],
      role: userData['role'],
      phone: userData['phone'],
      photoUrl: userData['photoUrl'],
      emailVerified: userData['emailVerified'],
      createdAt: userData['createdAt'],
      notificationPreferences: NotificationPreferences(),
    );
    
    return true;
  }

  static Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String lastName,
    required String role,
    String? phone,
    String? photoUrl,  // ← Agregado el parámetro photoUrl
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final existingUser = _users.any((u) => u['email'] == email);
    if (existingUser) {
      throw Exception('El correo ya está registrado');
    }
    
    final newUser = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'email': email,
      'password': password,
      'name': name,
      'lastName': lastName,
      'role': role,
      'phone': phone,
      'photoUrl': photoUrl,  // ← Guardar la foto
      'emailVerified': false,
      'createdAt': DateTime.now(),
    };
    
    _users.add(newUser);
    
    return true;
  }

  static Future<bool> recoverPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final userExists = _users.any((u) => u['email'] == email);
    if (!userExists) {
      throw Exception('El correo no está registrado');
    }
    
    return true;
  }

  static Future<bool> updateProfile({
    String? name,
    String? lastName,
    String? phone,
    String? photoUrl,
    NotificationPreferences? notificationPreferences,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (_currentUser != null) {
      _currentUser = UserAuthModel(
        id: _currentUser!.id,
        email: _currentUser!.email,
        name: name ?? _currentUser!.name,
        lastName: lastName ?? _currentUser!.lastName,
        role: _currentUser!.role,
        phone: phone ?? _currentUser!.phone,
        photoUrl: photoUrl ?? _currentUser!.photoUrl,
        emailVerified: _currentUser!.emailVerified,
        createdAt: _currentUser!.createdAt,
        notificationPreferences: notificationPreferences ?? _currentUser!.notificationPreferences,
      );
      
      // Actualizar en la lista simulada
      final index = _users.indexWhere((u) => u['id'] == _currentUser!.id);
      if (index != -1) {
        _users[index]['name'] = _currentUser!.name;
        _users[index]['lastName'] = _currentUser!.lastName;
        _users[index]['phone'] = _currentUser!.phone;
        _users[index]['photoUrl'] = _currentUser!.photoUrl;
      }
      
      return true;
    }
    return false;
  }

  static Future<bool> changePassword(String currentPassword, String newPassword) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (_currentUser != null) {
      final userIndex = _users.indexWhere((u) => u['id'] == _currentUser!.id);
      if (userIndex != -1 && _users[userIndex]['password'] == currentPassword) {
        _users[userIndex]['password'] = newPassword;
        return true;
      }
      throw Exception('Contraseña actual incorrecta');
    }
    return false;
  }

  static void logout() {
    _currentUser = null;
  }

  static String getRoleRedirect(UserAuthModel user) {
    switch (user.role) {
      case 'Adulto Mayor':
        return '/adulto';
      case 'Familiar/Cuidador':
        return '/familiar';
      case 'Médico':
        return '/medico';
      case 'Administrador':
        return '/admin';
      default:
        return '/login';
    }
  }
}