import 'package:bbfluttermodule/common/color_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'money_item.dart';

class EnsureMoney extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EnsureMoneyState();
  }
}

class EnsureMoneyState extends State<EnsureMoney> {
  var _ensureMoney = "19763.00";
  var _daiCongMoney = "19763.00";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            "static/images/ic_baozhengjin_bg.png",
          ),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 38, 16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Image.asset(
                          "static/images/icon_back_black.png",
                          width: 10,
                          height: 16,
                        ),
                        onPressed: () {}),
                    Text(
                      "平台保证金",
                      style: TextStyle(
                          color: color333,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6)),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "待充余额(元):",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: ColorsUtil.hexToColor("#ff666666")),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text(
                                  "19763.00",
                                  style:
                                      TextStyle(fontSize: 22, color: color333),
                                ),
                              )
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
                                      style: TextStyle(
                                          color: Color(0xFF999999),
                                          fontSize: 10)),
                                  Text(_daiCongMoney,
                                      style: TextStyle(
                                          color: Color(0xFF999999),
                                          fontSize: 13,
                                          textBaseline:
                                              TextBaseline.alphabetic))
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 0.5,
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(12, 20, 12, 0),
                      color: Color(0xFFEEEEEE),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(17, 18, 17, 0),
                        child: Text(
                          "*保证金余额需满足5万元,才能成功入驻,以及保证入驻后功能的正常使用。",
                          style:
                              TextStyle(fontSize: 11, color: Color(0xFF999999)),
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
                          topLeft: Radius.circular(7),
                          topRight: Radius.circular(7))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(14, 19, 0, 0),
                        child: Text(
                          "保证金流水",
                          style:
                              TextStyle(color: Color(0xFF333333), fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            separatorBuilder:
                                (BuildContext context, int index) => Container(
                                  margin: EdgeInsets.fromLTRB(14, 0, 0, 0),
                                  child: Divider(
                                        height: 0.5,
                                        color: Color(0xffeeeeee),
                                      ),
                                ),
                            itemCount: 90,
                            itemBuilder: (BuildContext context, int index) {
                              return MoneyItem();
                            }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
