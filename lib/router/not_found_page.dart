import 'package:bbfluttermodule/widget/my_app_bar.dart';
import 'package:bbfluttermodule/widget/state_layout.dart';
import 'package:flutter/material.dart';


class NotFoundPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(
        centerTitle: '页面不存在',
      ),
      body: StateLayout(
        type: StateType.account,
        hintText: '页面不存在',
      ),
    );
  }
}
