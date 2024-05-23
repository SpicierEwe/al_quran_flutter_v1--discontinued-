// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:flutter/services.dart' as services;
// import '../components/make_values_permanet_class/make_arabic_type_permanent_class.dart';
// import '../components/quran_db_class/quran_db_class.dart';
// import '../components/quran_db_class/quran_indopak_script_class.dart';
//
// class SpeechToTextProvider extends ChangeNotifier {
//   var quranSearchResults = [];
//   var translationSearchResults = [];
//   var translationName;
//   late TextEditingController textEditingController;
//   final SpeechToText speechToText = SpeechToText();
//   bool speechEnabled = false;
//   String lastWords = '';
//
//   //
//   String searchText = '';
//
//   /// Each time to start a speech recognition session
//   void startListening() async {
//     await speechToText
//         .listen(
//       onResult: onSpeechResult,
//       listenMode: ListenMode.dictation,
//     )
//         .then((value) => print('stopped'));
//
//     notifyListeners();
//   }
//
//   /// Manually stop the active speech recognition session
//   /// Note that there are also timeouts that each platform enforces
//   /// and the SpeechToText plugin supports setting timeouts on the
//   /// listen method.
//   void stopListening() async {
//     await speechToText.stop();
//     notifyListeners();
//   }
//
//   /// This is the callback that the SpeechToText plugin calls when
//   /// the platform returns recognized words.
//
//   void onSpeechResult(SpeechRecognitionResult result) {
//     lastWords = result.recognizedWords;
//     searchText = result.recognizedWords;
//
//     ///using [textEditingController.text] to fill the speech in the form text field
//     textEditingController.text = result.recognizedWords;
//     searchQuery(query: result.recognizedWords);
//
//     notifyListeners();
//   }
//
//   ///clean search input field
//   clearSearchInputField({formKey}) async {
//     print('pressed clear form');
//     formKey.currentState?.reset();
//     searchText = '';
//     textEditingController.text = '';
//     quranSearchResults = [];
//     translationSearchResults = [];
//
//     notifyListeners();
//   }
//
//   ///[getInputTextWords] assigns the search text value to search text in realtime
//   getInputTextWords({inputSearchText}) {
//     searchText = inputSearchText;
//     notifyListeners();
//   }
//
//   assignTranslationName({setTranslationName}) {
//     translationName = setTranslationName;
//   }
//
//   ///[searchQuery] searches the entire quran for the user query
//   ///
//
//   ///[searchQuery] manages all the query filtering and everything //////////////////////////////////////////////////////////////
//   searchQuery({query}) async {
//     // searchResults = query;.
//     var queryString = query.toString().toLowerCase();
//
//     if (query.toString().contains(':')) {
//       print('short');
//       shortQuery(query: query);
//     } else if (queryString.contains('surah') || queryString.contains('verse')) {
//       print('med');
//       mediumQuery(query: query);
//     } else if (queryString.isNotEmpty || query != '' || query != ' ') {
//       print(query);
//       print('random');
//       randomSearch(query: query);
//     }
//   }
//
//   ///[shortQuery] refers the queries if type ex: 2:15 where surahNumber = 2 and verseNumber = 15
//   shortQuery({query}) async {
//     quranSearchResults = [];
//     var x = query
//         .toString()
//         .toLowerCase()
//         .trim()
//         .split(" ")
//         .where((e) => e.toString().contains(':'))
//         .toString()
//         .replaceAll('(', '')
//         .replaceAll(')', '')
//         .split('');
//     var querySurahNumber = x.sublist(0, x.indexOf(':')).join('').trim();
//     var queryVerseNumber = x.sublist(x.indexOf(':') + 1).join('').trim();
//     print('querySurahNumber = ' + querySurahNumber);
//     print('queryVerseNumber = ' + queryVerseNumber);
//
//     if (queryVerseNumber == '') {
//       onlySearchSurah(querySurahNumber: querySurahNumber);
//     }
//     if (querySurahNumber != '' && queryVerseNumber != '') {
//       searchSurahAndVerseAndTranslation(
//           querySurahNumber: querySurahNumber,
//           queryVerseNumber: queryVerseNumber);
//     }
//   }
//
//   /// [mediumQuery] refers the queries if type ex: surah = 2 and verse = 15
//   mediumQuery({query}) async {
//     quranSearchResults = [];
//     if (query.toString().toLowerCase().contains('aya')) {
//       print('yepppp');
//     }
//     var x = query
//         .toString()
//         .toLowerCase()
//         .replaceAll('(', '')
//         .replaceAll(')', '')
//         .split(" ");
//
//     //
//
//     var querySurahNumber = x[x.indexOf('surah') + 1];
//
//     var queryVerseNumber = x[x.indexOf('verse') + 1];
//
//     print(querySurahNumber);
//     print(queryVerseNumber);
//
//     if (int.tryParse(queryVerseNumber) != null &&
//         int.tryParse(querySurahNumber) != null) {
//       searchSurahAndVerseAndTranslation(
//           querySurahNumber: querySurahNumber,
//           queryVerseNumber: queryVerseNumber);
//     }
//
//     if (int.tryParse(queryVerseNumber) == null &&
//         int.tryParse(querySurahNumber) != null) {
//       onlySearchSurah(querySurahNumber: querySurahNumber);
//     }
//     if (int.tryParse(queryVerseNumber) != null &&
//         int.tryParse(querySurahNumber) == null) {
//       onlySearchVerse(queryVerseNumber: queryVerseNumber);
//     }
//   }
//
//   onlySearchSurah({querySurahNumber}) async {
//     var selectedArabicType = await ArabicTypeStorage()
//         .readArabicType(fileNameToReadFrom: 'arabic_type');
//     quranSearchResults = selectedArabicType == 'Uthmani'
//         ? QuranDb()
//         .fullQuran
//         .where((element) => element['sura'].toString() == querySurahNumber)
//         .toList()
//         : Quran_indo_pak_script_DB()
//         .quran_indo_pak_script
//         .where((element) => element['sura'].toString() == querySurahNumber)
//         .toList();
//     var x = await services.rootBundle
//         .loadString('db/translations/$translationName.json')
//         .then((jsonData) => jsonDecode(jsonData));
//     translationSearchResults = x
//         .where((element) => element['sura'].toString() == querySurahNumber)
//         .toList();
//     notifyListeners();
//   }
//
//   onlySearchVerse({queryVerseNumber}) async {
//     var selectedArabicType = await ArabicTypeStorage()
//         .readArabicType(fileNameToReadFrom: 'arabic_type');
//     quranSearchResults = selectedArabicType == 'Uthmani'
//         ? QuranDb()
//         .fullQuran
//         .where((element) => element['aya'].toString() == queryVerseNumber)
//         .toList()
//         : Quran_indo_pak_script_DB()
//         .quran_indo_pak_script
//         .where((element) => element['aya'].toString() == queryVerseNumber)
//         .toList();
//     var x = await services.rootBundle
//         .loadString('db/translations/$translationName.json')
//         .then((jsonData) => jsonDecode(jsonData));
//     translationSearchResults = x
//         .where((element) => element['aya'].toString() == queryVerseNumber)
//         .toList();
//     notifyListeners();
//   }
//
//   searchSurahAndVerseAndTranslation(
//       {querySurahNumber, queryVerseNumber}) async {
//     var selectedArabicType = await ArabicTypeStorage()
//         .readArabicType(fileNameToReadFrom: 'arabic_type');
//
//     quranSearchResults = selectedArabicType == 'Uthmani'
//         ? QuranDb()
//         .fullQuran
//         .where((element) =>
//     element['sura'].toString() == querySurahNumber &&
//         element['aya'].toString() == queryVerseNumber)
//         .toList()
//         : Quran_indo_pak_script_DB()
//         .quran_indo_pak_script
//         .where((element) =>
//     element['sura'].toString() == querySurahNumber &&
//         element['aya'].toString() == queryVerseNumber)
//         .toList();
//     var x = await services.rootBundle
//         .loadString('db/translations/$translationName.json')
//         .then((jsonData) => jsonDecode(jsonData));
//     translationSearchResults = x
//         .where((element) =>
//     element['sura'].toString() == querySurahNumber &&
//         element['aya'].toString() == queryVerseNumber)
//         .toList();
//
//     notifyListeners();
//   }
//
//   randomSearch({query}) async {
//     var selectedArabicType = await ArabicTypeStorage()
//         .readArabicType(fileNameToReadFrom: 'arabic_type');
//     if (int.tryParse(query) != null) {
//       quranSearchResults = selectedArabicType == 'Uthmani'
//           ? QuranDb()
//           .fullQuran
//           .where(
//             (element) =>
//         element['sura'].toString().contains(query) ||
//             element['aya'].toString().contains(query) ||
//             element['text'].toString().contains(query),
//       )
//           .toList()
//           : Quran_indo_pak_script_DB()
//           .quran_indo_pak_script
//           .where(
//             (element) =>
//         element['sura'].toString().contains(query) ||
//             element['aya'].toString().contains(query) ||
//             element['text'].toString().contains(query),
//       )
//           .toList();
//       var x = await services.rootBundle
//           .loadString('db/translations/$translationName.json')
//           .then((jsonData) => jsonDecode(jsonData));
//       translationSearchResults = x
//           .where(
//             (element) =>
//         element['sura'].toString().contains(query) ||
//             element['aya'].toString().contains(query) ||
//             element['text'].toString().contains(query),
//       )
//           .toList();
//       print('aaaaaaaaaaaaaaaaaaaaaa==============================');
//       notifyListeners();
//     } else {
//       print('this is string');
//       var x = await services.rootBundle
//           .loadString('db/translations/$translationName.json')
//           .then((jsonData) => jsonDecode(jsonData));
//       translationSearchResults = x
//           .where(
//             (element) =>
//         element['sura']
//             .toString()
//             .toLowerCase()
//             .contains(query.toString().toLowerCase()) ||
//             element['aya']
//                 .toString()
//                 .toLowerCase()
//                 .contains(query.toString().toLowerCase()) ||
//             element['text']
//                 .toString()
//                 .toLowerCase()
//                 .contains(query.toString().toLowerCase()),
//       )
//           .toList();
//       // print(translationSearchResults);
//       notifyListeners();
//     }
//   }
//
//   aa({surah, verse}) async {
//     var selectedArabicType = await ArabicTypeStorage()
//         .readArabicType(fileNameToReadFrom: 'arabic_type');
//
//     return selectedArabicType == 'Uthmani'
//         ? QuranDb()
//         .fullQuran
//         .where((element) =>
//     element['sura'].toString() == surah.toString() &&
//         element['aya'].toString() == verse.toString())
//         .toList()
//         : Quran_indo_pak_script_DB()
//         .quran_indo_pak_script
//         .where((element) =>
//     element['sura'].toString() == surah.toString() &&
//         element['aya'].toString() == verse.toString())
//         .toList();
//   }
// }
