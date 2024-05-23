import 'dart:io';

import 'package:path_provider/path_provider.dart';

///File Name to fetch dynamic

class ThemeFileStorage {
  var fileName;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    ///saving to file theme
    return File('$path/${fileName.toString()}');
  }

  ///read font size Arabic****************************
  Future<String> readThemeBool({required String fileNameToReadFrom}) async {
    try {
      fileName = fileNameToReadFrom;
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return 'false';
    }
  }

  Future<File> writeTheme(
      {required String whatToSave, required String fileNameToSaveIn}) async {
    fileName = fileNameToSaveIn;
    final file = await _localFile;

    return file.writeAsString(whatToSave);
  }
}
