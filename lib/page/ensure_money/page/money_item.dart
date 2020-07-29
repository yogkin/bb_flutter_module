import 'package:flutter/material.dart';

class MoneyItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      margin: EdgeInsets.fromLTRB(14, 11, 14, 0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "保证金充值",
                  style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: Text(
                  "2020-05-10",
                  style: TextStyle(color: Color(0xFF999999), fontSize: 9),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
