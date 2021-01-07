import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "artGalleryApp.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Exhibition Table
  static final exhibitionTable = 'exhibition_table';
  static final eID = 'eID'; // PK
  static final eForeignAdminID = 'eForeignAdminID'; //FK
  static final eType = 'eType';
  static final eDate = 'eDate';
  static final eTime = 'eTime';
  static final eLocation = 'eLocation';

  // User Table
  static final userTable = 'user_table';
  static final uID = 'uID';
  static final uFName = 'uFName';
  static final uLName = 'uLName';
  static final uEmail = 'uEmail';
  static final uPassword = 'uPassword';

  // Artist Table
  static final artistTable = 'artist_table';
  static final aID = 'aID'; // PK
  static final aForeignAdminID = 'aForeignAdminID'; // FK
  static final aName = 'aName';

  // Admin Table
  static final adminTable = 'admin_table';
  static final adminID = 'adminID';
  static final adminName = 'adminName';
  static final adminEmail = 'adminEmail';
  static final adminPass = 'adminPass';

  // Payment Table
  static final paymentTable = 'payment_table';
  static final pID = 'pID'; // PK
  static final pForeignUserID = 'pForeignUserID'; //FK
  static final artIDFK = 'artIDFK'; // FK
  static final cardType = 'cardType';
  static final creditCardNo = 'creditCardNo';
  static final pin = 'pin';
  static final address = 'address';
  static final city = 'city';

  // Art for Sale Table
  static final artTable = 'art_table';
  static final artID = 'artID'; // PK
  static final artForeignPaymentID = 'artForeignPaymentID'; //FK
  static final artArtistForeignID = 'artArtistForeignID';
  static final artName = 'artName';
  static final artType = 'artType';
  static final artPrice = 'artPrice';

  // Sclpture Table
  static final sclptureTable = 'sclpture_table';
  static final sclID = 'sclID'; // FK
  static final sclDimension = 'sclDimension';

  // Handicraft Table
  static final handicraftsTable = 'handicrafts_table';
  static final handiID = 'handiID'; // FK
  static final handiDimension = 'handiDimension';

  // Paintings Table
  static final paintingsTable = 'painting_table';
  static final paintID = 'paintID'; // FK
  static final paintArtBoardSize = 'paintArtBoardSize';

  // Artist Art Table
  static final artistArtTable = 'artist_art_table';
  static final artistID = 'artistID';
  static final artForSaleID = 'artForSaleID';

  // User Exhibition Table
  static final userExhTable = 'userExhTable';
  static final userID = 'userID';
  static final exhibitionID = 'exhibitionID';

  // SQL code to create the database tables
  Future _onCreate(Database db, int version) async {
    // User Table
    await db.execute(
        'CREATE TABLE $userTable($uID INTEGER PRIMARY KEY AUTOINCREMENT, $uEmail TEXT, $uFName TEXT, $uLName TEXT, $uPassword TEXT)');
    // Exhibition Table
    await db.execute(
        'CREATE TABLE $exhibitionTable($eID INTEGER PRIMARY KEY AUTOINCREMENT, $eForeignAdminID INTEGER, $eType TEXT, $eDate TEXT, $eTime TEXT, $eLocation TEXT, FOREIGN KEY($eForeignAdminID) REFERENCES $adminTable($adminID))');
    // Artist Table
    await db.execute(
        'CREATE TABLE $artistTable($aID INTEGER PRIMARY KEY AUTOINCREMENT, $aForeignAdminID TEXT, $aName TEXT, FOREIGN KEY($aForeignAdminID) REFERENCES $adminTable($adminID))');
    // Admin Table
    await db.execute(
        'CREATE TABLE $adminTable($adminID INTEGER PRIMARY KEY AUTOINCREMENT, $adminName TEXT, $adminEmail TEXT, $adminPass TEXT)');
    // Payment Table
    await db.execute(
        'CREATE TABLE $paymentTable($pID INTEGER PRIMARY KEY AUTOINCREMENT, $pForeignUserID INTEGER, $artIDFK INTEGER, $cardType TEXT, $creditCardNo TEXT, $pin TEXT, $address TEXT, $city TEXT, FOREIGN KEY($pForeignUserID) REFERENCES $userTable($uID), FOREIGN KEY($artIDFK) REFERENCES $artTable($artID))');
    // Art for sale Table
    await db.execute(
        'CREATE TABLE $artTable($artID INTEGER PRIMARY KEY AUTOINCREMENT, $artForeignPaymentID INTEGER, $artArtistForeignID INTEGER, $artName TEXT, $artType TEXT, $artPrice TEXT, FOREIGN KEY($artForeignPaymentID) REFERENCES $paymentTable($pID), FOREIGN KEY($artArtistForeignID) REFERENCES $artistTable($aID))');
    // Sclpture Table
    await db.execute(
        'CREATE TABLE $sclptureTable($sclID INTEGER, $sclDimension TEXT, FOREIGN KEY($sclID) REFERENCES $artTable($artID))');
    // Handicraft Table
    await db.execute(
        'CREATE TABLE $handicraftsTable($handiID INTEGER, $handiDimension TEXT, FOREIGN KEY($handiID) REFERENCES $artTable($artID))');
    // Paintings Table
    await db.execute(
        'CREATE TABLE $paintingsTable($paintID INTEGER, $paintArtBoardSize TEXT, FOREIGN KEY($paintID) REFERENCES $artTable($artID))');

    // Artist Art Table
    await db.execute(
        'CREATE TABLE $artistArtTable($artistID INTEGER, $artForSaleID INTEGER, FOREIGN KEY($artistID) REFERENCES $artistTable($aID), FOREIGN KEY($artForSaleID) REFERENCES $artTable($artID))');
    // Artist Art Table
    await db.execute(
        'CREATE TABLE $userExhTable($userID INTEGER, $exhibitionID INTEGER, FOREIGN KEY($userID) REFERENCES $userTable($uID), FOREIGN KEY($exhibitionID) REFERENCES $exhibitionTable($eID))');

    // INSERTING VALUES
    await db.execute(
        "INSERT INTO $adminTable($adminID, $adminName, $adminEmail, $adminPass) VALUES(?, ?, ?, ?)",
        [1, "Shahmeer", "shahmir519@gmail.com", "admin"]);
  }

  // User Table Operations
  Future<int> insertUser(
      String email, String fName, String lName, String password) async {
    Database db = await instance.database;
    return await db.rawInsert(
        'INSERT INTO user_table(uEmail, uFName, uLName, uPassword) VALUES (?, ?, ?, ?)',
        [email, fName, lName, password]);
  }

  Future queryLoginUser(String email, String password) async {
    Database db = await instance.database;
    var user = await db.rawQuery(
        "SELECT $uID FROM $userTable WHERE $uEmail ='$email' AND $uPassword = '$password'");
    if (user.length == 0) {
      return 1;
    } else {
      return user[0]['uID'];
    }
  }

  // Exhibition Table Operations
  Future<int> insertExhibition(
      String type, String time, String date, String location) async {
    Database db = await instance.database;
    return await db.rawInsert(
        'INSERT INTO $exhibitionTable($eType, $eTime, $eDate, $eLocation, $eForeignAdminID) VALUES (?, ?, ?, ?, ?)',
        [type, time, date, location, 1]);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $exhibitionTable');
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $exhibitionTable'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[eID];
    return await db
        .update(exhibitionTable, row, where: '$eID = ?', whereArgs: [id]);
  }

  Future<int> delete(String exhName) async {
    Database db = await instance.database;
    return await db
        .rawDelete("DELETE FROM $exhibitionTable WHERE $eType = '$exhName'");
  }

  // Artist Table opr
  Future<int> insertArtist(String name) async {
    Database db = await instance.database;
    String insertSQL =
        "INSERT INTO $artistTable ($aName, $aForeignAdminID) VALUES ('$name', '1');";
    return await db.rawInsert(insertSQL);
  }

  Future<int> deleteArtist(int artistID) async {
    Database db = await instance.database;
    return await db
        .rawDelete("DELETE FROM $artistTable WHERE $aID = '$artistID'");
  }

  Future<List<Map<String, dynamic>>> queryAllArtist() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $artistTable');
  }

  // Payment Table opr
  Future<int> insertPaymentOrder(
    int inputArtID,
    int userID,
    String ccNumber,
    String ccType,
    String inputPin,
    String inputAddress,
    String inputCity,
  ) async {
    Database db = await instance.database;
    String insertSQL =
        "INSERT INTO $paymentTable ($pForeignUserID, $artIDFK, $cardType, $creditCardNo, $pin, $address, $city) VALUES ('$userID', '$inputArtID', '$ccType', '$ccNumber', '$inputPin', '$inputAddress', '$inputCity');";
    await db.rawInsert(insertSQL);

    String removeSQL = "DELETE FROM $artTable WHERE $artID = '$inputArtID'";
    return await db.rawDelete(removeSQL);
  }

  Future<int> deleteOrder(int payID) async {
    Database db = await instance.database;
    return await db
        .rawDelete("DELETE FROM $paymentTable WHERE $pID = '$payID'");
  }

  Future<List<Map<String, dynamic>>> queryAllPayments() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $paymentTable');
  }

  // Art Table opr
  Future<int> insertArtWorks(String type, String name, String price,
      int artistID, String artSizeDimension) async {
    Database db = await instance.database;
    var checkID = await db.rawQuery(
        "SELECT $aID, $aName FROM $artistTable WHERE $aID = '$artistID' AND $aName = '$name'");
    if (checkID.length == 0) {
      return 1;
    } else {
      await db.rawInsert(
          'INSERT INTO $artTable($artType, $artName, $artPrice, $artForeignPaymentID, $artArtistForeignID) VALUES(?, ?, ?, ?, ?);',
          [type, name, price, artistID]);
      var tempID = await db.rawQuery("SELECT MAX($artID) FROM $artTable");

      if (type == "Painting") {
        await db.rawInsert(
            "INSERT INTO $paintingsTable($paintID, $paintArtBoardSize) VALUES (?, ?)",
            [tempID[0]['MAX(artID)'], artSizeDimension]);
        return 0;
      } else if (type == "Sclpture") {
        await db.rawInsert(
            "INSERT INTO $sclptureTable($sclID, $sclDimension) VALUES (?, ?)",
            [tempID[0]['MAX(artID)'], artSizeDimension]);
        return 0;
      } else {
        await db.rawInsert(
            "INSERT INTO $handicraftsTable($handiID, $handiDimension) VALUES (?, ?)",
            [tempID[0]['MAX(artID)'], artSizeDimension]);
        return 0;
      }
    }
  }

  Future<int> deleteArt(int artistID) async {
    Database db = await instance.database;
    return await db
        .rawDelete("DELETE FROM $artTable WHERE $artID = '$artistID'");
  }

  Future<List<Map<String, dynamic>>> queryAllArts() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $artTable');
  }

  // JOIN
  Future<List<Map<String, dynamic>>> joinArtScl() async {
    Database db = await instance.database;
    return await db.rawQuery('''
    SELECT $artTable.$artID, $artTable.$artName, $artTable.$artType, $artTable.$artPrice, $sclptureTable.$sclDimension
    FROM $artTable
    INNER JOIN $sclptureTable ON $artTable.$artID=$sclptureTable.$sclID;
    ''');
  }
}
