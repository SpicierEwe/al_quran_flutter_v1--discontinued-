import 'package:al_quran/Navigators/navigator_controller_surah_names_screen.dart';
import 'package:al_quran/components/make_values_permanet_class/make_translators_permanent.dart';
import 'package:al_quran/providers/audio_provider.dart';
import 'package:al_quran/providers/bookmarks_provider.dart';
import 'package:al_quran/providers/favourites_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:al_quran/screens/select_language_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreenNavigator extends StatefulWidget {
  const MainScreenNavigator({Key? key}) : super(key: key);

  @override
  State<MainScreenNavigator> createState() => _MainScreenNavigatorState();
}

class _MainScreenNavigatorState extends State<MainScreenNavigator> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const NavigatorControllerSurahNamesScreen()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const SelectLanguageScreen()));
    }
  }

  tt() async {
    var x = await TranslatorFileStorage().readLanguageName(
      fileNameToReadFrom: 'languageName',
    );

    if (x != 'null') {
      // print('(if) lang == $x');
      await Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const NavigatorControllerSurahNamesScreen()));
    } else {
      // print('else = ' + x.toString());
      await Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const SelectLanguageScreen()));
    }
  }

  var languageName;

  @override
  void initState() {
    Provider.of<ThemeProvider>(context, listen: false).getThemeValue();

    Provider.of<SettingsProvider>(context, listen: false)
        .fetchShowArabicValue();
    Provider.of<SettingsProvider>(context, listen: false)
        .fetchShowLanguageValue();
    Provider.of<SettingsProvider>(context, listen: false)
        .fetchShowTransliterationValue();
    Provider.of<SettingsProvider>(context, listen: false).fetchArabicFontSize();
    Provider.of<SettingsProvider>(context, listen: false)
        .fetchTransliterationFontSize();
    Provider.of<SettingsProvider>(context, listen: false)
        .fetchLanguageFontSize();
    //
    Provider.of<SettingsProvider>(context, listen: false).fetchLanguageName();
    //
    Provider.of<SettingsProvider>(context, listen: false)
        .fetchTranslatorName(context: context);
    //
    Provider.of<SettingsProvider>(context, listen: false)
        .fetchTranslationName(context: context);

    Provider.of<AudioProvider>(context, listen: false).fetchReciterName();
    Provider.of<AudioProvider>(context, listen: false).fetchRecitationStyle();
    Provider.of<BookmarksProvider>(context, listen: false).fetchLastReadSurah();
    Provider.of<BookmarksProvider>(context, listen: false).fetchLastReadJuz();
    tt();
    Provider.of<SettingsProvider>(context, listen: false).fetchArabicType();
    Provider.of<FavouritesProvider>(context, listen: false)
        .fetchSelectedArabicType();

    Provider.of<FavouritesProvider>(context, listen: false)
        .getFavouriteVersesList();
    Provider.of<SettingsProvider>(context, listen: false)
        .fetchTafsirSavedData();
    Provider.of<SettingsProvider>(context, listen: false)
        .fetchMushafStyleValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.scaffoldBackgroundColor,
      body: Center(
        child: CircularProgressIndicator(
            color: Provider.of<ThemeProvider>(context)
                .circularProgressIndicatorColor),
      ),
    );
  }
}
