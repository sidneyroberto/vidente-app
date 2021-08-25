import 'package:flutter/material.dart';
import 'package:vidente_app/models/cidade.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:vidente_app/services/cidade_service.dart';

class Configuracoes extends StatelessWidget {
  final List<Cidade> cidades;
  const Configuracoes({Key key, this.cidades}) : super(key: key);

  Iterable<Cidade> filtrarCidades(String consulta) {
    return this.cidades.where(
        (cidade) => cidade.nome.toLowerCase().contains(consulta.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 60, 16, 0),
        child: TypeAheadField<Cidade>(
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
            await service.pesquisarCidade(filtro);
            Navigator.pop(context);
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
      ),
    );
  }
}
