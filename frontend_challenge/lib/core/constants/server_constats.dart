import 'dart:io';

class ApiConfig {
  final bool isHttps;
  final String host;
  final int port;
  final String prefix;

  const ApiConfig({
    required this.host,
    required this.port,
    required this.prefix,
    this.isHttps = false,
  });
}

class Environment {
  late final ApiConfig _config;

  Environment([ApiConfig? config]) {
    if (config != null) {
      _config = config;
      return;
    }
    _config = const ApiConfig(
      host: 'tots-challenge.fly.dev',
      port: 8080,
      prefix: 'api',
      isHttps: true,
    );
  }

  String get baseUrl {
    final host =
        Platform.isAndroid && ['localhost', '127.0.0.1'].contains(_config.host)
            ? '10.0.2.2'
            : _config.host;

    return '${_config.isHttps ? 'https' : 'http'}://$host/${_config.prefix}';
  }
}
