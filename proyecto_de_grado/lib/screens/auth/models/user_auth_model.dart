class UserAuthModel {
  final String id;
  final String email;
  final String name;
  final String lastName;
  final String role;
  final String? phone;
  final String? photoUrl;
  final bool emailVerified;
  final DateTime createdAt;
  final NotificationPreferences notificationPreferences;

  UserAuthModel({
    required this.id,
    required this.email,
    required this.name,
    required this.lastName,
    required this.role,
    this.phone,
    this.photoUrl,
    this.emailVerified = false,
    required this.createdAt,
    required this.notificationPreferences,
  });

  String get fullName => '$name $lastName';
  String get initials => '${name[0]}${lastName[0]}'.toUpperCase();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'lastName': lastName,
      'role': role,
      'phone': phone,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
      'createdAt': createdAt.toIso8601String(),
      'notificationPreferences': notificationPreferences.toMap(),
    };
  }

  factory UserAuthModel.fromMap(Map<String, dynamic> map) {
    return UserAuthModel(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      lastName: map['lastName'],
      role: map['role'],
      phone: map['phone'],
      photoUrl: map['photoUrl'],
      emailVerified: map['emailVerified'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      notificationPreferences: NotificationPreferences.fromMap(map['notificationPreferences']),
    );
  }
}

class NotificationPreferences {
  final bool medicationReminders;
  final bool appointmentReminders;
  final bool reportAlerts;
  final bool familyUpdates;

  NotificationPreferences({
    this.medicationReminders = true,
    this.appointmentReminders = true,
    this.reportAlerts = true,
    this.familyUpdates = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'medicationReminders': medicationReminders,
      'appointmentReminders': appointmentReminders,
      'reportAlerts': reportAlerts,
      'familyUpdates': familyUpdates,
    };
  }

  factory NotificationPreferences.fromMap(Map<String, dynamic> map) {
    return NotificationPreferences(
      medicationReminders: map['medicationReminders'] ?? true,
      appointmentReminders: map['appointmentReminders'] ?? true,
      reportAlerts: map['reportAlerts'] ?? true,
      familyUpdates: map['familyUpdates'] ?? false,
    );
  }

  NotificationPreferences copyWith({
    bool? medicationReminders,
    bool? appointmentReminders,
    bool? reportAlerts,
    bool? familyUpdates,
  }) {
    return NotificationPreferences(
      medicationReminders: medicationReminders ?? this.medicationReminders,
      appointmentReminders: appointmentReminders ?? this.appointmentReminders,
      reportAlerts: reportAlerts ?? this.reportAlerts,
      familyUpdates: familyUpdates ?? this.familyUpdates,
    );
  }
}