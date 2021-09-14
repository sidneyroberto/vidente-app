import 'package:flutter/material.dart';
import 'package:vidente_app/controllers/cidade_controller.dart';
import 'package:vidente_app/models/cidade.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:vidente_app/services/cidade_service.dart';

class Configuracoes extends StatefulWidget {
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  List<Cidade> cidades;
  bool carregandoCidades;

  @override
  void initState() {
    super.initState();
    carregarCidades();
    this.carregandoCidades = false;
  }

  void carregarCidades() async {
    CidadeService service = CidadeService();
    cidades = await service.recuperarCidades();
  }

  Iterable<Cidade> filtrarCidades(String consulta) {
    return this.cidades.where(
        (cidade) => cidade.nome.toLowerCase().contains(consulta.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    bool algumaCidadeEscolhida =
        CidadeController.instancia.cidadeEscolhida != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            algumaCidadeEscolhida ? "Configurações" : "Escolha uma cidade"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 60, 16, 0),
        child: Column(
          children: [
            TypeAheadField<Cidade>(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Procurar cidade',
                ),
              ),
              suggestionsCallback: filtrarCidades,
              onSuggestionSelected: (sugestao) async {
                CidadeService service = CidadeService();
                final String filtro = sugestao.nome + ' ' + sugestao.estado;
                service
                    .pesquisarCidade(filtro)
                    .then((resultado) => Navigator.pushNamed(context, '/home'));
                setState(() {
                  this.carregandoCidades = true;
                });
              },
              itemBuilder: (context, sugestao) {
                return ListTile(
                  leading: Icon(Icons.place),
                  title: Text(sugestao.nome + " - " + sugestao.siglaEstado),
                  subtitle: Text(sugestao.estado),
                );
              },
              noItemsFoundBuilder: (context) => Container(
                child: Center(
                  child: Text(
                    'Nenhuma cidade encontrada',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            this.carregandoCidades
                ? Column(
                    children: [
                      Padding(padding: EdgeInsets.all(20)),
                      Image(
                        image: AssetImage('images/loading.gif'),
                        width: 50,
                      )
                    ],
                  )
                : Text('')
          ],
        ),
      ),
    );
  }
}
