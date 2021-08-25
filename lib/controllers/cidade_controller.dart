import 'package:flutter/cupertino.dart';
import 'package:vidente_app/models/cidade.dart';

class CidadeController extends ChangeNotifier {
  Cidade cidadeEscolhida;
  static CidadeController instancia = CidadeController();

  CidadeController() {
    this.cidadeEscolhida =
        new Cidade.comCodigo('38802', 'Aquidauana', 'Mato Grosso do Sul', 'MS');
  }

  trocarCidade(Cidade cidade) {
    this.cidadeEscolhida = cidade;
    notifyListeners();
  }
}
