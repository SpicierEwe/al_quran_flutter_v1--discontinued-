import 'dart:convert';
import 'package:flutter/services.dart' as services;
import 'package:al_quran/components/make_values_permanet_class/make_font_sizes_permanent_class.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:al_quran/screens/settings/select_tafsir_screen.dart';
import 'package:al_quran/screens/settings/select_translator_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../quran_db_class/quran_db_class.dart';
import '../quran_db_class/quran_indopak_script_class.dart';
import 'change_language_settings.dart';

class LanguageTranslationSettings extends StatefulWidget {
  final cmh;
  final cmw;

  const LanguageTranslationSettings(
      {Key? key, required this.cmw, required this.cmh})
      : super(key: key);

  @override
  _LanguageTranslationSettingsState createState() =>
      _LanguageTranslationSettingsState();
}

class _LanguageTranslationSettingsState
    extends State<LanguageTranslationSettings> {
  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var dataProvider = Provider.of<Data>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.all(widget.cmh * 0.021),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ///settings dynamic language Name

          Text(
            '${settingsProvider.selectedLanguage.toString()}  (translation)',
            style: GoogleFonts.roboto(
                color: themeProvider.settingsItemTitleFontColor,
                fontWeight: FontWeight.bold,
                fontSize: widget.cmh * 0.020),
          ),
          SizedBox(
            height: widget.cmh * 0.025,
          ),

          ///show language translation switch
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: themeProvider.settingsBoxShadowColor,
                  blurRadius: 10,
                  spreadRadius: -3)
            ]),
            child: customTextButton(
              cmw: widget.cmw ,cmh: widget.cmh , themeProvider: themeProvider,
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: widget.cmw * 0.02),
                    child: Text(
                      'Show ${settingsProvider.selectedLanguage}',
                      style: GoogleFonts.roboto(
                          fontSize: widget.cmh * 0.022,
                          color: themeProvider.settingsItemFontColor,
                          textBaseline: TextBaseline.alphabetic),
                    ),
                  ),
                  SizedBox(
                    height: widget.cmh * 0.003,
                  ),

                  ///switch is here
                  Switch(
                    inactiveTrackColor:
                        themeProvider.settingsSwitchInactiveTrackColor,
                    activeColor: const Color(0xff223C63),
                    value: settingsProvider.showTranslation,
                    onChanged: (value) {
                      setState(() {
                        /*
                        * saving the selected value permanently here start **this func is dynamic applicable for arabic /translation/transliteration
                        */

                        settingsProvider.showTextStoring(
                            whatToSave: value.toString(),
                            fileToSaveIn: 'showLanguageText');

                        ///func ended****************************

                        /// saving the selected value permanently here END
                        settingsProvider.showTranslationFunc(value: value);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(),

          Container(
            height: 5.9.h,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: themeProvider.settingsBoxShadowColor,
                  blurRadius: 10,
                  spreadRadius: -3)
            ]),

            /// translation font size settings
            child: customTextButton(
              cmw: widget.cmw ,cmh: widget.cmh , themeProvider: themeProvider,
              onPressed: () {
                translationFontChanger(
                    context, themeProvider, settingsProvider, dataProvider);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: widget.cmw * 0.02),
                    child: Text(
                      '${settingsProvider.selectedLanguage} Font Size',
                      style: GoogleFonts.roboto(
                          fontSize: widget.cmh * 0.022,
                          color: themeProvider.settingsItemFontColor,
                          textBaseline: TextBaseline.alphabetic),
                    ),
                  ),
                  SizedBox(
                    height: widget.cmh * 0.003,
                  ),
                  Container(
                    padding: EdgeInsets.all(widget.cmh * 0.009),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.cmh * 0.015),
                        border: Border.all(color: Colors.blueGrey)),
                    child: Text(
                      '${settingsProvider.translationFontSize.round()} px',
                      style: GoogleFonts.roboto(
                          fontSize: widget.cmh * 0.0185,
                          // fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (settingsProvider.selectedLanguage.toString().toLowerCase() == 'english' ||
              settingsProvider.selectedLanguage.toString().toLowerCase() ==
                  'arabic' ||
              settingsProvider.selectedLanguage.toString().toLowerCase() ==
                  'russian' ||
              settingsProvider.selectedLanguage.toString().toLowerCase() ==
                  'urdu' ||
              settingsProvider.selectedLanguage.toString().toLowerCase() ==
                  'bengali')
            const Divider(),

          ///change TAFSIR option starts here*******************************
          ///specifying that tafsir option should show only for mentioned languages cause they are not available for the rest of the languages
          if (settingsProvider.selectedLanguage.toString().toLowerCase() == 'english' ||
              settingsProvider.selectedLanguage.toString().toLowerCase() ==
                  'arabic' ||
              settingsProvider.selectedLanguage.toString().toLowerCase() ==
                  'russian' ||
              settingsProvider.selectedLanguage.toString().toLowerCase() ==
                  'urdu' ||
              settingsProvider.selectedLanguage.toString().toLowerCase() ==
                  'bengali')
            Container(
              height: 5.9.h,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: themeProvider.settingsBoxShadowColor,
                    blurRadius: 10,
                    spreadRadius: -3)
              ]),

              ///
              child: customTextButton(
                cmw: widget.cmw ,cmh: widget.cmh , themeProvider: themeProvider,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectTafsirScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: widget.cmw * 0.02),
                        child: Text(
                          'Tafsir',
                          style: GoogleFonts.roboto(
                              fontSize: widget.cmh * 0.022,
                              color: themeProvider.settingsItemFontColor,
                              textBaseline: TextBaseline.alphabetic),
                        ),
                      ),
                    ),

                    /// choose tafsir settings option here
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(widget.cmh * 0.009),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(widget.cmh * 0.015),
                            border: Border.all(color: Colors.blueGrey)),

                        ///displaying tafsir name here
                        child: Text(
                          settingsProvider.selectedTafsirName.toString(),
                          style: GoogleFonts.roboto(
                              fontSize: 11.sp, color: Colors.blueGrey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ///translator option starts from here
          const Divider(),
          Container(
            height: 5.9.h,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: themeProvider.settingsBoxShadowColor,
                  blurRadius: 10,
                  spreadRadius: -3)
            ]),
            child: customTextButton(
              cmw: widget.cmw ,cmh: widget.cmh , themeProvider: themeProvider,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectTranslator(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: widget.cmw * 0.02),
                      child: Text(
                        'Translator',
                        style: GoogleFonts.roboto(
                            fontSize: widget.cmh * 0.022,
                            color: themeProvider.settingsItemFontColor,
                            textBaseline: TextBaseline.alphabetic),
                      ),
                    ),
                  ),

                  /// choose translator settings option here
                  Expanded(
                    child: Container(
                      height: 5.9.h,
                      padding: EdgeInsets.all(widget.cmh * 0.009),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(widget.cmh * 0.015),
                          border: Border.all(color: Colors.blueGrey)),

                      ///displaying translator name here
                      child: Text(
                        settingsProvider.selectedTranslatorName.toString(),
                        style: GoogleFonts.roboto(
                            fontSize: 11.sp, color: Colors.blueGrey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(),

          ///change language translation
          Container(
            height: 7.5.h,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: themeProvider.settingsBoxShadowColor,
                  blurRadius: 10,
                  spreadRadius: -3)
            ]),
            child: customTextButton(
              cmw: widget.cmw ,cmh: widget.cmh , themeProvider: themeProvider,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangeLanguageSettings(),
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: widget.cmw * 0.02,
                      ),
                      child: Text(
                        'Change Language',
                        style: GoogleFonts.roboto(
                            color: themeProvider.settingsItemFontColor,
                            fontSize: widget.cmh * 0.022,
                            textBaseline: TextBaseline.alphabetic),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: widget.cmh * 0.003,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(widget.cmh * 0.013),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(widget.cmh * 0.015),
                          border: Border.all(color: Colors.blueGrey)),

                      ///displaying language name here
                      child: Text(
                        settingsProvider.selectedLanguage.toString(),
                        style: GoogleFonts.roboto(
                            fontSize: 11.sp,
                            // fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Future<dynamic> translationFontChanger(
      BuildContext context,
      ThemeProvider themeProvider,
      SettingsProvider settingsProvider,
      Data dataProvider) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SizedBox(
          height: widget.cmh * 0.75,
          child: Container(
            color: themeProvider.settingsFontSizeChangeModalColor,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: widget.cmh * 0.015),
                  child: Text(
                    '${settingsProvider.selectedLanguage} Font Size',
                    style: TextStyle(
                      fontSize: widget.cmh * 0.022,
                    ),
                  ),
                ),
                const Divider(),

                ///
                ///
                ///
                ///
                ///
                Expanded(
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Padding(
                            padding: EdgeInsets.only(right: widget.cmw * 0.03),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  /// surah arabic verses shown here
                                  TextSpan(
                                    text: settingsProvider.selectedArabicType !=
                                            'Indo - Pak'
                                        ? QuranDb()
                                            .fullQuran[0]['text']
                                            .toString()
                                        : Quran_indo_pak_script_DB()
                                            .quran_indo_pak_script[0]['text']
                                            .toString(),
                                    style: TextStyle(
                                      fontSize:
                                          // widget.cmh * 0.045,
                                          settingsProvider.selectedArabicType ==
                                                  'Indo - Pak'
                                              ? settingsProvider
                                                      .arabicFontSize.sp -
                                                  3
                                              : settingsProvider
                                                      .arabicFontSize.sp -
                                                  5,
                                      fontFamily:
                                          settingsProvider.selectedArabicType ==
                                                  'Indo - Pak'
                                              ? settingsProvider.indoPakScriptFont
                                              : settingsProvider.uthmaniScriptFont,

                                    ),
                                  ),

                                  ///arabic verse end symbol with number shown here
                                  // TextSpan(
                                  //   text: dataProvider.getVerseEndSymbol(1),
                                  //   style: GoogleFonts.robotoMono(
                                  //     fontSize: 13.sp,
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: widget.cmh * 0.015,
                        ),

                        /// surah translation shown here

                        Padding(
                          padding: EdgeInsets.only(
                              left: widget.cmw * 0.05,
                              right: widget.cmw * 0.05),
                          child: FutureBuilder(
                            initialData: '...',
                            future: services.rootBundle
                                .loadString(
                                    'db/translations/${dataProvider.translationName}.json')
                                .then((jsonData) =>
                                    jsonDecode(jsonData)[0]['text']),
                            builder: (context, snapshot) => Text(
                              snapshot.data.toString(),
                              // 'In the name of Allah, the Entirely Merciful, the Especially Merciful',
                              style: settingsProvider
                                  .changeTranslationTxtStyleAccordingToLanguage(
                                      widget: widget, context: context),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: widget.cmh * 0.021,
                        ),
                      ],
                    ),
                  ),
                ),

                ///
                ///
                ///
                ///
                ///
                ///
                Text(
                  'Slide to change Font Size',
                  style: GoogleFonts.openSans(
                      fontSize: widget.cmh * 0.0175,
                      fontWeight: FontWeight.bold),
                ),

                ///slider is here******************************************
                Slider(
                  // divisions: 5,
                  activeColor: const Color(0xff223C63),

                  label:
                      settingsProvider.translationFontSize.round().toString(),
                  divisions: 22,

                  max: 22,
                  min: 10,
                  value: settingsProvider.translationFontSize,
                  onChanged: (value) {
                    print(value);

                    setState(() {
                      settingsProvider.translationFontSizeFunc(value: value);

                      FontSizeFileStorage().writeFile(
                          whatToSave: value.toString(),
                          fileNameToSaveIn: 'languageFontSize');
                    });
                  },
                ),

                ///reset translation size to default ************
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueGrey.withOpacity(.7),
                  ),
                  onPressed: () {
                    setState(() {
                      settingsProvider.translationFontSizeFunc(value: 15.0);


                    });
                  },
                  child: Text(
                    'Reset to Default',
                    style: GoogleFonts.lato(
                        fontSize: widget.cmh * 0.017,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  /// custom Text Widget widget
  Widget customTextButton(
      {required onPressed,
        required Widget child,
        required double cmh,
        required double cmw , required ThemeProvider themeProvider}) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.cmh * 0.019),
        ),
        backgroundColor: themeProvider.settingsItemContainerColor,
        padding: EdgeInsets.all(widget.cmh * 0.009),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
