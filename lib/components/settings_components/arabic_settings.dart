import 'dart:convert';
import 'package:al_quran/providers/juz_provider.dart';
import 'package:flutter/services.dart' as services;

import 'package:al_quran/Navigators/change_reciter_navigator.dart';
import 'package:al_quran/components/make_values_permanet_class/make_arabic_type_permanent_class.dart';
import 'package:al_quran/components/make_values_permanet_class/make_font_sizes_permanent_class.dart';
import 'package:al_quran/components/make_values_permanet_class/make_reciter_permanent.dart';
import 'package:al_quran/components/quran_db_class/quran_indopak_script_class.dart';
import 'package:al_quran/providers/audio_provider.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/favourites_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../quran_db_class/quran_db_class.dart';

class ArabicSettings extends StatefulWidget {
  final cmh;
  final cmw;

  const ArabicSettings({Key? key, required this.cmw, required this.cmh})
      : super(key: key);

  @override
  _ArabicSettingsState createState() => _ArabicSettingsState();
}

class _ArabicSettingsState extends State<ArabicSettings> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _value = int.parse(Provider.of<AudioProvider>(context, listen: false)
      //     .recitationStyleValue);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var audioProvider = Provider.of<AudioProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    var favouritesProvider = Provider.of<FavouritesProvider>(context);
    var dataProvider = Provider.of<Data>(context);
    JuzProvider juzProvider = Provider.of<JuzProvider>(context);

    return Padding(
      padding: EdgeInsets.all(widget.cmh * 0.021),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ///settings arabic
          Text(
            'Arabic',
            style: GoogleFonts.roboto(
                // color: const Color(0xff223C63),
                color: themeProvider.settingsItemTitleFontColor,
                fontWeight: FontWeight.bold,
                fontSize: widget.cmh * 0.020),
          ),
          SizedBox(
            height: widget.cmh * 0.025,
          ),

          ///show arabic switch
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: themeProvider.settingsBoxShadowColor,
                  blurRadius: 10,
                  spreadRadius: -3)
            ]),
            child: customTextButton(
              cmw: widget.cmw,
              cmh: widget.cmh,
              themeProvider: themeProvider,
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: widget.cmw * 0.02),
                    child: Text(
                      'Show Arabic',
                      style: GoogleFonts.roboto(
                          color: themeProvider.settingsItemFontColor,
                          fontSize: widget.cmh * 0.022,
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
                    value: settingsProvider.showArabic,
                    onChanged: (value) {
                      setState(() {
                        /// saving the selected value permanently here start **this func is dynamic applicable for arabic /translation/transliteration
                        settingsProvider.showTextStoring(
                            whatToSave: value.toString(),
                            fileToSaveIn: 'showArabicText');

                        ///func ended****************************

                        /// saving the selected value permanently here END
                        settingsProvider.showArabicFunc(value: value);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(),

          ///change arabic type
          Container(
            height: 5.9.h,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: themeProvider.settingsBoxShadowColor,
                  blurRadius: 10,
                  spreadRadius: -3)
            ]),

            /// arabic type
            child: customTextButton(
              cmw: widget.cmw,
              cmh: widget.cmh,
              themeProvider: themeProvider,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(widget.cmw * 0.05),
                              color: themeProvider
                                  .arabicChangeRecitationStylePopUpContainerColor,
                            ),
                            padding: EdgeInsets.all(widget.cmh * 0.07),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blueGrey.withOpacity(.7)),
                                    borderRadius: BorderRadius.circular(
                                        widget.cmh * 0.01),
                                    boxShadow: [
                                      BoxShadow(
                                          color: themeProvider
                                              .settingsBoxShadowColor,
                                          blurRadius: 21,
                                          spreadRadius: -15)
                                    ],
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: widget.cmw * 0.035),
                                        foregroundColor: Colors.black,
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Colors.black),
                                            borderRadius: BorderRadius.circular(
                                                widget.cmh * 0.01))),
                                    // color: Colors.white,
                                    // shape: RoundedRectangleBorder(
                                    //     side: const BorderSide(
                                    //         color: Colors.black),
                                    //     borderRadius: BorderRadius.circular(
                                    //         widget.cmh * 0.01)),
                                    onPressed: () async {
                                      settingsProvider.changeArabicType(
                                          arabicType: 'Uthmani');
                                      ArabicTypeStorage().writeFile(
                                          whatToSave: 'Uthmani',
                                          fileNameToSaveIn: 'arabic_type');

                                      ///fetch selected arabic type for favourites screen
                                      favouritesProvider
                                          .fetchSelectedArabicType();

                                      ///fetching selected quranic script after user has selected the required script
                                      settingsProvider
                                          .fetchQuranScriptForOpenedSurah(
                                              context: context);

                                      ///
                                      /// re=fetch the juz

                                      juzProvider.juzFilter(
                                          arabicScriptType: settingsProvider
                                              .selectedArabicType);

                                      ///
                                      ///testing**********************************************
                                      favouritesProvider
                                          .fetchFavouritesQuranVerse();

                                      ///
                                      /// re-fetching rabbana duas
                                      dataProvider.rabbanaDuaQuranVerseFetch();

                                      ///
                                      ///
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      ///arabic type option ~  uthmani
                                      child: Text(
                                        'Uthmani',
                                        style: TextStyle(
                                            fontSize: widget.cmh * 0.027),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: widget.cmh * 0.015,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blueGrey.withOpacity(.7)),
                                    borderRadius: BorderRadius.circular(
                                        widget.cmh * 0.01),
                                    boxShadow: [
                                      BoxShadow(
                                          color: themeProvider
                                              .settingsBoxShadowColor,
                                          blurRadius: 21,
                                          spreadRadius: -15)
                                    ],
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: widget.cmw * 0.035),
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Colors.black),
                                            borderRadius: BorderRadius.circular(
                                                widget.cmh * 0.01))),
                                    onPressed: () async {
                                      settingsProvider.changeArabicType(
                                          arabicType: 'Indo - Pak');
                                      ArabicTypeStorage().writeFile(
                                          whatToSave: 'Indo - Pak',
                                          fileNameToSaveIn: 'arabic_type');

                                      ///fetching selected quranic script after user has selected the required script
                                      settingsProvider
                                          .fetchQuranScriptForOpenedSurah(
                                              context: context);

                                      /// re-fetch the juz
                                      juzProvider.juzFilter(
                                          arabicScriptType: settingsProvider
                                              .selectedArabicType);

                                      ///testing**********************************************
                                      favouritesProvider
                                          .fetchFavouritesQuranVerse();

                                      ///
                                      /// re-fetching rabbana duas
                                      dataProvider.rabbanaDuaQuranVerseFetch();

                                      ///
                                      ///
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(widget.cmw * 0.02),

                                      ///arabic type option ~ indo - pak
                                      child: Text(
                                        'Indo - Pak',
                                        style: TextStyle(
                                            fontSize: widget.cmh * 0.025),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: widget.cmw * 0.02),
                    child: Text(
                      'Arabic Type',
                      style: GoogleFonts.roboto(
                          color: themeProvider.settingsItemFontColor,
                          fontSize: widget.cmh * 0.022,
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

                    ///here  is the name of the selected arabic type
                    child: Text(
                      settingsProvider.selectedArabicType,
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
          const Divider(),
          Container(
            height: 5.9.h,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: themeProvider.settingsBoxShadowColor,
                  blurRadius: 10,
                  spreadRadius: -3)
            ]),

            /// arabic font size settings*****************************************************
            child: customTextButton(
              cmw: widget.cmw,
              cmh: widget.cmh,
              themeProvider: themeProvider,
              onPressed: () {
                arabicFontChanger(
                    context, themeProvider, settingsProvider, dataProvider);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: widget.cmw * 0.02),
                    child: Text(
                      'Arabic Font Size',
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
                      border: Border.all(color: Colors.blueGrey),
                    ),
                    child: Text(
                      '${settingsProvider.arabicFontSize.round()} px',
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

          const Divider(),

          /// change reciter here
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: themeProvider.settingsBoxShadowColor,
                    blurRadius: 10,
                    spreadRadius: -3)
              ],
            ),
            child: customTextButton(
              cmw: widget.cmw,
              cmh: widget.cmh,
              themeProvider: themeProvider,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangeReciterNavigator(),
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
                        'Change Reciter',
                        style: GoogleFonts.roboto(
                            fontSize: widget.cmh * 0.022,
                            color: themeProvider.settingsItemFontColor,
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

                      ///displaying reciter name here
                      child: Text(
                        Provider.of<AudioProvider>(context).reciterFullName,
                        style: GoogleFonts.roboto(
                          fontSize: 11.sp,
                          // fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),

          /// change recitationStyle here Start**********************
          ///
          if (audioProvider.reciterShortName == 'AbdulBaset' ||
              audioProvider.reciterShortName == 'Husary' ||
              audioProvider.reciterShortName == 'Minshawy')
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: themeProvider.settingsBoxShadowColor,
                    blurRadius: 10,
                    spreadRadius: -3)
              ]),
              child: customTextButton(
                cmw: widget.cmw,
                cmh: widget.cmh,
                themeProvider: themeProvider,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Container(
                      margin: EdgeInsets.only(
                        top: widget.cmh * 0.41,
                        bottom: widget.cmh * 0.41,
                        left: widget.cmh * 0.1,
                        right: widget.cmh * 0.1,
                      ),
                      decoration: BoxDecoration(
                        color: themeProvider
                            .arabicChangeRecitationStylePopUpContainerColor,
                        borderRadius: BorderRadius.circular(widget.cmh * 0.01),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              boxShadow: [
                                BoxShadow(
                                    color: themeProvider.settingsBoxShadowColor,
                                    blurRadius: 15,
                                    spreadRadius: -19)
                              ],
                              borderRadius:
                                  BorderRadius.circular(widget.cmh * 0.01),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: widget.cmw * 0.035),
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      side:
                                          const BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(
                                          widget.cmh * 0.01))),
                              child: Text(
                                'Murattal',
                                style: GoogleFonts.roboto(
                                  fontSize: widget.cmh * 0.029,
                                  // color: Color(0xffF9F5FF).withOpacity(.89),
                                  // color: Colors.white70
                                ),
                              ),
                              onPressed: () {
                                ReciterFileStorage().writeRecitationStyle(
                                    fileNameToSaveIn: 'recitationStyle',
                                    whatToSave: 'Murattal');

                                audioProvider.assignRecitationStyle(
                                    style: 'Murattal');

                                audioProvider.switchToSelectedRecitationStyle(
                                    context: context);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(
                            height: widget.cmh * 0.021,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.circular(widget.cmh * 0.01),
                              boxShadow: [
                                BoxShadow(
                                    color: themeProvider.settingsBoxShadowColor,
                                    blurRadius: 15,
                                    spreadRadius: -19)
                              ],
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: widget.cmw * 0.035),
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      side:
                                          const BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(
                                          widget.cmh * 0.01))),
                              child: Text(
                                'Mujawwad',
                                style: GoogleFonts.roboto(
                                  fontSize: widget.cmh * 0.029,
                                ),
                              ),
                              onPressed: () {
                                ReciterFileStorage().writeRecitationStyle(
                                    fileNameToSaveIn: 'recitationStyle',
                                    whatToSave: 'Mujawwad');

                                audioProvider.assignRecitationStyle(
                                    style: 'Mujawwad');
                                audioProvider.switchToSelectedRecitationStyle(
                                    context: context);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
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
                          'Recitation Style',
                          style: GoogleFonts.roboto(
                              fontSize: widget.cmh * 0.022,
                              color: themeProvider.arabicFontColor,
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

                        ///displaying recitation Style  here
                        child: Text(
                          audioProvider.recitationStyle,
                          style: GoogleFonts.roboto(
                              fontSize: widget.cmh * 0.0185,
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
          if (audioProvider.reciterShortName == 'AbdulBaset' ||
              audioProvider.reciterShortName == 'Husary')
            const Divider(),

          /// change recitationStyle here END******************************
        ],
      ),
    );
  }

  Future<dynamic> arabicFontChanger(
      BuildContext context,
      ThemeProvider themeProvider,
      SettingsProvider settingsProvider,
      Data dataProvider) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          color: themeProvider.settingsFontSizeChangeModalColor,
          child: SizedBox(
            height: widget.cmh * 0.75,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: widget.cmh * 0.015),
                  child: Text(
                    'Arabic Font Size',
                    style: GoogleFonts.roboto(
                        fontSize: widget.cmh * 0.022,
                        textBaseline: TextBaseline.alphabetic),
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
                    // height: widget.cmh * 0.3,
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
                                      text: settingsProvider
                                                  .selectedArabicType !=
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
                                        fontFamily: settingsProvider
                                                    .selectedArabicType ==
                                                'Indo - Pak'
                                            ? settingsProvider.indoPakScriptFont
                                            : settingsProvider
                                                .uthmaniScriptFont,
                                      )),

                                  // ///arabic verse end symbol with number shown here
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

                ///slider is here******************************************
                Text(
                  'Slide to change Font Size',
                  style: GoogleFonts.openSans(
                      fontSize: widget.cmh * 0.0175,
                      fontWeight: FontWeight.bold),
                ),
                Slider(
                  // divisions: 5,
                  activeColor: const Color(0xff223C63),

                  label: settingsProvider.arabicFontSize.round().toString(),
                  divisions: 39,

                  max: 39,
                  min: 10,
                  value: settingsProvider.arabicFontSize,
                  onChanged: (value) {
                    print(value);

                    setState(() {

                    settingsProvider.arabicFontSizeFunc(value:value);
                    });
                  },
                ),

                ///reset font size to default function here***********
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blueGrey.withOpacity(.7),
                  ),
                  onPressed: () {
                    setState(() {
                      settingsProvider.arabicFontSizeFunc(value: 24.0);

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
      required double cmw,
      required ThemeProvider themeProvider}) {
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
