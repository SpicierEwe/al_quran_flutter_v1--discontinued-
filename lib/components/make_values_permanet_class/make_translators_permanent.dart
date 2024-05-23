import 'dart:io';

import 'package:path_provider/path_provider.dart';

///File Name to fetch dynamic

class TranslatorFileStorage {
  var fileName;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${fileName.toString()}');
  }

  ///read language****************************/! = file name = 'languageName'
  Future<String> readLanguageName({required String fileNameToReadFrom}) async {
    try {
      fileName = fileNameToReadFrom;
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return 'null';
    }
  }

  ///read Translation Language****************************
  Future<String> readTranslatorName(
      {required String fileNameToReadFrom}) async {
    try {
      fileName = fileNameToReadFrom;
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return 'null';
    }
  }

  ///read Translation Language****************************
  Future<String> readTranslationName(
      {required String fileNameToReadFrom}) async {
    try {
      fileName = fileNameToReadFrom;
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return 'null';
    }
  }

  Future<File> writeFile(
      {required String whatToSave, required String fileNameToSaveIn}) async {
    fileName = fileNameToSaveIn;
    final file = await _localFile;

    return file.writeAsString(whatToSave);
  }

  ///this function takes translator name and translation Language and saves them separately
  writeTranslatorNameAndTranslationName({
    required String translatorName,
    required String translationName,
  }) async {
    try {
      ///saving translator name here
      writeFile(whatToSave: translatorName, fileNameToSaveIn: 'translatorName');

      ///saving translation name here
      writeFile(
          whatToSave: translationName, fileNameToSaveIn: 'translationName');
    } catch (err) {
      print('some error happened while saving x and b= ' + err.toString());
    }
  }
}
