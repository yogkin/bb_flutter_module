import 'package:bbfluttermodule/generated/json/base/json_convert_content.dart';

class EnsureTopInfoBeanEntityEntity
    with JsonConvert<EnsureTopInfoBeanEntityEntity> {
	int supplyId;
  num currentAmount;
  num unPayAmount;
  num needSecurityAmount;
  int pointPayType;
  String protocol;
  String securityAmountText;
}
