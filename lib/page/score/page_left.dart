import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///货期填写率
class ScorePageLeft extends StatelessWidget {
  List<String> _data = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff2f4f5),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(11, 12, 11, 12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Color(0xffFFFFF0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text.rich(
                  TextSpan(text: "已填货期/应填货期：60/100"),
                ),
                Text.rich(
                  TextSpan(text: "已填货期/应填货期：60/100"),
                ),
                Divider(),
                Text(
                  "低于60%：差，介于60%~90%：良，高于90%：优",
                  style: TextStyle(fontSize: 12, color: Color(0xff999999)),
                )
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: _data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      _getItemView(index)))
        ],
      ),
    );
  }

  _getItemView(int index) async{

    return Text("$index");
  }
}
