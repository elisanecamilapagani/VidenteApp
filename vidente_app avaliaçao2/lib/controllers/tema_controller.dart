import 'package:flutter/material.dart';
import 'package:vidente_app/models/tema.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TemaController extends ChangeNotifier {
  Tema temaEscolhido;
  static TemaController instancia = TemaController();
  Future<Database> database;

  // TemaController() {
  //   usarTemaEscuro = false;
  // }

  inicializarDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    this.database = openDatabase(join(await getDatabasesPath(), 'tema.db'),
        version: 1, onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE temas (id INTEGER PRIMARY KEY, codigo INTERGER)');
    });
  }

  inicializarTema() async {
    final db = await this.database;
    List<Map<String, dynamic>> temas = await db.query('temas');
    this.temaEscolhido = temas.length > 0 ? Tema(temas[0]['codigo']) : null;
  }

  salvarTema(Tema tema) async {
    final db = await this.database;
    List<Map<String, dynamic>> temas = await db.query('temas');

    /**
     * Se já existe um registro, 
     * deve atualiza-lo
     */
    if (temas.length > 0) {
      await db.update(
        'temas',
        tema.toMap(),
        where: 'id = ?',
        whereArgs: [1],
      );
    } else {
      /**
       * Se ainda não existe um registro,
       * deve salva-lo pela primeira vez
       */
      await db.insert(
        'temas',
        tema.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  trocarTema(Tema tema) {
    this.temaEscolhido = tema;
    salvarTema(temaEscolhido);
    notifyListeners();
  }
}
