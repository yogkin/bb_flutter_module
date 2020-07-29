import 'package:bbfluttermodule/mvp/base_page_presenter.dart';
import 'package:bbfluttermodule/mvp/base_presenter.dart';
import 'package:bbfluttermodule/net/dio_utils.dart';
import 'package:bbfluttermodule/net/http_api.dart';
import 'package:bbfluttermodule/page/ensure_money/models/ensure_moeny_model_entity.dart';
import 'file:///D:/bb_flutter_module/bb_flutter_module/lib/page/ensure_money/iview/i_ensure_money.dart';
import 'package:flutter/cupertino.dart';

class EnsureMoneyPresenter extends BasePagePresenter<IEnsureView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 接口请求例子
      /// get请求参数queryParameters  post请求参数params
      asyncRequestNetwork<EnsureMoneyModelEntity>(
        Method.get,
        url: HttpApi.users,
        onSuccess: (data) {
          view.setTopData(data);
        },
      );
    });
  }
}
