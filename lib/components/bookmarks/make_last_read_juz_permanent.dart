import 'package:shared_preferences/shared_preferences.dart';

class LastReadJuz {
  loadBookMarkJuz() async {
    final prefs = await SharedPreferences.getInstance();

    var _data = prefs.getStringList('last_read_juz') ??
        [
          'null',
          'null',
          'null',
        ];

    return _data;
  }

  ///
  ///
  ///
  ///
  ///
  void writeJuzLastRead({
    required juzIndex,
    required index,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      'last_read_juz',
      [
        'juz',
        '$juzIndex',
        '$index',
      ],
    );
  }

  void removeLastReadJuz() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      'last_read_juz',
      [
        'null',
        'null',
        'null',
      ],
    );
  }
}
