import '../models/user_model.dart';

class UserService {
  static List<UserModel> _users = [
    UserModel(
      id: '1',
      name: 'Carlos Pérez',
      email: 'carlos.perez@email.com',
      role: 'Adulto Mayor',
      phone: '+51 987 654 321',
      address: 'Av. Principal 123, Lima',
      doctor: 'Dr. Roberto Gómez',
      emergencyContact: 'María López - +51 987 654 322',
      medications: ['Losartán 50mg', 'Metformina 850mg'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      isActive: true,
    ),
    UserModel(
      id: '2',
      name: 'María López',
      email: 'maria.lopez@email.com',
      role: 'Familiar/Cuidador',
      phone: '+51 987 654 323',
      address: 'Av. Secundaria 456, Lima',
      doctor: null,
      emergencyContact: 'Carlos Pérez - +51 987 654 321',
      medications: [],
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      isActive: true,
    ),
    UserModel(
      id: '3',
      name: 'Dr. Roberto Gómez',
      email: 'rgomez@hospital.com',
      role: 'Médico',
      phone: '+51 987 654 324',
      address: 'Clínica Salud, San Isidro',
      doctor: null,
      emergencyContact: null,
      medications: [],
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      isActive: true,
    ),
  ];

  static List<UserModel> getUsers() {
    return _users.where((user) => user.isActive).toList();
  }

  static void addUser(UserModel user) {
    _users.add(user);
  }

  static void updateUser(UserModel user) {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
  }

  static void deleteUser(String userId) {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _users[index] = UserModel(
        id: _users[index].id,
        name: _users[index].name,
        email: _users[index].email,
        role: _users[index].role,
        phone: _users[index].phone,
        address: _users[index].address,
        doctor: _users[index].doctor,
        emergencyContact: _users[index].emergencyContact,
        medications: _users[index].medications,
        createdAt: _users[index].createdAt,
        isActive: false,
      );
    }
  }

  static UserModel? getUserById(String id) {
    return _users.firstWhere((user) => user.id == id && user.isActive);
  }
}