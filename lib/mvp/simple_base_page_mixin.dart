import 'package:bbfluttermodule/mvp/base_page_presenter.dart';
import 'package:flutter/material.dart';

import 'base_page.dart';
import 'base_presenter.dart';

class SimplePage<T extends StatefulWidget> extends State<T>
    with BasePageMixin<T, BasePagePresenter>, AutomaticKeepAliveClientMixin<T> {
  @override
  bool get wantKeepAlive => true;

  @override
  createPresenter() => BasePagePresenter();
}
