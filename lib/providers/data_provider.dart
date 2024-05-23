import 'dart:convert';

import 'package:al_quran/components/make_values_permanet_class/make_arabic_type_permanent_class.dart';
import 'package:al_quran/components/quran_db_class/quran_db_class.dart';
import 'package:al_quran/components/quran_db_class/quran_indopak_script_class.dart';
import 'package:al_quran/components/quran_meta_data/quran_meta_data.dart';
import 'package:al_quran/components/quran_meta_data/quran_surah_arabic_name_only.dart';
import 'package:al_quran/components/tafsirs/tafsir_meta_data.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../hive_model/boxes.dart';
import 'language_meta_data.dart';

class Data extends ChangeNotifier {
  ///
  /// getting surahs translation Start
  ///
  List translatedSurah = [];

  var translationName;

  translationFetch({required surahNumber}) async {
    // translatedSurah = [];
    translatedSurah = await services.rootBundle
        .loadString('db/translations/$translationName.json')
        .then((jsonData) => jsonDecode(jsonData)
            .toList()
            .where((e) => e['sura'] == surahNumber)
            .toList());

    notifyListeners();
  }

  /// getting surahs translation end

  /// getting surahs translation Start
  ///
  List tajweedTransliteration = [];

  tajweedTransliterationFetch({required surahNumber}) async {
    tajweedTransliteration = await services.rootBundle
        .loadString(
            'db/quran_tajweed_transliteration/tajweed_transliteration.json')
        .then((jsonData) => jsonDecode(jsonData)
            .toList()
            .where((e) => e['sura'] == surahNumber)
            .toList());
    // print(tajweedTransliteration);
    notifyListeners();
  }

  /// getting surahs translation end
  ///
  ///
  /// getting qur'an surah here
  List quranSurah = [];

  String mushaf_text = "";

  quranFetch({required surahNumber}) async {
    /// resetting the mushaf text so that if dont keeps on adding
    mushaf_text = "";
    // quranSurah = [];
    // print('quran fetch function ran and the surah fetched for is ~ $surahNumber' );
    var selectedArabicType = await ArabicTypeStorage()
        .readArabicType(fileNameToReadFrom: 'arabic_type');
    quranSurah = selectedArabicType == 'Uthmani'
        ? QuranDb()
            .fullQuran
            .where((element) => element['sura'] == surahNumber)
            .toList()
        : Quran_indo_pak_script_DB()
            .quran_indo_pak_script
            .where((element) => element['sura'] == surahNumber)
            .toList();

    /// THIS IS FOR THE MUSHAF TEXT

    for (int x = 0; x < quranSurah.length; x++) {
      mushaf_text += quranSurah[x]["text"] + " ";
    }

    // print(quranSurah);

    notifyListeners();
  }

  /// META DATA PROVIDERS

  int totalSurahs = QuranMetaData().quranSurah.length;
  List surahsMetaData = QuranMetaData().quranSurah;

  ///taking english and arabic surah names from here
  List surahArabicNames = TakingSurahArabicNamesOnly().surahArabicNames;

  ///languageQuery****************************************************************
  ///
  List foundLanguages = LanguageMetaData().languages;
  var searchedQuery;

  searchLanguage({query}) {
    if (query != '' ||
        query != null ||
        query != 'null' ||
        searchedQuery != '') {
      foundLanguages = LanguageMetaData()
          .languages
          .where((e) => e.toString().toLowerCase().contains('$query'))
          .toList();
      notifyListeners();
    } else {
      foundLanguages = LanguageMetaData().languages;
      notifyListeners();
    }
  }

  ///
  ///
  ///
  ///show sjda widget
  Widget showSjda(
      {surahNumber, verseNumber, required ThemeProvider themeProvider}) {
    var type;
    QuranMetaData().sjda.forEach((e) {
      if (int.parse(surahNumber.toString()) == e[0] &&
          int.parse(verseNumber.toString()) == e[1]) {
        type = e[2];
        return type;
      }
    });
    if (type == 'recommended') {
      return Text.rich(TextSpan(children: [
        TextSpan(
            text: 'Sjda : ',
            style: TextStyle(color: themeProvider.translationFontColor)),
        TextSpan(
            text: type.toString(), style: const TextStyle(color: Colors.green)),
      ]));
    }
    if (type == 'obligatory') {
      return Text.rich(TextSpan(children: [
        TextSpan(
            text: 'Sjda : ',
            style: TextStyle(color: themeProvider.translationFontColor)),
        TextSpan(
            text: type.toString(), style: const TextStyle(color: Colors.red)),
      ]));
    }
    return const Text('');
  }

  ///get verse end symbol function

  String getVerseEndSymbol(int verseNumber) {
    var arabicNumeric = '';
    var digits = verseNumber.toString().split("").toList();

    for (var e in digits) {
      if (e == "0") {
        arabicNumeric += "٠";
      }
      if (e == "1") {
        arabicNumeric += "۱";
      }
      if (e == "2") {
        arabicNumeric += "۲";
      }
      if (e == "3") {
        arabicNumeric += "۳";
      }
      if (e == "4") {
        arabicNumeric += "۴";
      }
      if (e == "5") {
        arabicNumeric += "۵";
      }
      if (e == "6") {
        arabicNumeric += "۶";
      }
      if (e == "7") {
        arabicNumeric += "۷";
      }
      if (e == "8") {
        arabicNumeric += "۸";
      }
      if (e == "9") {
        arabicNumeric += "۹";
      }
    }

    return '\u06dd' + arabicNumeric.toString();
  }

//  ///////////
  ///
  ///  /// //////////////////////////////////////////////////////////////////////////////////
  /// rabbana duas functions Stared here   ******************************************************
  /// //////////////////////////////////////////////////////////////////////////////////

