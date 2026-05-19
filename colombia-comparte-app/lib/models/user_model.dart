class UserModel {
  final String name;
  final String email;
  final String role;
  final String? country;
  final String token;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    this.country,
    required this.token,
  });

  bool get isSuperAdmin => role == 'superadmin';
  bool get isAdminPais => role == 'admin_pais';
  bool get isEditor => role == 'editor';

  factory UserModel.fromPrefs(Map<String, String?> prefs) {
    return UserModel(
      name: prefs['name'] ?? '',
      email: prefs['email'] ?? '',
      role: prefs['role'] ?? '',
      country: prefs['country'],
      token: prefs['token'] ?? '',
    );
  }
}