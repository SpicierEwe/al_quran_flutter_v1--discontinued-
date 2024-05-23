import 'package:shared_preferences/shared_preferences.dart';

class LastReadSurah {
  loadBookMarkSurah() async {
    final prefs = await SharedPreferences.getInstance();

    var _data = prefs.getStringList('last_read_surah') ??
        [
          'null',
          'null',
          'null',
        ];
    // print(_counter);
    return _data;
  }

//Incrementing counter
  void writeSurahLastRead({
    required juzIndex,
    required juzAyahIndex,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      'last_read_surah',
      [
        'surah',
        '$juzIndex',
        '$juzAyahIndex',
      ],
    );
  }

  ///
  ///
  ///

  void removeLastReadSurah() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      'last_read_surah',
      [
        'null',
        'null',
        'null',
      ],
    );
  }
}
