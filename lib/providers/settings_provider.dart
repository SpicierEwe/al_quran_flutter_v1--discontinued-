import 'dart:ffi';

import 'package:al_quran/components/make_values_permanet_class/make_arabic_type_permanent_class.dart';
import 'package:al_quran/components/make_values_permanet_class/make_font_sizes_permanent_class.dart';
import 'package:al_quran/components/make_values_permanet_class/make_switch_value_permanent.dart';
import 'package:al_quran/components/make_values_permanet_class/make_translators_permanent.dart';
import 'package:al_quran/components/tafsirs/tafsir_meta_data.dart';
import 'package:al_quran/providers/language_meta_data.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sizer/sizer.dart';
import 'data_provider.dart';

class SettingsProvider extends ChangeNotifier {
  /// SETTINGS MANAGER
  var selectedLanguage;

  ///
  ///writing the value permanently with this function dynamic(universal) *******************
  ///  /*
  ///  applicable for all arabic text  , transliteration / translations
  ///  */
  showTextStoring({required whatToSave, required String fileToSaveIn}) {
    FileStorage()
        .writeFile(fileNameToSaveIn: fileToSaveIn, whatToSave: whatToSave);
    notifyListeners();
  }

  ///
  /// MUSHAF STYLE SETTINGS
  bool displayMushafStyle = false;

  fetchMushafStyleValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    displayMushafStyle = prefs.getBool("mushafStyle") ?? false;
  }

  showMushafStyleFunc({value}) {
    displayMushafStyle = value;
    notifyListeners();
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///ARABIC  section from here  *****************************************
  bool showArabic = true;

  fetchShowArabicValue() async {
    showArabic = await FileStorage().readFile(
              fileNameToReadFrom: 'showArabicText',
            ) ==
            'false'
        ? false
        : true;
    // print(showArabic);
  }

  showArabicFunc({value}) {
    showArabic = value;
    notifyListeners();
  }

  ///  ************************************************************ ************************************************************
  /// ******************************* change arabic type is here ************************************************************

  var selectedArabicType = 'Indo - Pak';

  ///this function deals the changing of the arabic type in the settings menu
  changeArabicType({arabicType}) {
    selectedArabicType = arabicType;

    notifyListeners();
  }

  ///this function fetches the arabic type which is written in a permanent file
  fetchArabicType() async {
    selectedArabicType = await ArabicTypeStorage()
        .readArabicType(fileNameToReadFrom: 'arabic_type');
    notifyListeners();
  }

  ///this is the  function which fetches the quran selected script after the script has been selected by the user
  fetchQuranScriptForOpenedSurah({required context}) {
    // print(openedSurahNumber);
    if (openedSurahNumber != null) {
      Provider.of<Data>(context, listen: false)
          .quranFetch(surahNumber: openedSurahNumber);

      notifyListeners();
    }
  }

  ///  ************************************************************ ************************************************************
  ///
  //**************************************************************************************

  ///TRANSLATION section from here ****************************************************************
  bool showTranslation = true;

  showTranslationFunc({value}) {
    showTranslation = value;
    notifyListeners();
  }

  ///
  ///

  fetchShowLanguageValue() async {
    showTranslation = await FileStorage().readFile(
              fileNameToReadFrom: 'showLanguageText',
            ) ==
            'false'
        ? false
        : true;
    // print(showTranslation);
  }

  ///
  ///
  ///
  ///

  ///settings for transliteration starts from here

  bool showTransliteration = false;

  showTransliterationFunc({value}) {
    showTransliteration = value;
    notifyListeners();
  }

  /// fetch transliteration value function
  fetchShowTransliterationValue() async {
    showTransliteration = await FileStorage().readFile(
              fileNameToReadFrom: 'showTransliteration',
            ) ==
            'false'
        ? false
        : true;
    // print(showTranslation);
  }

  /*

  settings for transliteration ENDED  here
  */

  ///
  ///
  /// font Size*****************settings here*********************************************
  ///
  /// arabic font Size Settings Start**********************
  ///
  var arabicFontSize = 24.0;

  arabicFontSizeFunc({value}) async {
    final prefs = await SharedPreferences.getInstance();
    arabicFontSize = value;

    /// saving font size
    await prefs.setDouble('arabicFontSize', value);
    notifyListeners();
  }

  /// fetching arabic font size function  here
  fetchArabicFontSize() async {
    final prefs = await SharedPreferences.getInstance();

    arabicFontSize = prefs.getDouble("arabicFontSize") ?? 24;

    // arabicFontSize = double.parse(x);
    // print(' fetched arabic font size =' + x + ' ' + arabicFontSize.toString());
  }

  /// arabic font Size Settings END********************

  ///
  ///
  /// fetching translation Language font size function  here**************
  // var translationFontSize = 15.0;
  var translationFontSize = 15.0;

  translationFontSizeFunc({value}) async {
    final prefs = await SharedPreferences.getInstance();
    translationFontSize = value;
    await prefs.setDouble("translationFontSize", value);

    notifyListeners();
  }

  fetchLanguageFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    translationFontSize = prefs.getDouble("translationFontSize") ?? 15;
  }

  ///
  ///
  /// fetching transliteration  font size function  here**************

  var transliterationFontSize = 11.0;

  transliterationFontSizeFunc({value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    transliterationFontSize = value;

    await prefs.setDouble("transliterationFontSize", transliterationFontSize);

    notifyListeners();
  }

  fetchTransliterationFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    transliterationFontSize = prefs.getDouble('transliterationFontSize') ?? 11;
  }

  ///
  ///
  /// FONT SIZE*****************settings ENDED*********************************************

  ///
  ///
  ///
  ///
  ///from here everything deals with switch the narrator for the settings**********************************
  /// here we are the functions to search for language translators in language_meta_data class
  ///
  late List translators = [];

  searchTranslators() {
    translators = LanguageMetaData()
        .languages
        .where((e) => e['language_name'] == selectedLanguage)
        .toList();

    // notifyListeners();
  }

  ///
  ///
  var selectedTranslatorName;

  assignTranslatorName({translatorName}) {
    selectedTranslatorName = translatorName;
    notifyListeners();
  }

  ///getting surah number here in order to fetch the new selected translator
  var openedSurahNumber;

  // fetch Chosen TranslationForThe opened Surrah
  fetchOpenedTranslatorSurah({required context}) {
    // print(openedSurahNumber);
    if (openedSurahNumber != null) {
      Provider.of<Data>(context, listen: false)
          .translationFetch(surahNumber: openedSurahNumber);

      notifyListeners();
    }
  }

  ///
  /// here we are making the translators and language permanent
  /// here we are making the translators and language permanent
  /// here we are making the translators and language permanent
  /// here we are making the translators and language permanent
  ///
  ///
  ///
  fetchLanguageName() async {
    var x = await TranslatorFileStorage().readLanguageName(
      fileNameToReadFrom: 'languageName',
    );
    selectedLanguage = x;
    notifyListeners();
    // print('LanguageName provider = ' + x.toString());
  }

  ///translator name fetch from the memory
  ///
  fetchTranslatorName({required context}) async {
    var x = await TranslatorFileStorage().readTranslatorName(
      fileNameToReadFrom: 'translatorName',
    );
    selectedTranslatorName = x;
    notifyListeners();
    // print('translatorName = ' + x.toString());
  }

  fetchTranslationName({required context}) async {
    var x = await TranslatorFileStorage().readTranslationName(
      fileNameToReadFrom: 'translationName',
    );

    Provider.of<Data>(context, listen: false).translationName = x;
    // print('translationName = ' + x.toString());
    notifyListeners();
  }

  ///
  writeTranslatorNameAndTranslationName({
    required String translatorName,
    required String translationName,
  }) async {
    try {
      TranslatorFileStorage().writeFile(
          whatToSave: translatorName, fileNameToSaveIn: 'translatorName');
      TranslatorFileStorage().writeFile(
          whatToSave: translationName, fileNameToSaveIn: 'translationName');
      notifyListeners();
    } catch (err) {
      print('some error happened while saving x and b= ' + err.toString());
    }
  }

  ///
  /// translators section  ended here*******************************************************************
  ///
  ///
  /// ///
  /// deals with language TextStyle start here**************************
  ///
  ///.

  changeDirectionalityAccordingToLanguage() {
    if (selectedLanguage == 'Urdu' ||
        selectedLanguage == 'Arabic' ||
        selectedLanguage == 'Divehi' ||
        selectedLanguage == 'Kurdish' ||
        selectedLanguage == 'Pashto' ||
        selectedLanguage == 'Persian' ||
        selectedLanguage == 'Sindhi' ||
        selectedLanguage == 'Uyghur') {
      return TextDirection.rtl;
    } else {
      return TextDirection.ltr;
    }
  }

  TextStyle changeTranslationTxtStyleAccordingToLanguage(
      {required widget, context}) {
    if (selectedLanguage == 'Urdu') {
      return TextStyle(
          // fontSize: changeFontSizeAccordingToLanguage(widget: widget),
          fontSize: .5 + translationFontSize.sp,
          height: 1.9,
          fontFamily: 'Noto',
          color: Provider.of<ThemeProvider>(context).translationFontColor);
    } else if (selectedLanguage == 'Arabic' ||
        selectedLanguage == 'Divehi' ||
        selectedLanguage == 'Kurdish' ||
        selectedLanguage == 'Pashto' ||
        selectedLanguage == 'Persian' ||
        selectedLanguage == 'Sindhi' ||
        selectedLanguage == 'Uyghur') {
      return GoogleFonts.roboto(
        fontSize: 2.7 + translationFontSize.sp,
        height: 1.25,
        color: Provider.of<ThemeProvider>(context).translationFontColor,
      );
    } else {
      return GoogleFonts.roboto(
          fontSize: translationFontSize.sp - 1.5,
          height: 1.25,
          color: Provider.of<ThemeProvider>(context).translationFontColor);
    }
  }

  ///from here are teh tafsir function******************************************************************************
  ///[fetchTafsirSavedData]will assign the tafsirs according to the selected language by the user . assigning of this will only happen if the value read is null

  fetchTafsirSavedData() async {
    var selectedLanguage = await TranslatorFileStorage().readLanguageName(
      fileNameToReadFrom: 'languageName',
    );
    final prefs = await SharedPreferences.getInstance();
    final int? tafsirId = prefs.getInt('tafsir_id');
    // print('tafsirId for 1st time value = ' + tafsirId.toString());
    // print('selectedLanguage = ' + selectedLanguage.toString());

    if (tafsirId == null && selectedLanguage != 'null') {
      switch (selectedLanguage.toString().toLowerCase()) {
        case 'english':
          {
            prefs.setInt('tafsir_id', 169);
            prefs.setString('tafsir_name', "Tafseer ibn Kathir");
            selectedTafsirName = 'Tafseer ibn Kathir';

            notifyListeners();
            break;
          }
        case 'bengali':
          {
            prefs.setInt('tafsir_id', 164);
            prefs.setString('tafsir_name', "Tafseer ibn Kathir");
            selectedTafsirName = 'Tafseer ibn Kathir';
            notifyListeners();
            break;
          }
        case 'arabic':
          {
            prefs.setInt('tafsir_id', 16);
            prefs.setString('tafsir_name', "Tafsir Muyassar");
            selectedTafsirName = "Tafsir Muyassar";
            notifyListeners();
            break;
          }
        case 'russian':
          {
            prefs.setInt('tafsir_id', 170);
            prefs.setString('tafsir_name', "Tafseer Al Saddi");
            selectedTafsirName = "Tafseer Al Saddi";
            notifyListeners();
            break;
          }
        case 'urdu':
          {
            prefs.setInt('tafsir_id', 159);
            prefs.setString('tafsir_name', "Tafsir Bayan ul Quran");
            selectedTafsirName = "Tafsir Bayan ul Quran";
            notifyListeners();
            break;
          }
      }
    } else {
      prefs.getInt('tafsir_id');
      selectedTafsirName = prefs.getString('tafsir_name')!;
    }
  }

  assignTafsirOnLanguageChange() async {
    final prefs = await SharedPreferences.getInstance();
    // final int? tafsirId = prefs.getInt('tafsir_id');

    switch (selectedLanguage.toString().toLowerCase()) {
      case 'english':
        {
          prefs.setInt('tafsir_id', 169);
          prefs.setString('tafsir_name', "Tafseer ibn Kathir");
          selectedTafsirName = 'Tafseer ibn Kathir';

          break;
        }
      case 'bengali':
        {
          prefs.setInt('tafsir_id', 164);
          prefs.setString('tafsir_name', "Tafseer ibn Kathir");
          selectedTafsirName = 'Tafseer ibn Kathir';
          break;
        }
      case 'arabic':
        {
          prefs.setInt('tafsir_id', 16);
          prefs.setString('tafsir_name', "Tafsir Muyassar");
          selectedTafsirName = "Tafsir Muyassar";
          break;
        }
      case 'russian':
        {
          prefs.setInt('tafsir_id', 170);
          prefs.setString('tafsir_name', "Tafseer Al Saddi");
          selectedTafsirName = "Tafseer Al Saddi";
          break;
        }
      case 'urdu':
        {
          prefs.setInt('tafsir_id', 159);
          prefs.setString('tafsir_name', "Tafsir Bayan ul Quran");
          selectedTafsirName = "Tafsir Bayan ul Quran";
          break;
        }
    }
  }

  late List tafsirs = [];

  /// [getTafsirs] function will search and return all the available tafsirs for the selected language
  getTafsirs() async {
    // print(selectedLanguage);
    tafsirs = tafsirs_meta_data
        .where((e) =>
            e['language_name'] == selectedLanguage.toString().toLowerCase())
        .toList();
    // notifyListeners();
    // print(tafsirs);
  }

  /// update tafsir name tafsir option in settings
  String selectedTafsirName = '';

  updateSelectedTafsirName({tafsirName}) async {
    selectedTafsirName = tafsirName;
    notifyListeners();
  }

  ///
  Style changeTafsirTextStyleAccordingToLanguage({required cmh, context}) {
    if (selectedLanguage == 'Urdu') {
      return Style(
          padding: EdgeInsets.only(top: cmh * 0.01),
          // lineHeight: LineHeight.number(cmh * 0.001405),
          lineHeight: LineHeight.number(1.3),
          // fontSize: FontSize(cmh * 0.0 + translationFontSize + 8.1),
          fontSize: FontSize(translationFontSize.sp + 7.5),
          fontFamily: 'tafsir_urdu_font',
          textAlign: TextAlign.right,
          color: Provider.of<ThemeProvider>(context).translationFontColor);
    } else if (selectedLanguage == 'Arabic' ||
        selectedLanguage == 'Divehi' ||
        selectedLanguage == 'Kurdish' ||
        selectedLanguage == 'Pashto' ||
        selectedLanguage == 'Persian' ||
        selectedLanguage == 'Sindhi' ||
        selectedLanguage == 'Uyghur') {
      return Style(
        fontFamily: 'Uthmani_hafs_official',
        fontSize: FontSize(cmh * 0.0 + translationFontSize + 9.5),
        textAlign: TextAlign.right,
        color: Provider.of<ThemeProvider>(context).translationFontColor,
      );
    } else {
      return Style(
          fontFamily: 'lato',
          fontSize: FontSize(translationFontSize.sp - 3.5),
          color: Provider.of<ThemeProvider>(context).translationFontColor);
    }
  }

  ///
  ///
// FontWeight uthmaniFontWeight = FontWeight.bold;

  /// quran Script font variables
  ///
  /// for indo pak
  String indoPakScriptFont = "indo_pak_font";

  /// for uthmani
  String uthmaniScriptFont = "Uthmani_hafs_v20";
  String surahNamesFont = "surah_names_font";

  /// manages the ascending and the descending order oft he surah names

  /// surah and juz sorting
  bool isDescending = false;

  updateIsDescendingBool(bool value) {
    isDescending = value;
    notifyListeners();
  }

  ///******************************************** *****************************************************
  ///******************************************** *****************************************************
  ///===================================== APP VERSION ===============================================
  ///******************************************** *****************************************************
  ///******************************************** *****************************************************

  String appVersion = '1.1.7';
}
