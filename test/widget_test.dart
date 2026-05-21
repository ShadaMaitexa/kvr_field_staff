import 'package:flutter_test/flutter_test.dart';
import 'package:kvr_field_staff/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    test('UserModel.fromMap maps correctly', () {
      final map = {
        'id': 'user-123',
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': 'staff',
        'company_id': 'company-456',
        'status': 'active',
      };

      final user = UserModel.fromMap(map);

      expect(user.id, 'user-123');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.role, 'staff');
      expect(user.companyId, 'company-456');
      expect(user.status, 'active');
    });

    test('UserModel.toMap maps correctly', () {
      final user = UserModel(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
        role: 'staff',
        companyId: 'company-456',
        status: 'active',
      );

      final map = user.toMap();

      expect(map['id'], 'user-123');
      expect(map['name'], 'John Doe');
      expect(map['email'], 'john@example.com');
      expect(map['role'], 'staff');
      expect(map['company_id'], 'company-456');
      expect(map['status'], 'active');
    });
  });
}
