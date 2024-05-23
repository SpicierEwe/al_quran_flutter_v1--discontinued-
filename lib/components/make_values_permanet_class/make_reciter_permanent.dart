import 'dart:io';

import 'package:path_provider/path_provider.dart';

///File Name to fetch dynamic

class ReciterFileStorage {
  var fileName;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${fileName.toString()}');
  }

  ///read reciter name*******************************
  Future<String> readReciterName({required String fileNameToReadFrom}) async {
    try {
      fileName = fileNameToReadFrom;
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return 'Alafasy';
    }
  }

  ///read RecitationStyle Name****************************
  Future<String> readRecitationStyle(
      {required String fileNameToReadFrom}) async {
    try {
      fileName = fileNameToReadFrom;
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return 'Murattal';
    }
  }

  Future<File> writeReciterName(
      {required String whatToSave, required String fileNameToSaveIn}) async {
    fileName = fileNameToSaveIn;
    final file = await _localFile;

    return file.writeAsString(whatToSave);
  }

  Future<File> writeRecitationStyle(
      {required String whatToSave, required String fileNameToSaveIn}) async {
    fileName = fileNameToSaveIn;
    final file = await _localFile;

    return file.writeAsString(whatToSave);
  }
}
