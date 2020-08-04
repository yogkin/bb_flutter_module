import 'package:flutter/foundation.dart';

class Constant {
  /// debug开关，上线需要关闭
  /// App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction = kReleaseMode;

  static bool isDriverTest = false;
  static bool isUnitTest = false;

  static const String data = 'data';
  static const String message = 'message';
  static const String msg = 'msg';
  static const String code = 'code';

  static const String keyGuide = 'keyGuide';
  static const String phone = 'phone';
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';

  static const String theme = 'AppTheme';

  static const SP_SHOP_ID = "shopId";
  static const SP_BB_BASE_URL = "bbHost";
  static const SP_ERP_BASE_URL = "erpHost";
  static const SP_PHP_BASE_URL = "phpHost";

  static String CHANNEL_SIGN = "sign";

  ///method名字
  static String CHANNEL_NAME = "baoban";

  static String CHANNEL_SIGN_BAO_BAN = "signBaoban";
  static String CHANNEL_SIGN_PHP = "signPhp";
  static String CHANNEL_SIGN_ERP = "signErp";
}
