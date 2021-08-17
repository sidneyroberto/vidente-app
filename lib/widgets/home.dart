import 'package:flutter/material.dart';
import 'package:vidente_app/models/cidade.dart';
import 'package:vidente_app/models/previsao_hora.dart';
import 'package:vidente_app/services/cidade_service.dart';
import 'package:vidente_app/services/previsao_service.dart';
import 'package:vidente_app/widgets/configuracoes.dart';
import 'package:vidente_app/widgets/proximas_temperaturas.dart';
import 'package:vidente_app/widgets/resumo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<PrevisaoHora>> ultimasPrevisoes;
  List<Cidade> cidades;

  @override
  void initState() {
    super.initState();
    carregarPrevisoes();
    carregarCidades();
  }

  void carregarPrevisoes() {
    PrevisaoService service = PrevisaoService();
    ultimasPrevisoes = service.recuperarUltimasPrevisoes();
  }

  void carregarCidades() async {
    CidadeService service = CidadeService();
    cidades = await service.recuperarCidades();
  }

  Future<Null> atualizarPrevisoes() async {
    setState(() => carregarPrevisoes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Vidente'),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Configuracoes(
                        cidades: this.cidades,
                      )));
            },
            child: Icon(
              Icons.settings, // add custom icons also
            ),
          )),
      body: RefreshIndicator(
        onRefresh: atualizarPrevisoes,
        child: Center(
          child: FutureBuilder<List<PrevisaoHora>>(
            future: ultimasPrevisoes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<PrevisaoHora> previsoes = snapshot.data;
                double temperaturaAtual = previsoes[0].temperatura;
                double menorTemperatura = double.maxFinite;
                double maiorTemperatura = double.negativeInfinity;
                previsoes.forEach((obj) {
                  if (obj.temperatura < menorTemperatura) {
                    menorTemperatura = obj.temperatura;
                  }

                  if (obj.temperatura > maiorTemperatura) {
                    maiorTemperatura = obj.temperatura;
                  }
                });

                String descricao = previsoes[0].descricao;
                int numeroIcone = previsoes[0].numeroIcone;

                return Column(
                  children: [
                    Resumo(
                      cidade: 'Aquidauana-MS',
                      temperaturaAtual: temperaturaAtual,
                      temperaturaMaxima: maiorTemperatura,
                      temperaturaMinima: menorTemperatura,
                      descricao: descricao,
                      numeroIcone: numeroIcone,
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    ProximasTemperaturas(
                      previsoes: previsoes.sublist(1, previsoes.length),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Erro ao carregar as previsões');
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
