import 'package:flutter_logger/components/logger/logger.dart';

enum Environment {
  debug,
  profile,
  release,
}

class Environments {
  static Level _config = Level.verbose;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.debug:
        _config = _Config.maxDisplayLevel[Environment.debug.index];
        break;
      case Environment.profile:
        _config = _Config.maxDisplayLevel[Environment.profile.index];
        break;
      case Environment.release:
        _config = _Config.maxDisplayLevel[Environment.release.index];
        break;
    }
  }

  static Level get getMaxDisplayLevel {
    return _config;
  }
}

class _Config {
  static List<Level> maxDisplayLevel = [
    Level.nothing,
    Level.debug,
    Level.info,
  ];
}
