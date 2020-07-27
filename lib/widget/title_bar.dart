import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TitleBar extends StatelessWidget {

  final String title;

  TitleBar(this.title);


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: Stack(
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            child: IconButton(
              icon: Image.asset("static/images/icon_back_black.png"),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              },
            ),
          ),
          Container(
            child: Text(title),
          )
        ],
      ),
    );
  }


}