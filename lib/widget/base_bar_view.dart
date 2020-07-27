import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseTitleBar extends StatelessWidget {
  String title;
  IconData leftIcon = Icons.arrow_back_ios;
  Widget rightText;
  Widget bottom;
  final VoidCallback rightClick;

  BaseTitleBar(this.title,{this.bottom,this.leftIcon, this.rightText, this.rightClick});

  @override
  Widget build(BuildContext context) {
    return new AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      bottom: bottom,
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
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Text(
          "$title",
          style: TextStyle(
            color: Color(0xff333333),
            fontSize: 17,
          ),
        ),
      ),
      centerTitle: true,
      actions: <Widget>[
        /// 右边的 布局，自己可以添加，是一个widget的一个集合，自已需求添加即可，我这里写了一个Text，和text的点击事件，
        new RightView(title: rightText, rightClick: rightClick),
      ],
    );
  }
}

/// 右边的 布局，以及点击事件
class RightView extends StatelessWidget {
  Widget title;
  VoidCallback rightClick;

  RightView({this.title, this.rightClick});

  @override
  Widget build(BuildContext context) {
    var containView;
    if (title != Null) {
      containView = new Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.0),
        child: GestureDetector(
          child: title,
          onTap: this.rightClick,
        ),
      );
    } else {
      containView = Text("");
    }
    return containView;
  }
}
class BaseViewBar extends PreferredSize {
  Widget childView;
  @override
  final Size preferredSize;

  BaseViewBar({this.preferredSize, this.childView});

  @override
  Widget build(BuildContext context) {
    Widget current = childView;
    if (childView == null) {
      current = LimitedBox(
        maxWidth: 0.0,
        maxHeight: 0.0,
        child: ConstrainedBox(constraints: const BoxConstraints.expand()),
      );
    }
    return current;
  }
}


