import 'package:al_quran/components/make_values_permanet_class/make_theme_permanent.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool darkTheme = true;

  getThemeValue() async {
    var gettingValue =
        await ThemeFileStorage().readThemeBool(fileNameToReadFrom: 'theme');
    switch (gettingValue) {
      case 'true':
        {
          bool value = true;
          return switchTheme(value: value);
        }
      case 'false':
        {
          bool value = false;
          return switchTheme(value: value);
        }
    }
  }

  ///these are default colors
  ///white theme
  Color scaffoldBackgroundColor = const Color(0xffF5F5F5);
  Color appBarColor = const Color(0xff223C63);
  Color topSurahData = Colors.white;
  Color translationFontColor = const Color(0xff223C63);
  Color arabicFontColor = Colors.black.withOpacity(.79);
  Color arabicChangeRecitationStylePopUpContainerColor =
      const Color(0xffF5F5F5);
  Color evenContainerColor = const Color(0xffF6ECBF).withOpacity(.5);
  Color oddContainerColor = Colors.transparent;
  Color ayahEnglishNumberBorderColor = const Color(0xff223C63).withOpacity(0.2);
  Color ayahEnglishNumbersColor = const Color(0xff223C63).withOpacity(.7);
  Color bismillahContainerColor = Colors.transparent;

//
// this is for names pages
  Color namesScaffoldBackgroundColor = const Color(0xffF5F5F5);
  Color namesContainerColor = Colors.white;
  Color namesEnglishSurahFontColor = const Color(0xff223C63);
  Color namesArabicSurahFontColor = Colors.black;
  Color namesIndexContainerColor = Colors.blueGrey.shade50;
  Color namesIndexFontColor = const Color(0xff223C63);

