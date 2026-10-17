import 'package:flutter_test/flutter_test.dart';
import 'package:Mentora/presentation/doctor/registerDoctor/controllers/register_doctor.controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Doctor Registration Flow & Validation Tests', () {
    late RegisterDoctorController controller;

    setUp(() {
      controller = RegisterDoctorController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial stage is Step 0 (Account Credentials)', () {
      expect(controller.registrationStage.value, equals(0));
      expect(controller.hidePassword.value, isTrue);
      expect(controller.hideConfirmPassword.value, isTrue);
    });

    test('Toggle password visibility toggles hidePassword state', () {
      expect(controller.hidePassword.value, isTrue);
      controller.togglePasswordVisibility();
      expect(controller.hidePassword.value, isFalse);
      controller.togglePasswordVisibility();
      expect(controller.hidePassword.value, isTrue);
    });

    test('Toggle confirm password visibility toggles hideConfirmPassword state', () {
      expect(controller.hideConfirmPassword.value, isTrue);
      controller.toggleConfirmPasswordVisibility();
      expect(controller.hideConfirmPassword.value, isFalse);
    });

    test('Stage transition can be performed between Step 0 and Step 1', () {
      controller.registrationStage.value = 1;
      expect(controller.registrationStage.value, equals(1));

      controller.registrationStage.value = 0;
      expect(controller.registrationStage.value, equals(0));
    });

    test('Certified credentials defaults to true', () {
      expect(controller.certifiedCredentials.value, isTrue);
    });
  });
}
