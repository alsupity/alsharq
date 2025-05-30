import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'tables.dart' as t;

class DbHelper{
  DbHelper._internal();
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  
  static Database? _db;
  Future<Database> createDatabase() async{
    if(_db != null){
      return _db!;
    }else {
      try{
        String path = join(await getDatabasesPath(), 'db.db');
        _db = await openDatabase(path,
          version: 1,
          onCreate: (Database db, int v) async {
            try {
              await db.execute(t.notifications);

              await db.execute(t.countries);
              await db.execute(t.classes);
              await db.execute(t.subjects);
              await db.execute(t.phases);
              await db.execute(t.asks);
              await db.execute(t.marks);

              await db.execute(t.tmp);
              await Future.delayed(Duration(seconds: 1));
              print("Create db successfully");
            }catch(err){
              print("err db: $err");
              closeDatabase();
            }
          },
        );
      }catch(err){
        print("err db: $err");
        closeDatabase();
      }
      return _db!;
    }
  }
  
  Future<void> closeDatabase() async {
    try {
      await _db?.close();
    }catch(err){
      print("err in close db sqlite");
    }
  }

  Future<String> maxDate({required bool created_at, required String table}) async {
    Database db = await createDatabase();
    String column = (created_at == true)? "created_at": "updated_at";
    List onerow = await db.rawQuery("SELECT $column FROM  $table  WHERE strftime('%s', $column) = (SELECT max(strftime('%s', $column)) FROM $table);");
    if (onerow.isNotEmpty) {
      return onerow[0][column].toString().replaceAll(" ", "T");
    } else {
      return "2010-01-01T01:01:01";
    }
  }
  // CRUD ____________________________________________________ where 1
  Future<List> cmd({required String cmd}) async {
    Database db = await createDatabase();
    return db.rawQuery("$cmd;");
  }
  Future<List> select({required String column, required String table, required String condition}) async {
    Database db = await createDatabase();
    if(condition.endsWith("and") || condition.endsWith("and ")) {
      condition = "$condition 1";
    }
    if(condition.startsWith("and") || condition.startsWith(" and")) {
      condition = "1 $condition";
    }
    return db.rawQuery("SELECT $column FROM $table where $condition;");
  }
  Future<int> insert({required String table, required Map<String, dynamic> obj}) async {
    Database db = await createDatabase();
    return db.insert(table, obj);
  }
  Future<int> update({required String table, required Map<String, dynamic> obj, required String condition}) async {
    Database db = await createDatabase();
    return db.update(table, obj, where: condition,);
  }
  Future<int> delete({required String table, required String condition})async{
    Database db = await createDatabase();
    return db.rawDelete("DELETE FROM $table WHERE $condition;");
  }
  // end CRUD ______________________________________________________________________

  Future<int> countRows({required String table, required String condition})async{
    Database db = await createDatabase();
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table where $condition;')) ?? 0;
  }

}

