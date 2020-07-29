import 'package:bbfluttermodule/mvp/mvps.dart';
import 'package:bbfluttermodule/page/ensure_money/models/ensure_moeny_model_entity.dart';

abstract class IEnsureView implements IMvpView {
  void setTopData(EnsureMoneyModelEntity modelEntity);
}
