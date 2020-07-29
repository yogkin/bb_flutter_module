import 'package:bbfluttermodule/page/ensure_money/models/ensure_moeny_model_entity.dart';
import 'package:flutter/material.dart';

class EnsureMoneyProvider extends ChangeNotifier {
  EnsureMoneyModelEntity _modelEntity;

  EnsureMoneyModelEntity get modelEntity => _modelEntity;

  setModelEntity(EnsureMoneyModelEntity value) {
    _modelEntity = value;
    notifyListeners();
  }
}
