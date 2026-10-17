class Environments {
  static const String PRODUCTION = 'prod';
  static const String QAS = 'QAS';
  static const String DEV = 'dev';
  static const String LOCAL = 'local';
}

class ConfigEnvironments {
  static const String _currentEnvironments = Environments.PRODUCTION;

  static final List<Map<String, String>> _availableEnvironments = [
    {'env': Environments.LOCAL, 'url': 'http://localhost:8080/api/'},
    {
      'env': Environments.DEV,
      'url': 'https://mentora-backend-production-pro.up.railway.app/api/',
    },
    {
      'env': Environments.QAS,
      'url': 'https://mentora-backend-production-pro.up.railway.app/api/',
    },
    {
      'env': Environments.PRODUCTION,
      'url': 'https://mentora-backend-production-pro.up.railway.app/api/',
    },
  ];

  static Map<String, String> getEnvironments() {
    return _availableEnvironments.firstWhere(
      (d) => d['env'] == _currentEnvironments,
    );
  }
}
