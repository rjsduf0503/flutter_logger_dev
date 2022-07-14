import 'package:flutter_logger/models/config_model.dart';
import 'package:flutter_logger/models/enums/enums.dart';

class EnvironmentsModel {
  static Level _config = Level.verbose;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.debug:
        _config = ConfigModel.maxDisplayLevel[Environment.debug.index];
        break;
      case Environment.profile:
        _config = ConfigModel.maxDisplayLevel[Environment.profile.index];
        break;
      case Environment.release:
        _config = ConfigModel.maxDisplayLevel[Environment.release.index];
        break;
    }
  }

  static Level get getMaxDisplayLevel {
    return _config;
  }
}
