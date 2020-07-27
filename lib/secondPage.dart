import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            Text("第二页"),
            //监听左上角返回和实体返回
            new WillPopScope(
                child: new Scaffold(
                    appBar: new AppBar(
                      title: new Text('RoutePageWithValue'),
                      centerTitle: true,
                    ),
                    body: new Center(
                      child: new Text("lastPageName"),
                    )),
                onWillPop: () => _requestPop(context))
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog<Null>(
      context: context,
      child: new AlertDialog(content: new Text('退出app'), actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            },
            child: new Text('确定'))
      ]),
    );
  }


  Future<bool> _requestPop(BuildContext context) {
    _showDialog(context);
    return new Future.value(false);
  }
}
