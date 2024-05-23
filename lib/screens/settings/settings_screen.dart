import 'package:al_quran/components/make_values_permanet_class/make_theme_permanent.dart';
import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/components/settings_components/arabic_settings.dart';
import 'package:al_quran/components/settings_components/language_translation_settings.dart';
import 'package:al_quran/components/settings_components/mushaf_settings.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:al_quran/screens/settings/about_us.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../components/settings_components/transliteration_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    _value = Provider.of<ThemeProvider>(context, listen: false).darkTheme;
    var mq = MediaQuery.of(context).size;
    var provider = Provider.of<Data>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.settingsScaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.settingsAppBarColor,
        title: const Text('SETTINGS'),
        centerTitle: true,
      ),
      body: ScrollConfiguration(
        behavior: RemoveListViewGlow(),
        child: LayoutBuilder(builder: (context, constraints) {
          var cmh = constraints.maxHeight;
          var cmw = constraints.maxWidth;
          return SizedBox(
            height: cmh,
            width: cmw,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ///theme switch here
                  Padding(
                    padding:
                        EdgeInsets.only(top: cmh * 0.01, left: cmh * 0.021),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'Theme',
                            style: GoogleFonts.roboto(
                                color: themeProvider.settingsItemTitleFontColor,
                                fontWeight: FontWeight.bold,
                                fontSize: cmh * 0.020),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: cmw * 0.01),
                                child: Text(
                                  'LIGHT',
                                  style: GoogleFonts.lato(
                                      color:
                                          themeProvider.settingsItemFontColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: cmh * 0.019),
                                ),
                              ),
                              Switch(
                                  inactiveTrackColor: themeProvider
                                      .settingsSwitchInactiveTrackColor,
                                  activeColor: Colors.black,
                                  value: _value,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value;
                                      themeProvider.switchTheme(value: value);

                                      ///saving theme to permanent file here
                                      ThemeFileStorage().writeTheme(
                                          fileNameToSaveIn: 'theme',
                                          whatToSave: value.toString());
                                    });
                                  }),
                              Padding(
                                padding: EdgeInsets.only(left: cmw * 0.01),
                                child: Text(
                                  'DARK',
                                  style: GoogleFonts.lato(
                                      color:
                                          themeProvider.settingsItemFontColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: cmh * 0.019),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    thickness: cmh * 0.001,
                    color: const Color(0xff223C63).withOpacity(0.2),
                  ),
                  MushafSettings(cmw: cmw, cmh: cmh),
                  ArabicSettings(cmh: cmh, cmw: cmw),

                  TransliterationSettings(cmh: cmh, cmw: cmw),
                  LanguageTranslationSettings(cmh: cmh, cmw: cmw),

                  AboutUS(cmh: cmh, cmw: cmw),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
