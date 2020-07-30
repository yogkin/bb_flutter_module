import 'package:bbfluttermodule/page/ensure_money/models/ensure_top_info_bean_entity_entity.dart';

ensureTopInfoBeanEntityEntityFromJson(EnsureTopInfoBeanEntityEntity data, Map<String, dynamic> json) {
	if (json['supplyId'] != null) {
		data.supplyId = json['supplyId']?.toInt();
	}
	if (json['currentAmount'] != null) {
		data.currentAmount = json['currentAmount']?.toInt();
	}
	if (json['unPayAmount'] != null) {
		data.unPayAmount = json['unPayAmount']?.toInt();
	}
	if (json['needSecurityAmount'] != null) {
		data.needSecurityAmount = json['needSecurityAmount']?.toInt();
	}
	if (json['pointPayType'] != null) {
		data.pointPayType = json['pointPayType']?.toInt();
	}
	if (json['protocol'] != null) {
		data.protocol = json['protocol']?.toString();
	}
	if (json['securityAmountText'] != null) {
		data.securityAmountText = json['securityAmountText']?.toString();
	}
	return data;
}

Map<String, dynamic> ensureTopInfoBeanEntityEntityToJson(EnsureTopInfoBeanEntityEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['supplyId'] = entity.supplyId;
	data['currentAmount'] = entity.currentAmount;
	data['unPayAmount'] = entity.unPayAmount;
	data['needSecurityAmount'] = entity.needSecurityAmount;
	data['pointPayType'] = entity.pointPayType;
	data['protocol'] = entity.protocol;
	data['securityAmountText'] = entity.securityAmountText;
	return data;
}