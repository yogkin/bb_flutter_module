
import 'package:bbfluttermodule/res/dimens.dart';
import 'package:bbfluttermodule/res/gaps.dart';
import 'package:bbfluttermodule/util/theme_utils.dart';
import 'package:bbfluttermodule/widget/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// design/9暂无状态页面/index.html#artboard3
class StateLayout extends StatelessWidget {
  
  const StateLayout({
    Key key,
    @required this.type,
    this.hintText
  }):super(key: key);
  
  final StateType type;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (type == StateType.loading)
          const CupertinoActivityIndicator(radius: 16.0)
        else
          if (type != StateType.empty)
            Opacity(
              opacity: ThemeUtils.isDark(context) ? 0.5 : 1,
              child: LoadAssetImage(
                'state/${type.img}',
                width: 120,
              ),
            ),
        const SizedBox(width: double.infinity, height: Dimens.gap_dp16,),
        Text(
          hintText ?? type.hintText,
          style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: Dimens.font_sp14),
        ),
        Gaps.vGap50,
      ],
    );
  }
}

enum StateType {
  /// 订单
  order,
  /// 商品
  goods,
  /// 无网络
  network,
  /// 消息
  message,
  /// 无提现账号
  account,
  /// 加载中
  loading,
  /// 空
  empty
}

extension StateTypeExtension on StateType {
  String get img => [
    'zwdd', 'zwsp', 
    'zwwl', 'zwxx', 
    'zwzh', '', '']
  [index];
  
  String get hintText => [
    '暂无订单', '暂无商品', 
    '无网络连接', '暂无消息', 
    '马上添加提现账号吧', '', ''
  ][index];
}