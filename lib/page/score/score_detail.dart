import 'dart:ffi';

import 'package:bbfluttermodule/page/score/page_left.dart';
import 'package:bbfluttermodule/page/score/page_right.dart';
import 'package:bbfluttermodule/widget/base_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';

class ScoreDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabBarState();
}

class _TabBarState extends State<ScoreDetail>
    with SingleTickerProviderStateMixin {
  final String dateStr = "6月16日";

  bool isFinishGetData = false;

  final tabs = ["货期填写率", "货期准确率"];
  final subTabs = ["表现：差", "表现：良"];

  TabController _controller;

  MethodChannel channel = MethodChannel("score_detail");

  final titleSelect = [
    TextStyle(fontSize: 18, color: Color(0xff333333)),
    TextStyle(fontSize: 12, color: Color(0xff11BF56))
  ];

  final titleUnSelect = [
    TextStyle(fontSize: 18, color: Color(0xff999999)),
    TextStyle(fontSize: 12, color: Color(0xff666666))
  ];

  var _leftTopStyle = TextStyle(fontSize: 18, color: Color(0xff333333));
  var _leftBottomStyle = TextStyle(fontSize: 12, color: Color(0xff11BF56));
  var _rightTopStyle = TextStyle(fontSize: 18, color: Color(0xff999999));
  var _rightBottomStyle = TextStyle(fontSize: 12, color: Color(0xff666666));

  Widget _getTab(int index) {
    if (index == 0) {
      return Column(
        children: <Widget>[
          Text("${tabs[index]}", style: _leftTopStyle),
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 14),
              child: Text("${subTabs[index]}", style: _leftBottomStyle)),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Text("${tabs[index]}", style: _rightTopStyle),
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 14),
              child: Text("${subTabs[index]}", style: _rightBottomStyle)),
        ],
      );
    }
  }

  @override
  void initState() {
    _controller = TabController(
      length: tabs.length,
      vsync: ScrollableState(),
    );

    _controller.addListener(() {
      setState(() {
        if (_controller.index == 0) {
          _leftTopStyle = titleSelect[0];
          _leftBottomStyle = titleSelect[1];
          _rightTopStyle = titleUnSelect[0];
          _rightBottomStyle = titleUnSelect[1];
        } else {
          _leftTopStyle = titleUnSelect[0];
          _leftBottomStyle = titleUnSelect[1];
          _rightTopStyle = titleSelect[0];
          _rightBottomStyle = titleSelect[1];
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _handlerData();
    return GestureDetector(
      onTap: () {
        setState(() {
          isFinishGetData = !isFinishGetData;
        });
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
              appBar: BaseViewBar(
                  childView: BaseTitleBar(
                    "$dateStr",
                    bottom: TabBar(
                      tabs: tabs
                          .asMap()
                          .keys
                          .map((index) => _getTab(index))
                          .toList(),
                      indicatorPadding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                      indicatorColor: Color(0xffFFBC1A),
                      controller: _controller,
                    ),
                    rightText: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                          color: Color(0xffE8FFF1),
                          borderRadius: BorderRadius.all(Radius.circular(9))),
                      child: Text(
                        "总体表现：差",
                        style: TextStyle(color: Color(0xff11BF56)),
                      ),
                    ),
                  ),
                  // 这里暂时用Text代替，下面会讲到
                  preferredSize: Size.fromHeight(114.0)),
              body: TabBarView(
                controller: _controller,
                children: <Widget>[ScorePageLeft(), ScorePageRight()],
              )),
          Offstage(
            offstage: isFinishGetData,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Color(0x33000000),
              child: Center(
                child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                    child: Center(child: CircularProgressIndicator())),
              ),
            ),
          )
        ],
      ),
    );
  }


  Future<Void> _handlerData() async{
    String jsonData = await channel.invokeMethod("method");
    print(jsonData);
  }

}

