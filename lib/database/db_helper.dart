import 'dart:io';

import 'package:flutter/services.dart';
import 'package:quiz_app/const/const.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> copyDb() async {
  var dbPath = await getDatabasesPath();
  var path = join(dbPath, db_name);

  var exist = await databaseExists(path);

  if (!exist) {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    //copy from assets folder
    ByteData data = await rootBundle.load(join("assets/db", db_name));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);
  } else {
    print("db already exist");
  }

  return await openDatabase(path, readOnly: true);
}
