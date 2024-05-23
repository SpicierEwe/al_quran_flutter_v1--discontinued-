import 'dart:io';

import 'package:path_provider/path_provider.dart';

///File Name to fetch dynamic

class FontSizeFileStorage {
  var fileName;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${fileName.toString()}');
  }

  ///read font size Arabic****************************
  Future<String> readFontSizeArabic(
      {required String fileNameToReadFrom}) async {
    try {
      fileName = fileNameToReadFrom;
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '30';
    }
  }

  ///read font size Translation Language****************************
  Future<String> readFontSizeLanguage(
      {required String fileNameToReadFrom}) async {
    try {
      fileName = fileNameToReadFrom;
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '21';
    }
  }

  Future<File> writeFile(
      {required String whatToSave, required String fileNameToSaveIn}) async {
    fileName = fileNameToSaveIn;
    final file = await _localFile;

    // Write the file
    // print('what to save = ' + whatToSave);
    return file.writeAsString(whatToSave);
  }
}
