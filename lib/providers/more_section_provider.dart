import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MoreSectionProvider extends ChangeNotifier {
  ///
  ///
  ///
  TextStyle changeTranslationTxtStyleAccordingToLanguage({cmh, cmw, context}) {
    if (Provider.of<SettingsProvider>(context).selectedLanguage == 'Urdu') {
      return TextStyle(
          // fontSize: changeFontSizeAccordingToLanguage(widget: widget),
          fontSize:
              Provider.of<SettingsProvider>(context).translationFontSize.sp ,
          height: 1.9,
          fontFamily: 'Noto',
          color: Provider.of<ThemeProvider>(context).translationFontColor);
    } else if (Provider.of<SettingsProvider>(context).selectedLanguage ==
            'Arabic' ||
        Provider.of<SettingsProvider>(context).selectedLanguage == 'Divehi' ||
        Provider.of<SettingsProvider>(context).selectedLanguage == 'Kurdish' ||
        Provider.of<SettingsProvider>(context).selectedLanguage == 'Pashto' ||
        Provider.of<SettingsProvider>(context).selectedLanguage == 'Persian' ||
        Provider.of<SettingsProvider>(context).selectedLanguage == 'Sindhi' ||
        Provider.of<SettingsProvider>(context).selectedLanguage == 'Uyghur') {
      return GoogleFonts.roboto(
        fontSize: cmh * 0.0 +
            Provider.of<SettingsProvider>(context).translationFontSize +
            9.5,
        height: 1.25,
        color: Provider.of<ThemeProvider>(context).translationFontColor,
      );
    } else {
      return GoogleFonts.roboto(
          fontSize:
              Provider.of<SettingsProvider>(context).translationFontSize.sp -1.9,
          height: 1.25,
          color: Provider.of<ThemeProvider>(context).translationFontColor);
    }
  }

  /// allah names provider**************************************************************
  ///
  ///

}
