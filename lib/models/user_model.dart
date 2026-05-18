class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? companyId;
  final String status;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.companyId,
    required this.status,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      role: map['role'],
      companyId: map['company_id'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'company_id': companyId,
      'status': status,
    };
  }
}