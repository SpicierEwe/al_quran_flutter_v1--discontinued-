import 'dart:io';

import 'package:path_provider/path_provider.dart';

///File Name to fetch dynamic

class FileStorage {
  var fileName;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${fileName.toString()}');
  }

  Future<String> readFile({required String fileNameToReadFrom}) async {
    try {
      fileName = fileNameToReadFrom;
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return 'true';
      print(e);
    }
  }

  Future<File> writeFile(
      {required String whatToSave, required String fileNameToSaveIn}) async {
    fileName = fileNameToSaveIn;
    final file = await _localFile;

    // Write the file
    return file.writeAsString(whatToSave);
  }
}

