import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:vidente_app/models/cidade.dart';

class CidadeService {
  Future<List<Cidade>> recuperarCidades() async {
    final String resposta = await rootBundle.loadString("data/cidades.json");
    final dados = await json.decode(resposta);
    List<Cidade> cidadesCarregadas = [];
    final List<dynamic> estados = dados["estados"];
    estados.forEach((estado) {
      final String nomeEstado = estado["nome"];
      final String siglaEstado = estado["sigla"];
      final List<dynamic> cidadesDoEstado = estado["cidades"];
      cidadesDoEstado.forEach((nomeCidade) {
        final Cidade cidade = Cidade(nomeCidade, nomeEstado, siglaEstado);
        cidadesCarregadas.add(cidade);
      });
    });

    return cidadesCarregadas;
  }
}
