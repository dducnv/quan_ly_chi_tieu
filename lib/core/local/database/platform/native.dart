// native.dart
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'dart:io';

import 'package:quan_ly_chi_tieu/core/local/database/expense_management_db.dart';
import 'package:quan_ly_chi_tieu/core/local/global_db.dart';
import 'package:quan_ly_chi_tieu/core/local/local_pref/pref_helper.dart';
import 'package:quan_ly_chi_tieu/core/local/local_pref/pref_keys.dart';
import 'package:quan_ly_chi_tieu/core/utils/debug.dart';

ExpenseManagementDb constructDb(String dbName) {
  // the LazyDatabase util lets us find the right location for the file async.
  final db = LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, '$dbName.sqlite'));
    final bool dbExists = await file.exists();
    if (dbExists) {
      return NativeDatabase(file);
    }
    QueryExecutor foregroundExecutor = NativeDatabase(file);
    QueryExecutor backgroundExecutor = NativeDatabase.createInBackground(file);
    return MultiExecutor(read: foregroundExecutor, write: backgroundExecutor);
  });
  return ExpenseManagementDb(db);
}

Future<bool> importBb(
  String sourcePathImport,
) async {
  try {
    final dbDirectory = await getApplicationDocumentsDirectory();
    final originalFilePath =
        p.join(dbDirectory.path, 'expense_management_db.sqlite');

    // Check if both original and backup files exist.
    final originalFile = File(originalFilePath);
    final backupFile = File(sourcePathImport);

    if (await originalFile.exists() && await backupFile.exists()) {
      // Delete the original file.
      await originalFile.delete();

      // Rename the backup file to match the original file's name.
      await backupFile.rename(originalFilePath);
      database = constructDb('expense_management_db');
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

LazyDatabase reloadDb() {
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'expense_management_db.db'));
    return NativeDatabase.createInBackground(file);
  });
}
//export db

Future<String> backupDb() async {
  try {
    String addressSaveBackups =
        await PrefHelper().readData(PrefKeys.folderSavebackups) ??
            "/storage/emulated/0/Download";
    final directory = Platform.isAndroid
        ? Directory(addressSaveBackups)
        : await getApplicationDocumentsDirectory();
    final dbDirectory = await getApplicationDocumentsDirectory();
    final sourcePath = p.join(dbDirectory.path, 'expense_management_db.sqlite');

    final timestamp = DateTime.now()
        .toString()
        .replaceAll(".", "-")
        .replaceAll("-", "-")
        .replaceAll(" ", "-")
        .replaceAll(":", "-");
    final backupFilename = 'expense_management_db_backup-$timestamp.sqlite';

    final destinationPath = p.join(directory.path, backupFilename);

    final sourceFile = File(sourcePath);
    if (await sourceFile.exists()) {
      await sourceFile.copy(destinationPath);
      return 'success';
    } else {
      return 'path_not_found';
    }
  } catch (err) {
    Debug.logMessage(message: err.toString());
    return 'error';
  }
  //select storage to save file
}
