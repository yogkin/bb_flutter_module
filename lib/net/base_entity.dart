import 'package:bbfluttermodule/common/common.dart';
import 'package:bbfluttermodule/generated/json/base/json_convert_content.dart';

class BaseEntity<T> {
  int code;
  String msg;
  T data;

  BaseEntity(this.code, this.msg, this.data);

  BaseEntity.fromJson(Map<String, dynamic> json) {
    code = json[Constant.code] as int;
    msg = json[Constant.msg] as String;
    if (json.containsKey(Constant.data)) {
      data = _generateOBJ<T>(json[Constant.data]);
    }
  }

  T _generateOBJ<T>(Object json) {
    if (T.toString() == 'String') {
      return json.toString() as T;
    } else if (T.toString() == 'Map<dynamic, dynamic>') {
      return json as T;
    } else {
      /// List类型数据由fromJsonAsT判断处理
      return JsonConvert.fromJsonAsT<T>(json);
    }
  }
}
