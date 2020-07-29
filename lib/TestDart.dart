import 'package:bbfluttermodule/mvp/mvps.dart';
import 'package:bbfluttermodule/page/ensure_money/iview/i_ensure_money.dart';
import 'package:bbfluttermodule/page/ensure_money/models/ensure_moeny_model_entity.dart';
import 'package:bbfluttermodule/page/ensure_money/page/ensure_money.dart';
import 'package:bbfluttermodule/page/ensure_money/presenter/ensure_money_presenter.dart';
import 'package:bbfluttermodule/page/ensure_money/presenter/test_presenter.dart';
import 'package:bbfluttermodule/page/ensure_money/provider/ensure_money_provider.dart';
import 'package:bbfluttermodule/res/colors.dart';
import 'package:bbfluttermodule/res/gaps.dart';
import 'package:bbfluttermodule/res/styles.dart';
import 'package:bbfluttermodule/widget/load_image.dart';
import 'package:flutter/material.dart';

import 'common/color_utils.dart';
import 'mvp/base_page.dart';

class TestDart extends StatefulWidget{

  const TestDart({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>_TestDartState();

}

class _TestDartState extends State<TestDart>
    with BasePageMixin<TestDart, TestPresenter>,
        AutomaticKeepAliveClientMixin<TestDart> implements IEnsureView {

  EnsureMoneyProvider provider = EnsureMoneyProvider();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colours.bg_color,
      body: Stack(
        children: <Widget>[LoadAssetImage("ic_baozhengjin_bg"), _bodyBuilder()],
      ),
    );
  }

  Widget _bodyBuilder() {
    return Column(
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
                  onPressed: () {}),
              Text(
                "平台保证金",
                style: TextStyles.textBold16,
              ),
              Text(
                "说明",
                style: TextStyle(fontSize: 13, color: color333),
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
                        Text(
                          "19763.00",
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
                          children: <Widget>[
                            Text("待充余额(元):",
                                style: Theme.of(context).textTheme.subtitle2),
                            Text("6332",
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
                          child: Text(
                            "保证金充值 >",
                            textAlign: TextAlign.center,
                            style: TextStyles.textWhite11,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Gaps.vGap16,
              Gaps.line,
              Gaps.vGap18,
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 17),
                  child: Text(
                    "*保证金余额需满足5万元,才能成功入驻,以及保证入驻后功能的正常使用。",
                    style: Theme.of(context).textTheme.subtitle2,
                  ))
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
                    topLeft: Radius.circular(7), topRight: Radius.circular(7))),
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
                Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      separatorBuilder: (BuildContext context, int index) =>
                          Container(
                            margin: EdgeInsets.fromLTRB(14, 0, 0, 0),
                            child: Divider(
                              height: 0.5,
                              color: Color(0xffeeeeee),
                            ),
                          ),
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Text("data");
                      }),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  EnsureMoneyPresenter createPresenter() => EnsureMoneyPresenter();

  @override
  void setTopData(EnsureMoneyModelEntity modelEntity) {
    setState(() {

    });
  }

  @override
  bool get wantKeepAlive => true;
}