//
//menu theme
  Color menuBackgroundColor = const Color(0xffF5F5F5);

  // /// //settings ui theme
  Color settingsScaffoldBackgroundColor = const Color(0xffF5F5F5);
  Color settingsAppBarColor = const Color(0xff223C63);
  Color settingsFontColor = const Color(0xff223C63);
  Color settingsItemFontColor = Colors.black;
  Color settingsItemTitleFontColor = const Color(0xff223C63);
  Color settingsItemContainerColor = Colors.white;
  Color settingsSwitchInactiveTrackColor = Colors.grey;
  Color settingsFontSizeChangeModalColor = Colors.white;
  Color settingsBoxShadowColor = Colors.grey;

  ///translator screen theme
  Color translatorScaffoldBackgroundColor = Colors.white;
  Color translatorFontColor = Colors.black;
  Color translatorDividerColor = Colors.grey.withOpacity(.35);
  Color translatorTitleColor = Colors.black;

  ///

  /// reciter screen theme
  Color reciterScaffoldBackgroundColor = Colors.white;
  Color reciterNamesColor = Colors.black;
  Color reciterSubInfoTitleColor = Colors.black;
  Color reciterImageShadowColor = Colors.grey;

  ///updates screen theme
  Color updatesContainerColor = Colors.white;
  Color updatesTitlesColor = Colors.black;
  Color updatesContainerShadowColor = Colors.grey;

  ///
  ///bottom music player theme
  Color musicPlayerButtonsColor = Colors.black;

  ///speaker color
  Color speakerColor = const Color(0xff223c63);

  ///change language screen theme color
  Color languageScreenScaffoldColor = const Color(0xffFEECE3);
  Color languageScreenTitleFontColor = Colors.black;
  Color languageScreenLanguageContainerColor = Colors.white;
  Color languageScreenSearchHintFontColor = Colors.grey;
  Color languageScreenSearchFontColor = Colors.black;

  ///circularProgressIndicatorColor theme
  Color circularProgressIndicatorColor = Colors.blueGrey;

  ///
  /// on click menu theme
  Color onClickMenuBackgroundColor = const Color(0xffF5F5F5);

  ///last read icon color
  Color lastReadIconColor = const Color(0xff223C63);

  ///favourites screen colors

  Color favouritesVerseContainerDividerColor = const Color(0xff223C63);
  Color scrollBarColor = const Color(0xff223C63);
  Color favouritesVerseInfoColor = Colors.white;
  Color favouritesVerseInfoDividerColor = Colors.white;
  Color favouritesEnglishNumberBorderColor = Colors.white;
  Color favouritesEnglishNumberColor = Colors.white;

  ///allah names theme
  Color allahNamesFontColor = Colors.black;

  ///salah Times colors
  Color salahTimesMainSalahCardBorderColor =
      const Color(0xff707070).withOpacity(.25);
  Color salahTimesMainSalahCardContainerColor = Colors.white;

  Color salahTimesEnglishDateColor = Colors.black;

  Color salahTimesLightGreyColor = const Color(0xff707070);
  Color salahTimesBlackColor = Colors.black;
  Color salahTimesMainSalahNameColor = const Color(0xff707070).withOpacity(.69);
  Color salahTimesHighlightSalahContainerColor = const Color(0xff223C63);
  Color salahTimeMetaInfoColor = const Color(0xff707070);

  Color salahTimesBottomAppBarIconColor = const Color(0xff223C63);

  Color salahTimesCompassInnerMarginColor = const Color(0xff223C63);
  Color salahTimesCompassOuterMarginColor = Colors.white;

  /// hijri calendar theme
  Color salahTimesHijriCalendarScaffoldColor = Colors.white;
  Color salahTimesHijriCalendarDividerColor = Colors.grey.withOpacity(.15);
  Color salahTimesHijriCalendarShadowColor = Colors.black.withOpacity(.16);
  Color salahTimesHijriCalendarBorderColor =
      const Color(0xff707070).withOpacity(.35);
  Color salahTimesHijriCalendarFontColor = const Color(0xff223C63);
  Color salahTimesHijriCalendarTopMonthFontColor = const Color(0xff707070);
  Color salahTimesHijriCalendarPastDatesBackgroundColor =
      Colors.grey.withOpacity(.05);
  Color salahTimesHijriCalendarWeekdayTitlesFontColor = Colors.black;
  Color salahTimesHijriCalendarTodayTitlesFontColor = const Color(0xff223C63);

  ///
  ///
  ///***********************************************************************
  ///***********************************************************************
  ///***********************************************************************

  changeTheme() async {
    if (darkTheme == true) {
      blackTheme();
      notifyListeners();
    } else {
      lightTheme();

      ///APP Bar Color **********

      notifyListeners();
    }
  }

  blackTheme() async {
    /// //black theme
    /// ///this for display pages
    scaffoldBackgroundColor = Colors.black;
    appBarColor = Colors.black;
    topSurahData = const Color(0xff23262B);
    translationFontColor = Colors.white60.withOpacity(.67);
    arabicFontColor = Colors.white60.withOpacity(.79);
    arabicChangeRecitationStylePopUpContainerColor = const Color(0xffF6ECBF);
    evenContainerColor = const Color(0xff1A1A1A);
    oddContainerColor = Colors.black;
    ayahEnglishNumberBorderColor = const Color(0xffF6ECBF).withOpacity(.5);
    ayahEnglishNumbersColor = const Color(0xffF6ECBF).withOpacity(0.5);
    bismillahContainerColor = const Color(0xffF6ECBF).withOpacity(.5);

    ///
    /// this is for names pages
    namesScaffoldBackgroundColor = const Color(0xff1A1A1A);
    namesContainerColor = Colors.black;
    namesEnglishSurahFontColor = Colors.white60.withOpacity(.79);
    namesArabicSurahFontColor = const Color(0xffF6ECBF).withOpacity(.5);
    namesIndexContainerColor = const Color(0xffF6ECBF).withOpacity(.5);
    namesIndexFontColor = Colors.black;

    ///menu theme
    menuBackgroundColor = const Color(0xffB0A988);

    ///settings ui theme
    settingsScaffoldBackgroundColor = const Color(0xff1A1A1A);
    settingsAppBarColor = Colors.black;
    settingsItemTitleFontColor = const Color(0xffB0A988);
    settingsItemFontColor = Colors.white60.withOpacity(.79);
    settingsItemContainerColor = Colors.black;
    settingsSwitchInactiveTrackColor = Colors.white70;
    settingsFontSizeChangeModalColor = const Color(0xffB0A988);
    settingsBoxShadowColor = Colors.transparent;

    ///
    ///translator screen theme
    translatorScaffoldBackgroundColor = Colors.black;
    translatorFontColor = Colors.white60.withOpacity(.79);
    translatorDividerColor = const Color(0xffB0A988).withOpacity(.2);
    translatorTitleColor = const Color(0xffB0A988);

    ///
    /// reciter screen theme
    reciterScaffoldBackgroundColor = Colors.black;
    reciterNamesColor = const Color(0xffB0A988);
    reciterSubInfoTitleColor = const Color(0xffB0A988).withOpacity(.5);
    reciterImageShadowColor = Colors.transparent;

    ///

    ///updates screen theme
    updatesContainerColor = Colors.black;
    updatesTitlesColor = const Color(0xffB0A988);
    updatesContainerShadowColor = Colors.transparent;

    ///
    ///bottom music player theme
    musicPlayerButtonsColor = const Color(0xffB0A988);

    ///

    ///speaker color
    speakerColor = const Color(0xffB0A988);

    ///change language screen theme color

    languageScreenScaffoldColor = Colors.black;
    languageScreenTitleFontColor = Colors.white;
    languageScreenLanguageContainerColor = const Color(0xff1A1A1A);
    languageScreenSearchHintFontColor = const Color(0xffB0A988);
    languageScreenSearchFontColor = const Color(0xffB0A988);

    ///circularProgressIndicatorColor theme
    circularProgressIndicatorColor = const Color(0xffB0A988);

    ///
    /// on click menu theme
    onClickMenuBackgroundColor = const Color(0xffB0A988);

    ///last read icon color
    lastReadIconColor = const Color(0xffB0A988);

    /// favourites screen colors
    favouritesVerseContainerDividerColor =
        const Color(0xffF6ECBF).withOpacity(.5);
    scrollBarColor = const Color(0xc3b0a988).withOpacity(.1);
    favouritesVerseInfoColor = Colors.white;
    favouritesVerseInfoDividerColor = const Color(0xffF6ECBF).withOpacity(.5);
    favouritesEnglishNumberBorderColor =
        const Color(0xffF6ECBF).withOpacity(.5);
    favouritesEnglishNumberColor = const Color(0xffF6ECBF).withOpacity(0.5);

    ///****************************
    ///allah names theme
    allahNamesFontColor = const Color(0xffaaa375);

    ///salah Times colors
    salahTimesMainSalahCardBorderColor = const Color(0xffaaa375);
    salahTimesMainSalahCardContainerColor = const Color(0xff3D3D3F);
    salahTimesEnglishDateColor = const Color(0xffaaa375);

    salahTimesLightGreyColor = const Color(0xff707070);
    salahTimesBlackColor = const Color(0xff707070);
    salahTimesMainSalahNameColor = const Color(0xffaaa375);
    salahTimesHighlightSalahContainerColor = const Color(0xff223C63);
    salahTimeMetaInfoColor = const Color(0xffaaa375);
    salahTimesBottomAppBarIconColor = const Color(0xffaaa375);
    salahTimesCompassInnerMarginColor = const Color(0xffaaa375);
    salahTimesCompassOuterMarginColor = const Color(0xff223C63);

    /// hijri calendar theme\
    salahTimesHijriCalendarScaffoldColor = Colors.black;
    salahTimesHijriCalendarDividerColor = Colors.grey.withOpacity(.15);
    salahTimesHijriCalendarTopMonthFontColor = const Color(0xffaaa375);
    salahTimesHijriCalendarPastDatesBackgroundColor =
        Colors.grey.withOpacity(.75);
    salahTimesHijriCalendarWeekdayTitlesFontColor = const Color(0xffaaa375);
    salahTimesHijriCalendarTodayTitlesFontColor = const Color(0xffaaa375);
  }

  ///********************************************************************************************************
  ///********************************************************************************************************
  ///********************************************************************************************************
  ///
  ///
  lightTheme() async {
    ///these are default colors
    ///white theme
    scaffoldBackgroundColor = const Color(0xffF5F5F5);
    appBarColor = const Color(0xff223C63);
    topSurahData = Colors.white;
    translationFontColor = const Color(0xff223C63);
    arabicFontColor = Colors.black.withOpacity(.79);
    arabicChangeRecitationStylePopUpContainerColor = const Color(0xffF5F5F5);
    evenContainerColor = const Color(0xffF6ECBF).withOpacity(.5);
    oddContainerColor = Colors.transparent;
    ayahEnglishNumberBorderColor = const Color(0xff223C63).withOpacity(0.2);
    ayahEnglishNumbersColor = const Color(0xff223C63).withOpacity(.7);
    bismillahContainerColor = Colors.transparent;

//
// this is for names pages
    namesScaffoldBackgroundColor = const Color(0xffF5F5F5);
    namesContainerColor = Colors.white;
    namesEnglishSurahFontColor = const Color(0xff223C63);
    namesArabicSurahFontColor = Colors.black;
    namesIndexContainerColor = Colors.blueGrey.shade50;
    namesIndexFontColor = const Color(0xff223C63);

//
//menu theme
    menuBackgroundColor = const Color(0xffF5F5F5);

    // /// //settings ui theme
    settingsScaffoldBackgroundColor = const Color(0xffF5F5F5);
    settingsAppBarColor = const Color(0xff223C63);
    settingsFontColor = const Color(0xff223C63);
    settingsItemFontColor = Colors.black;
    settingsItemTitleFontColor = const Color(0xff223C63);
    settingsItemContainerColor = Colors.white;
    settingsSwitchInactiveTrackColor = Colors.grey;
    settingsFontSizeChangeModalColor = Colors.white;
    settingsBoxShadowColor = Colors.grey;

    ///translator screen theme
    translatorScaffoldBackgroundColor = Colors.white;
    translatorFontColor = Colors.black;
    translatorDividerColor = Colors.grey.withOpacity(.35);
    translatorTitleColor = Colors.black;

    ///

    /// reciter screen theme
    reciterScaffoldBackgroundColor = Colors.white;
    reciterNamesColor = Colors.black;
    reciterSubInfoTitleColor = Colors.black;
    reciterImageShadowColor = Colors.grey;

    ///
    ///

    ///updates screen theme
    updatesContainerColor = Colors.white;
    updatesTitlesColor = Colors.black;
    updatesContainerShadowColor = Colors.grey;

    ///
    ///
    ///bottom music player theme
    musicPlayerButtonsColor = Colors.black;

    ///speaker color
    speakerColor = const Color(0xff223C63);

    ///change language screen theme color
    languageScreenScaffoldColor = const Color(0xffFEECE3);
    languageScreenTitleFontColor = Colors.black;
    languageScreenLanguageContainerColor = Colors.white;
    languageScreenSearchHintFontColor = Colors.grey;
    languageScreenSearchFontColor = Colors.black;

    ///circularProgressIndicatorColor theme
    circularProgressIndicatorColor = Colors.blueGrey;

    ///
    /// on click menu theme
    onClickMenuBackgroundColor = const Color(0xffF5F5F5);

    ///last read icon color
    lastReadIconColor = const Color(0xff223C63);

    ///favourites screen colors
    favouritesVerseContainerDividerColor = const Color(0xff223C63);
    scrollBarColor = const Color(0xff223C63);
    favouritesVerseInfoColor = Colors.white;
    favouritesVerseInfoDividerColor = Colors.white;
    favouritesEnglishNumberBorderColor = Colors.white;
    favouritesEnglishNumberColor = Colors.white;

    ///****************************
    ///allah names theme
    allahNamesFontColor = Colors.black;

    ///salah Times colors
    salahTimesMainSalahCardBorderColor =
        const Color(0xff707070).withOpacity(.25);
    salahTimesEnglishDateColor = Colors.black;
    salahTimesMainSalahCardContainerColor = Colors.white;
    salahTimesLightGreyColor = const Color(0xff707070);
    salahTimesBlackColor = Colors.black;
    salahTimesMainSalahNameColor = const Color(0xff707070).withOpacity(.69);
    salahTimesHighlightSalahContainerColor = const Color(0xff223C63);
    salahTimeMetaInfoColor = const Color(0xff707070);

    salahTimesBottomAppBarIconColor = const Color(0xff223C63);

    salahTimesCompassInnerMarginColor = const Color(0xff223C63);
    salahTimesCompassOuterMarginColor = Colors.white;

    /// hijri calendar theme
    salahTimesHijriCalendarScaffoldColor = Colors.white;
    salahTimesHijriCalendarDividerColor = Colors.grey.withOpacity(.15);
    salahTimesHijriCalendarShadowColor = Colors.black.withOpacity(.16);
    salahTimesHijriCalendarBorderColor =
        const Color(0xff707070).withOpacity(.35);
    salahTimesHijriCalendarFontColor = const Color(0xff707070);
    salahTimesHijriCalendarTopMonthFontColor = const Color(0xff707070);
    salahTimesHijriCalendarPastDatesBackgroundColor =
        Colors.grey.withOpacity(.05);
    salahTimesHijriCalendarWeekdayTitlesFontColor = Colors.black;
    salahTimesHijriCalendarTodayTitlesFontColor = const Color(0xff223C63);
  }

  switchTheme({required value}) async {
    darkTheme = value;
    notifyListeners();
    changeTheme();
  }
}
