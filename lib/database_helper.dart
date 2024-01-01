import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static const _databaseName = "BankDetailsDB.db";
  static const _databaseVersion = 1;

  // Bank Details table
  static const bankDetailsTable = '_bankDetailsTable';

  // Primary key
  static const colId = '_id';
  // Bank Details table column
  static const colBankName = '_bankName';
  static const colBranch = '_branch';
  static const colAccountType = '_accountType';
  static const colAccountNo = '_accountNo';
  static const colIFSCCode = '_IFSCCode';

  late Database _db;

  Future<void> initialization() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database database, int version) async {
    // create table _bankDetailsTable(_id integer primary key, _bankName text,
    // _branch text, _accountType text, _accountNo text, _IFSCCode text)
    await database.execute('''
          CREATE TABLE $bankDetailsTable (
            $colId INTEGER PRIMARY KEY,
            $colBankName TEXT,
            $colBranch TEXT,
            $colAccountType TEXT,
            $colAccountNo TEXT,
            $colIFSCCode TEXT
          )
          ''');
  }

  _onUpgrade(Database database, int oldVersion, int newVersion) async{
    await database.execute('drop table $bankDetailsTable');
    _onCreate(database, newVersion);
  }

  Future<int> insertBankDetails(Map<String, dynamic> row) async {
    return await _db.insert(bankDetailsTable, row);
  }

  Future<List<Map<String, dynamic>>> getAllBankDetails() async {
    // select * from _bankDetailsTable;
    return await _db.query(bankDetailsTable);
  }

  Future<int> updateBankDetails(Map<String, dynamic> row) async {
    int id = row[colId];
    return await _db.update(
      bankDetailsTable,
      row,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteBankDetails(int id) async {
    return await _db.delete(
      bankDetailsTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }
}