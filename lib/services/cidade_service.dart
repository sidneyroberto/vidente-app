import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:vidente_app/controllers/cidade_controller.dart';
import 'package:vidente_app/models/cidade.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class CidadeService {
  final String baseUrlAPI = 'dataservice.accuweather.com';
  final String path = '/locations/v1/cities/search';
  final Map<String, String> params = {
    'apikey': env['API_KEY'],
    'language': 'pt-BR'
  };

  pesquisarCidade(String filtro) async {
    params['q'] = filtro;

    final Response resposta = await get(Uri.https(baseUrlAPI, path, params));
    if (resposta.statusCode == 200) {
      Iterable it = await json.decode(resposta.body);
      Cidade cidade = Cidade.transformarJSON(it.first);
      CidadeController.instancia.trocarCidade(cidade);
    } else {
      throw Exception('Erro ao tentar pesquisar a cidade');
    }
  }

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

    /**
     * Realiza a ordenação das cidades em ordem alfabética
     */
    cidadesCarregadas.sort((a, b) => a.nome.compareTo(b.nome));

    return cidadesCarregadas;
  }
}
