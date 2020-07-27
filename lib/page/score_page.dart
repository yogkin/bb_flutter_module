import 'dart:convert';

import 'package:bbfluttermodule/bean/score_bean.dart';
import 'package:bbfluttermodule/common/color_utils.dart';
import 'package:bbfluttermodule/widget/base_bar_view.dart';
import 'package:bbfluttermodule/widget/title_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

class ScorePage extends StatelessWidget {

  static const scoreJsonStr =
      "[{\"title\":\"积分计算方法：\",\"data\":[\"100分=2万元保证金，1分=200元。\",\"每月5日计算上一个自然月的发货填写率及发货准确 率。\",\"若发货填写率>90%（不含），每多1%加1分；若发货填写率在60%（含）~90%（含）之间，则不奖不扣； 若发货填写率<60\",\"若发货准确率>95%（不含），每多1%加2分；若发货准确率在85%（含）~95%（含）之间，则不奖不 扣；若发货准确率<85\"]},{\"title\":\"积分使用方法：\",\"data\":[\"100分=2万元保证金，1分=200元。\",\"每月5日计算上一个自然月的发货填写率及发货准确 率。\",\"若发货填写率>90%（不含），每多1%加1分；若发货填写率在60%（含）~90%（含）之间，则不奖不扣； 若发货填写率<60\",\"若发货准确率>95%（不含），每多1%加2分；若发货准确率在85%（含）~95%（含）之间，则不奖不 扣；若发货准确率<85\"]}]";

  final scoreBean = (jsonDecode(scoreJsonStr) as List)
      .map((e) => ScoreBean.fromJson(e))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            }),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
          child: Text(
            "积分",
            style: TextStyle(
              color: Color(0xff333333),
              fontSize: 17,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[_item(0), _item(1)],
      ),
    );
  }

  Widget _item(int index) {
    final bean = scoreBean[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 25, 0, 0),
          child: Text(
            bean.title,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(51, 51, 51, 1)),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(15, 14, 15, 14),
          padding: EdgeInsets.fromLTRB(10, 17, 10, 17),
          decoration: BoxDecoration(
            color: Color(0xffFFFCF5),
            border: Border.all(color: Color(0xffFFF3D8), width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: bean.data.length,
              controller: ScrollController(),
              itemBuilder: (context, index) {
                return _listItem(bean.data[index], index);
              }),
        )
      ],
    );
  }

  Widget _listItem(String data, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0,0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipOval(
            child: Container(
              color: Color(0xffFFCA67),
              width: 17,
              height: 17,
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
            child: Text("$data"),
          ))
        ],
      ),
    );
  }
}
