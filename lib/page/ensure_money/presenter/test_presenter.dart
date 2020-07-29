import 'package:bbfluttermodule/mvp/base_page_presenter.dart';
import 'package:bbfluttermodule/mvp/base_presenter.dart';
import 'package:bbfluttermodule/net/dio_utils.dart';
import 'package:bbfluttermodule/net/http_api.dart';
import 'package:bbfluttermodule/page/ensure_money/iview/i_test_view.dart';
import 'package:bbfluttermodule/page/ensure_money/models/ensure_moeny_model_entity.dart';
import 'package:flutter/cupertino.dart';

class TestPresenter extends BasePagePresenter<ITestView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 接口请求例子
      /// get请求参数queryParameters  post请求参数params
      asyncRequestNetwork<EnsureMoneyModelEntity>(
        Method.get,
        url: HttpApi.users,
        onSuccess: (data) {
        },
      );
    });
  }
}
