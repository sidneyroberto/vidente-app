import 'package:flutter/cupertino.dart';
import 'package:vidente_app/models/cidade.dart';

class CidadeController extends ChangeNotifier {
  Cidade cidadeEscolhida;
  static CidadeController instancia = CidadeController();

  CidadeController() {
    this.cidadeEscolhida = null;
  }

  trocarCidade(Cidade cidade) {
    this.cidadeEscolhida = cidade;
    notifyListeners();
  }
}