  ///
  var rabbanaDuaTranslatedVerses = [];

  rabbanaDuaTranslationFetch() async {
    List incomingTranslatedVerses = [];
    // manzilTranslatedVerses = [];
    var translatedData = await services.rootBundle
        .loadString('db/translations/$translationName.json')
        .then((jsonData) => jsonDecode(jsonData));
    for (var rabbanaDuaData in QuranMetaData().rabbanaDuas) {
      for (var e in translatedData) {
        if (e['sura'] == rabbanaDuaData[0] && e['aya'] == rabbanaDuaData[1]
            // &&
            // manzilTranslatedVerses.length != QuranMetaData().mazil.length
            ) {
          // translatedVerse = e['text'];
          incomingTranslatedVerses.add(e['text']);
          // manzilTranslatedVerses.add(e['text']);
        }
        rabbanaDuaTranslatedVerses = incomingTranslatedVerses;
      }
    }
    notifyListeners();
    // print(translatedVersesTesting);
    // return translatedVerse;
  }

  List rabbanaDuasQuranVerses = [];

  rabbanaDuaQuranVerseFetch() async {
    List incomingQuranVerse = [];
    var selectedArabicType = await ArabicTypeStorage()
        .readArabicType(fileNameToReadFrom: 'arabic_type');
    if (selectedArabicType == 'Uthmani') {
      for (var e in QuranMetaData().rabbanaDuas) {
        for (var e2 in QuranDb().fullQuran) {
          if (e2['sura'] == e[0] && e2['aya'] == e[1]) {
            incomingQuranVerse.add(e2['text']);
          }
        }
      }
      rabbanaDuasQuranVerses = incomingQuranVerse;
    } else {
      // print('its me ');
      for (var e in QuranMetaData().rabbanaDuas) {
        for (var e2 in Quran_indo_pak_script_DB().quran_indo_pak_script) {
          if (e2['sura'] == e[0] && e2['aya'] == e[1]) {
            incomingQuranVerse.add(e2['text']);
          }
        }
      }
      rabbanaDuasQuranVerses = incomingQuranVerse;
    }
    notifyListeners();
  }

  ///
  ///  /// //////////////////////////////////////////////////////////////////////////////////
  /// FAVOURITES (bookmarks) functions Stared here   ******************************************************
  /// //////////////////////////////////////////////////////////////////////////////////

  ///
  var favouritesTranslatedVerses = [];

  favouritesTranslationFetch() async {
    List incomingTranslatedVerses = [];
    var translatedData = await services.rootBundle
        .loadString('db/translations/$translationName.json')
        .then((jsonData) => jsonDecode(jsonData));
    for (var e in Boxes().getFavourites().values.toList()) {
      for (var e2 in translatedData) {
        if (e2['sura'] == int.parse(e.surahNumber.toString()) &&
            e2['aya'] == int.parse(e.verseNumber.toString())) {
          incomingTranslatedVerses.add(e2['text']);
        }
      }
    }
    favouritesTranslatedVerses = incomingTranslatedVerses;
    notifyListeners();
  }

  ///
  ///  /// //////////////////////////////////////////////////////////////////////////////////
  /// select tafsirs functions stars here ******************************************************
  /// //////////////////////////////////////////////////////////////////////////////////
  ///
  ///[displayTafsir] search teh file and returns the the verse tafsir
  ///
  String verseTafsir = '...';
  String tafsirArabicVerse = '...';
  String tafsirAuthorName = '...';

  displayTafsir({surahNumber, verseNumber, required String arabicType}) async {
    tafsirArabicVerse = '...';
    verseTafsir = '...';
    final prefs = await SharedPreferences.getInstance();
    final int? tafsirId = prefs.getInt('tafsir_id');
    tafsirAuthorName = tafsirs_meta_data
        .where((e) => e['id'] == tafsirId)
        .map((e) => e['author_name'])
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');

    ///getting arabic verse here
    tafsirArabicVerse = arabicType == "Indo - Pak"
        ? Quran_indo_pak_script_DB()
            .quran_indo_pak_script
            .where((e) =>
                e['sura'] == surahNumber &&
                e['aya'] == int.parse(verseNumber.toString()))
            .map((e) => e['text'])
            .toString()
            .replaceAll('(', '')
            .replaceAll(')', '')
        : QuranDb()
            .fullQuran
            .where((e) =>
                e['sura'] == surahNumber &&
                e['aya'] == int.parse(verseNumber.toString()))
            .map((e) => e['text'])
            .toString()
            .replaceAll('(', '')
            .replaceAll(')', '');

    ///getting verse tafsir here
    final String response = await rootBundle.loadString(
        'db/tafsirs/${QuranMetaData().quranSurah[surahNumber][5]}.json');
    final data = await json.decode(response);

    var incomingTafsir = data
        .where((e) =>
            e['sura'] == surahNumber &&
            e['verse'] == int.parse(verseNumber.toString()))
        .map((e) => e['tafsirs']
            .where((e) => e['resource_id'] == tafsirId)
            .map((e) => e['text']))
        .toString()
        .replaceFirst('((', '');
    var formattedTafsir =
        incomingTafsir.substring(0, incomingTafsir.length - 2);
    if (formattedTafsir != "") {
      verseTafsir = formattedTafsir;
    } else {
      verseTafsir = '<h2>Sorry we don\'t have tafsir for this ayah</h2>';
    }
    notifyListeners();
  }
}
