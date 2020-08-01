import 'package:bbfluttermodule/page/ensure_money/models/ensure_list_item_bean_entity.dart';

ensureListItemBeanEntityFromJson(EnsureListItemBeanEntity data, Map<String, dynamic> json) {
	if (json['total'] != null) {
		data.total = json['total']?.toInt();
	}
	if (json['pages'] != null) {
		data.pages = json['pages']?.toInt();
	}
	if (json['list'] != null) {
		data.xList = new List<EnsureListItemBeanList>();
		(json['list'] as List).forEach((v) {
			data.xList.add(new EnsureListItemBeanList().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> ensureListItemBeanEntityToJson(EnsureListItemBeanEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['total'] = entity.total;
	data['pages'] = entity.pages;
	if (entity.xList != null) {
		data['list'] =  entity.xList.map((v) => v.toJson()).toList();
	}
	return data;
}

ensureListItemBeanListFromJson(EnsureListItemBeanList data, Map<String, dynamic> json) {
	if (json['packagePayId'] != null) {
		data.packagePayId = json['packagePayId']?.toInt();
	}
	if (json['payAmount'] != null) {
		data.payAmount = json['payAmount']?.toDouble();
	}
	if (json['payTime'] != null) {
		data.payTime = json['payTime']?.toString();
	}
	if (json['shopName'] != null) {
		data.shopName = json['shopName']?.toString();
	}
	if (json['supplyId'] != null) {
		data.supplyId = json['supplyId']?.toInt();
	}
	if (json['supplyName'] != null) {
		data.supplyName = json['supplyName']?.toString();
	}
	if (json['outTradeNo'] != null) {
		data.outTradeNo = json['outTradeNo']?.toString();
	}
	if (json['payType'] != null) {
		data.payType = json['payType']?.toInt();
	}
	if (json['packageType'] != null) {
		data.packageType = json['packageType']?.toInt();
	}
	return data;
}

Map<String, dynamic> ensureListItemBeanListToJson(EnsureListItemBeanList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['packagePayId'] = entity.packagePayId;
	data['payAmount'] = entity.payAmount;
	data['payTime'] = entity.payTime;
	data['shopName'] = entity.shopName;
	data['supplyId'] = entity.supplyId;
	data['supplyName'] = entity.supplyName;
	data['outTradeNo'] = entity.outTradeNo;
	data['payType'] = entity.payType;
	data['packageType'] = entity.packageType;
	return data;
}