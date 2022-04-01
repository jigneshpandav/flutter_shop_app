import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_shop_app/configs/base_config.dart';

class DevConfig implements BaseConfig {
  @override
  String get firebaseAuthKey => dotenv.env['firebaseAuthKey'] as String;

  @override
  String get baseUrl => dotenv.env['baseUrl'] as String;

  @override
  String get firebaseAuthBaseUrl => dotenv.env['firebaseAuthBaseUrl'] as String;
}
