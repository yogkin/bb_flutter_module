import 'package:bbfluttermodule/generated/json/base/json_convert_content.dart';
import 'package:bbfluttermodule/generated/json/base/json_field.dart';

class EnsureListItemBeanEntity with JsonConvert<EnsureListItemBeanEntity> {
  int total;
  int pages;
  @JSONField(name: "list")
  List<EnsureListItemBeanList> xList;
}

class EnsureListItemBeanList with JsonConvert<EnsureListItemBeanList> {
  int packagePayId;
  double payAmount;
  String payTime;
  String shopName;
  int supplyId;
  String supplyName;
  String outTradeNo;
  int payType;
  int packageType;

  String getPayType() {
    switch (payType) {
      case 1:
        return "支付宝";
      default:
        return "微信";
    }
  }
}
