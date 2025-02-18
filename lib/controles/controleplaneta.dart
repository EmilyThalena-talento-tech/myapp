import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../modelos/planeta.dart';

class Controleplaneta {
  static Database? _bd;

  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await _initBD(' planetas.db');
    return _bd!;
  }

  Future<Database> _initBD(String localArquivo) async {
    final caninhoBD = await getDatabasesPath();
    final caninho = join(caninhoBD, localArquivo);
    return await openDatabase(
    caninho, 
    version: 1, 
    onCreate: 
    _criarBD,
    );
  }
  Future<void> _criarBD(Database bd, int versao) async {
    const sql = '''
    CREATE TABLE planetas(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      tamanho REAL NOT NULL,
      distancia REAL NOT NULL,
      apelido TEXT
    )
    ''';
    await bd.execute(sql);
  }
  Future<List<Planeta>> lerPlanetas() async {
    final db = await bd;
    final result = await db.query('planetas');
    return result.map((map) => Planeta.fromMap(map)).toList();
  }
  Future<int> editarPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id],
    );
  }



  Future<int> inserirPlaneta(Planeta planeta) async {
    final db = await bd;
    return await db.insert('planetas', planeta.toMap());
  }

  Future<int> excluirPlaneta(int id) async {
    final db = await bd;
    return await db.delete('planetas', where: 'id = ?', whereArgs: [id]);
  }
}
