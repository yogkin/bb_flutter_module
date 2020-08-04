import 'dart:convert';
import 'dart:ffi';

import 'package:bbfluttermodule/common/color_utils.dart';
import 'package:bbfluttermodule/mvp/base_page.dart';
import 'package:bbfluttermodule/mvp/base_page_presenter.dart';
import 'package:bbfluttermodule/mvp/base_presenter.dart';
import 'package:bbfluttermodule/mvp/mvps.dart';
import 'package:bbfluttermodule/mvp/simple_base_page_mixin.dart';
import 'package:bbfluttermodule/net/dio_utils.dart';
import 'package:bbfluttermodule/page/ensure_money/iview/i_ensure_money.dart';
import 'package:bbfluttermodule/page/ensure_money/models/ensure_moeny_model_entity.dart';
import 'package:bbfluttermodule/page/ensure_money/models/ensure_top_info_bean_entity_entity.dart';
import 'package:bbfluttermodule/page/ensure_money/presenter/ensure_money_presenter.dart';
import 'package:bbfluttermodule/res/dimens.dart';
import 'package:bbfluttermodule/res/resources.dart';
import 'package:bbfluttermodule/util/base_list_provider.dart';
import 'package:bbfluttermodule/util/utils.dart';
import 'package:bbfluttermodule/widget/base_dialog.dart';
import 'package:bbfluttermodule/widget/load_image.dart';
import 'package:bbfluttermodule/widget/my_refresh_list.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'money_item.dart';
import 'package:bbfluttermodule/widget/state_layout.dart';
import 'package:bbfluttermodule/page/ensure_money/models/ensure_list_item_bean_entity.dart';
import 'package:markdown/markdown.dart' as md;

class EnsureMoney extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EnsureMoneyState();

  const EnsureMoney({
    Key key,
  }) : super(key: key);
}

class _EnsureMoneyState extends SimplePage {
  double _unPayAmount = 0.00;

  double _currentAmount = 0.00;
  double _secureAmount = 0.00;
  String _protocol = "";
  String _info = "";

  final int pageSize = 10;

  int _page = 1;

  BaseListProvider provider = BaseListProvider<EnsureListItemBeanList>();

  MethodChannel channel = MethodChannel("baoban");

  @override
  void initState(){
    super.initState();

    /// 默认为加载中状态，本页面场景默认为空
    provider.setStateTypeNotNotify(StateType.empty);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      presenter.asyncBaoBanRequestNetwork<EnsureTopInfoBeanEntityEntity>(
          Method.get,
          url: "/app/package/pay/securityAmount/current", onSuccess: (data) {
        setState(() {
          _unPayAmount = data.unPayAmount.toDouble();
          _currentAmount = data.currentAmount.toDouble();
          _secureAmount = data.needSecurityAmount.toDouble();
          _protocol = data.securityAmountText;
          _info = data.protocol;
        });
      });
      _onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colours.bg_color,
      body: Stack(
        children: <Widget>[
          LoadAssetImage("ic_baozhengjin_bg"),
          _bodyBuilder(context)
        ],
      ),
    );
  }

  Future<void> _loadMore() {
    _page++;
    return Future.sync(() => getItemList());
  }

  void getItemList() {
    var params = {"pageSize": "$pageSize", "pageNumber": "$_page"};
    presenter.asyncBaoBanRequestNetwork<EnsureListItemBeanEntity>(Method.get,
        params: params,
        isShow: false,
        isClose: false,
        url: "/app/package/pay/securityAmount/list", onSuccess: (data) {
      if (data != null) {
        /// 具体的处理逻辑根据具体的接口情况处理，这部分可以抽离出来
        provider.setHasMore(data.xList.length == pageSize);
        if (_page == 1) {
          /// 刷新
          provider.list.clear();
          if (data.xList.isEmpty) {
            provider.setStateType(StateType.order);
          } else {
            provider.addAll(data.xList);
          }
        } else {
          provider.addAll(data.xList);
        }
      } else {
        /// 加载失败
        provider.setHasMore(false);
        provider.setStateType(StateType.network);
      }
    }, onError: (_, __) {
      /// 加载失败
      provider.setHasMore(false);
      provider.setStateType(StateType.network);
    });
  }

  Future<void> _onRefresh() {
    _page = 1;
    return Future(() {
      getItemList();
    });
  }

  Widget _bodyBuilder(BuildContext context) {
    return ChangeNotifierProvider<BaseListProvider<EnsureListItemBeanList>>(
      create: (_) => provider,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 38, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: LoadAssetImage(
                      "icon_back_black",
                      width: 16,
                      height: 16,
                    ),
                    onPressed: () {
                      SystemNavigator.pop();
                    }),
                Text(
                  "平台保证金",
                  style: TextStyles.textBold16,
                ),
                GestureDetector(
                  onTap: () {
                    showElasticDialog(
                        context: context,
                        builder: (context) => BaseDialog(
                              title: "提示",
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_info),
                              ),
                            ));
                  },
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Text(
                      "说明",
                      style: TextStyle(fontSize: 13, color: color333),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 156,
            margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(6)),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "待充余额(元):",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Gaps.vGap10,
                          Text(
                            _currentAmount.toStringAsFixed(2),
                            style: TextStyles.textBold22,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Color(0xFFEAEAEA),
                      width: 1,
                      height: 23,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text("待充余额(元):",
                                  style: Theme.of(context).textTheme.subtitle2),
                              Text(_unPayAmount.toStringAsFixed(2),
                                  style: Theme.of(context).textTheme.subtitle2)
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            padding: EdgeInsets.fromLTRB(12, 5, 12, 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                gradient: LinearGradient(colors: [
                                  Color(0xFFD0A049),
                                  Color(0xFFE3BC67),
                                ])),
                            child: InkWell(
                              onTap: () => channel
                                  .invokeMethod("go2Activity_charge_money"),
                              child: Text(
                                "保证金充值 >",
                                textAlign: TextAlign.center,
                                style: TextStyles.textWhite11,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Gaps.vGap16,
                Gaps.line,
                Gaps.vGap16,
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 17),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "*",
                          style: TextStyle(
                              color: Color(0xFFDE9238),
                              fontSize: Dimens.font_sp11)),
                      TextSpan(
                          text: "保证金余额需满足",
                          style: Theme.of(context).textTheme.subtitle2),
                      TextSpan(
                          text: "${_secureAmount.toStringAsFixed(2)}",
                          style: TextStyle(
                              color: Color(0xFFDE9238),
                              fontSize: Dimens.font_sp11)),
                      TextSpan(
                          text: ",才能成功入驻,以及保证入驻后功能 的正常使用。",
                          style: Theme.of(context).textTheme.subtitle2),
                    ])))
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 24, 0, 0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7))),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(14, 19, 0, 0),
                    child: Text(
                      "保证金流水",
                      style: TextStyles.textBold15,
                    ),
                  ),
                  Expanded(child:
                      Consumer<BaseListProvider<EnsureListItemBeanList>>(
                          builder: (_, provider, __) {
                    return BBListView(
                      itemCount: provider.list.length,
                      onRefresh: _onRefresh,
                      stateType: provider.stateType,
                      hasMore: provider.hasMore,
                      loadMore: _loadMore,
                      pageSize: pageSize,
                      itemBuilder: (_, int index) {
                        return MoneyItem(
                          bean: provider.list[index],
                          click: (bean) {
                            channel.invokeMethod(
                                "go2Activity", {"playId": json.encode(bean)});
                          },
                        );
                      },
                    );
                  }))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
