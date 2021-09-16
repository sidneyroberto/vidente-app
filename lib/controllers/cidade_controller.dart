import 'package:flutter/cupertino.dart';
import 'package:vidente_app/models/cidade.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CidadeController extends ChangeNotifier {
  Cidade cidadeEscolhida;
  static CidadeController instancia = CidadeController();
  Future<Database> database;

  inicializarDB() async {
    /**
     * Tem que executar esse trem aqui
     */
    WidgetsFlutterBinding.ensureInitialized();
    this.database = openDatabase(join(await getDatabasesPath(), 'vidente3.db'),
        version: 1, onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE cidades (id INTEGER PRIMARY KEY, codigo TEXT, nome TEXT, estado TEXT, siglaEstado TEXT)');
    });
  }

  inicializarCidade() async {
    final db = await this.database;
    List<Map<String, dynamic>> cidades = await db.query('cidades');
    this.cidadeEscolhida = cidades.length > 0
        ? Cidade.comCodigo(cidades[0]['codigo'], cidades[0]['nome'],
            cidades[0]['estado'], cidades[0]['siglaEstado'])
        : null;
  }

  salvarCidade(Cidade cidade) async {
    final db = await this.database;
    List<Map<String, dynamic>> cidades = await db.query('cidades');

    /**
     * Se já existe um registro,
     * deve atualiza-lo
     */
    if (cidades.length > 0) {
      await db.update(
        'cidades',
        cidade.toMap(),
        where: 'id = ?',
        whereArgs: [1],
      );
    } else {
      /**
       * Se ainda não existe um registro,
       * deve salva-lo pela primeira vez
       */
      await db.insert(
        'cidades',
        cidade.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  trocarCidade(Cidade cidade) {
    this.cidadeEscolhida = cidade;
    salvarCidade(cidade);
    notifyListeners();
  }
}
