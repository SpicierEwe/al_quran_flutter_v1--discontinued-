import 'dart:convert';

import 'package:al_quran/components/quran_db_class/quran_db_class.dart';
import 'package:al_quran/components/quran_db_class/quran_indopak_script_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;

class JuzProvider extends ChangeNotifier {
  var openedJuz;

  // var translationName =;

  List juzData = [];
  List juzTransliteration = [];

  juzFilter({required String arabicScriptType}) async {
    // print('the the juz filter the type = ${arabicScriptType}'.toUpperCase());
    List fullQuran = arabicScriptType == "Indo - Pak"
        ? Quran_indo_pak_script_DB().quran_indo_pak_script
        : QuranDb().fullQuran;

    List fullTransliteration = await juzTajweedTransliterationFetch();

    if (openedJuz == 1) {
      juzData = fullQuran.sublist(0, 148);
      juzTransliteration = fullTransliteration.sublist(0, 148);
    }
    if (openedJuz == 2) {
      juzData = fullQuran.sublist(148, 259);
      juzTransliteration = fullTransliteration.sublist(148, 259);
    }
    if (openedJuz == 3) {
      juzData = fullQuran.sublist(259, 385);
      juzTransliteration = fullTransliteration.sublist(259, 385);
    }
    if (openedJuz == 4) {
      juzData = fullQuran.sublist(385, 516);
      juzTransliteration = fullTransliteration.sublist(385, 516);
    }
    if (openedJuz == 5) {
      juzData = fullQuran.sublist(516, 640);
      juzTransliteration = fullTransliteration.sublist(516, 640);
    }
    if (openedJuz == 6) {
      juzData = fullQuran.sublist(640, 751);
      juzTransliteration = fullTransliteration.sublist(640, 751);
    }
    if (openedJuz == 7) {
      juzData = fullQuran.sublist(751, 899);
      juzTransliteration = fullTransliteration.sublist(751, 899);
    }
    if (openedJuz == 8) {
      juzData = fullQuran.sublist(899, 1041);
      juzTransliteration = fullTransliteration.sublist(899, 1041);
    }
    if (openedJuz == 9) {
      juzData = fullQuran.sublist(1041, 1200);
      juzTransliteration = fullTransliteration.sublist(1041, 1200);
    }
    if (openedJuz == 10) {
      juzData = fullQuran.sublist(1200, 1328);
      juzTransliteration = fullTransliteration.sublist(1200, 1328);
    }
    if (openedJuz == 11) {
      juzData = fullQuran.sublist(1328, 1478);
      juzTransliteration = fullTransliteration.sublist(1328, 1478);
    }
    if (openedJuz == 12) {
      juzData = fullQuran.sublist(1478, 1648);
      juzTransliteration = fullTransliteration.sublist(1478, 1648);
    }
    if (openedJuz == 13) {
      juzData = fullQuran.sublist(1648, 1802);
      juzTransliteration = fullTransliteration.sublist(1648, 1802);
    }
    if (openedJuz == 14) {
      juzData = fullQuran.sublist(1802, 2029);
      juzTransliteration = fullTransliteration.sublist(1802, 2029);
    }
    if (openedJuz == 15) {
      juzData = fullQuran.sublist(2029, 2214);
      juzTransliteration = fullTransliteration.sublist(2029, 2214);
    }
    if (openedJuz == 16) {
      juzData = fullQuran.sublist(2214, 2483);
      juzTransliteration = fullTransliteration.sublist(2214, 2483);
    }
    if (openedJuz == 17) {
      juzData = fullQuran.sublist(2483, 2673);
      juzTransliteration = fullTransliteration.sublist(2483, 2673);
    }
    if (openedJuz == 18) {
      juzData = fullQuran.sublist(2673, 2875);
      juzTransliteration = fullTransliteration.sublist(2673, 2875);
    }
    if (openedJuz == 19) {
      juzData = fullQuran.sublist(2875, 3218);
      juzTransliteration = fullTransliteration.sublist(2875, 3218);
    }
    if (openedJuz == 20) {
      juzData = fullQuran.sublist(3218, 3384);
      juzTransliteration = fullTransliteration.sublist(3218, 3384);
    }
    if (openedJuz == 21) {
      juzData = fullQuran.sublist(3384, 3563);
      juzTransliteration = fullTransliteration.sublist(3384, 3563);
    }
    if (openedJuz == 22) {
      juzData = fullQuran.sublist(3563, 3726);
      juzTransliteration = fullTransliteration.sublist(3563, 3726);
    }
    if (openedJuz == 23) {
      juzData = fullQuran.sublist(3726, 4089);
      juzTransliteration = fullTransliteration.sublist(3726, 4089);
    }
    if (openedJuz == 24) {
      juzData = fullQuran.sublist(4089, 4264);
      juzTransliteration = fullTransliteration.sublist(4089, 4264);
    }
    if (openedJuz == 25) {
      juzData = fullQuran.sublist(4264, 4510);
      juzTransliteration = fullTransliteration.sublist(4264, 4510);
    }
    if (openedJuz == 26) {
      juzData = fullQuran.sublist(4510, 4705);
      juzTransliteration = fullTransliteration.sublist(4510, 4705);
    }
    if (openedJuz == 27) {
      juzData = fullQuran.sublist(4705, 5104);
      juzTransliteration = fullTransliteration.sublist(4705, 5104);
    }
    if (openedJuz == 28) {
      juzData = fullQuran.sublist(5104, 5241);
      juzTransliteration = fullTransliteration.sublist(5104, 5241);
    }
    if (openedJuz == 29) {
      juzData = fullQuran.sublist(5241, 5672);
      juzTransliteration = fullTransliteration.sublist(5241, 5672);
    }
    if (openedJuz == 30) {
      juzData = fullQuran.sublist(5672, 6236);
      juzTransliteration = fullTransliteration.sublist(5672, 6236);
    }
    notifyListeners();
  }

