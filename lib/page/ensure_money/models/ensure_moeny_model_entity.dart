import 'package:bbfluttermodule/generated/json/base/json_convert_content.dart';

class EnsureMoneyModelEntity with JsonConvert<EnsureMoneyModelEntity> {
	int supplyId;
	int currentAmount;
	int unPayAmount;
	int needSecurityAmount;
	int pointPayType;
	String protocol;
	String securityAmountText;
}
