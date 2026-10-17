import 'package:flutter_test/flutter_test.dart';
import 'package:Mentora/infrastructure/environment/environment.dart';

void main() {
  group('Environment Configuration Tests', () {
    test('Default environment should be PRODUCTION', () {
      final env = ConfigEnvironments.getEnvironments();
      expect(env['env'], equals(Environments.PRODUCTION));
    });

    test('Production API Base URL should point to Railway production deployment', () {
      final env = ConfigEnvironments.getEnvironments();
      expect(
        env['url'],
        equals('https://mentora-backend-production-pro.up.railway.app/api/'),
      );
    });

    test('Base URL should use HTTPS protocol and terminate with /api/', () {
      final env = ConfigEnvironments.getEnvironments();
      final url = env['url']!;
      expect(url.startsWith('https://'), isTrue);
      expect(url.endsWith('/api/'), isTrue);
    });
  });
}
