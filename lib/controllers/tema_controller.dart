import 'package:flutter/material.dart';

class TemaController extends ChangeNotifier {
  bool usarTemaEscuro;
  static TemaController instancia = TemaController();

  TemaController() {
    usarTemaEscuro = false;
  }

  trocarTema() {
    usarTemaEscuro = !usarTemaEscuro;
    notifyListeners();
  }
}
