import 'package:flutter_test/flutter_test.dart';
import 'package:mini_ecommerce_flutter/features/profile/models/user_profile_model.dart';

void main() {
  group('UserProfileModel Freezed Tests', () {
    test('default values are populated correctly', () {
      const profile = UserProfileModel();
      expect(profile.name, 'Budi Santoso');
      expect(profile.email, 'pelanggan@tokomini.com');
      expect(profile.customerId.isNotEmpty, true);
    });

    test('copyWith updates fields immutably', () {
      const profile = UserProfileModel();
      final updated = profile.copyWith(
        name: 'Siti Aminah',
        email: 'siti@tokomini.com',
      );

      expect(updated.name, 'Siti Aminah');
      expect(updated.email, 'siti@tokomini.com');
      expect(profile.name, 'Budi Santoso'); // Original immutable
    });

    test('JSON serialization round-trip', () {
      final json = {
        'name': 'Andi Wijaya',
        'email': 'andi@tokomini.com',
        'customerId': 'custom-guid-123',
        'address': 'Jl. Asia Afrika No. 10',
        'phone': '+62 811-2233-4455',
      };

      final profile = UserProfileModel.fromJson(json);
      expect(profile.name, 'Andi Wijaya');
      expect(profile.email, 'andi@tokomini.com');
      expect(profile.phone, '+62 811-2233-4455');
    });
  });
}