  var translationName;
  var juzTranslatedSurah;

  updateLanguage({value}) async {
    translationName = value;
    notifyListeners();
    await juzTranslationFetch();
  }

  juzTranslationFetch() async {
    await services.rootBundle
        .loadString('db/translations/$translationName.json')
        .then((jsonData) => jsonDecode(jsonData))
        .then((jsonData) => jsonData as List)
        .then((books) {
      if (openedJuz == 1) {
        juzTranslatedSurah = books.sublist(0, 148);
      }
      if (openedJuz == 2) {
        juzTranslatedSurah = books.sublist(148, 259);
      }
      if (openedJuz == 3) {
        juzTranslatedSurah = books.sublist(259, 385);
      }
      if (openedJuz == 4) {
        juzTranslatedSurah = books.sublist(385, 516);
      }
      if (openedJuz == 5) {
        juzTranslatedSurah = books.sublist(516, 640);
      }
      if (openedJuz == 6) {
        juzTranslatedSurah = books.sublist(640, 751);
      }
      if (openedJuz == 7) {
        juzTranslatedSurah = books.sublist(751, 899);
      }
      if (openedJuz == 8) {
        juzTranslatedSurah = books.sublist(899, 1041);
      }
      if (openedJuz == 9) {
        juzTranslatedSurah = books.sublist(1041, 1200);
      }
      if (openedJuz == 10) {
        juzTranslatedSurah = books.sublist(1200, 1328);
      }
      if (openedJuz == 11) {
        juzTranslatedSurah = books.sublist(1328, 1478);
      }
      if (openedJuz == 12) {
        juzTranslatedSurah = books.sublist(1478, 1648);
      }

      if (openedJuz == 13) {
        juzTranslatedSurah = books.sublist(1648, 1802);
      }
      if (openedJuz == 14) {
        juzTranslatedSurah = books.sublist(1802, 2029);
      }
      if (openedJuz == 15) {
        juzTranslatedSurah = books.sublist(2029, 2214);
      }
      if (openedJuz == 16) {
        juzTranslatedSurah = books.sublist(2214, 2483);
      }
      if (openedJuz == 17) {
        juzTranslatedSurah = books.sublist(2483, 2673);
      }
      if (openedJuz == 18) {
        juzTranslatedSurah = books.sublist(2673, 2875);
      }
      if (openedJuz == 19) {
        juzTranslatedSurah = books.sublist(2875, 3218);
      }
      if (openedJuz == 20) {
        juzTranslatedSurah = books.sublist(3218, 3384);
      }
      if (openedJuz == 21) {
        juzTranslatedSurah = books.sublist(3384, 3563);
      }
      if (openedJuz == 22) {
        juzTranslatedSurah = books.sublist(3563, 3726);
      }
      if (openedJuz == 23) {
        juzTranslatedSurah = books.sublist(3726, 4089);
      }
      if (openedJuz == 24) {
        juzTranslatedSurah = books.sublist(4089, 4264);
      }
      if (openedJuz == 25) {
        juzTranslatedSurah = books.sublist(4264, 4510);
      }
      if (openedJuz == 26) {
        juzTranslatedSurah = books.sublist(4510, 4705);
      }
      if (openedJuz == 27) {
        juzTranslatedSurah = books.sublist(4705, 5104);
      }
      if (openedJuz == 28) {
        juzTranslatedSurah = books.sublist(5104, 5241);
      }
      if (openedJuz == 29) {
        juzTranslatedSurah = books.sublist(5241, 5672);
      }
      if (openedJuz == 30) {
        juzTranslatedSurah = books.sublist(5672, 6236);
      }
    });

    notifyListeners();
  }

  /// this will fetch the juz transliteration
  juzTajweedTransliterationFetch() async {
    return await services.rootBundle
        .loadString(
            'db/quran_tajweed_transliteration/tajweed_transliteration.json')
        .then((jsonData) => jsonDecode(jsonData).toList());
  }
}
