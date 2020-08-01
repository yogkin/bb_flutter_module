import 'package:bbfluttermodule/res/resources.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bbfluttermodule/page/ensure_money/models/ensure_list_item_bean_entity.dart';
import 'package:bbfluttermodule/res/styles.dart';
import 'package:bbfluttermodule/widget/load_image.dart';

class MoneyItem extends StatelessWidget {
  final EnsureListItemBeanList bean;
  final Function(EnsureListItemBeanList bean) click;

  const MoneyItem({
    Key key,
    @required this.bean,
    this.click,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => click.call(bean),
      child: Container(
        height: 46,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "保证金充值",
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF333333)),
                      ),
                    ),
                    Gaps.vGap4,
                    Text(
                      bean.payTime,
                      style: TextStyle(color: Color(0xFF999999), fontSize: 9),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      bean.payAmount.toStringAsFixed(2),
                      style: TextStyles.textSize12,
                    ),
                    Gaps.hGap4,
                    LoadAssetImage(
                      "ic_arrow_right_black_small",
                      width: 4,
                      height: 7,
                    )
                  ],
                )
              ],
            ),
            Expanded(child: Gaps.line)
          ],
        ),
      ),
    );
  }
}
