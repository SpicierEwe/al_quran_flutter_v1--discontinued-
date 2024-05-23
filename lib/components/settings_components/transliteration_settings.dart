import 'dart:convert';

import 'package:al_quran/providers/settings_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import "package:flutter/services.dart" as services;
import '../../providers/data_provider.dart';
import '../../providers/theme_provider.dart';
import '../make_values_permanet_class/make_font_sizes_permanent_class.dart';

class TransliterationSettings extends StatefulWidget {
  final cmh;
  final cmw;

  const TransliterationSettings(
      {Key? key, required this.cmw, required this.cmh})
      : super(key: key);

  @override
  _TransliterationSettingsState createState() =>
      _TransliterationSettingsState();
}

class _TransliterationSettingsState extends State<TransliterationSettings> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    Data dataProvider = Provider.of<Data>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.all(widget.cmh * 0.021),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ///settings arabic
          Text(
            'Transliteration',
            style: GoogleFonts.roboto(
                color: themeProvider.settingsItemTitleFontColor,
                fontWeight: FontWeight.bold,
                fontSize: widget.cmh * 0.020),
          ),
          SizedBox(
            height: widget.cmh * 0.025,
          ),
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: themeProvider.settingsBoxShadowColor,
                  blurRadius: 10,
                  spreadRadius: -3)
            ]),

            /// transliteration switch
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
                      'Show Transliteration',
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
                    activeColor: const Color(0xff223C63),
                    value: settingsProvider.showTransliteration,
                    inactiveTrackColor: Colors.grey,
                    onChanged: (value) {
                      /// updating the current ui
                      settingsProvider.showTransliterationFunc(value: value);

                      /// saving the value here
                      settingsProvider.showTextStoring(
                          whatToSave: value.toString(),
                          fileToSaveIn: 'showTransliteration');

                      ///func ended****************************

                      /// saving the selected value permanently here END
                    },
                  ),
                ],
              ),
            ),
          ),

          const Divider(),

          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: themeProvider.settingsBoxShadowColor,
                  blurRadius: 10,
                  spreadRadius: -3)
            ]),

            /// transliteration font size
            child: customTextButton(
              cmw: widget.cmw,
              cmh: widget.cmh,
              themeProvider: themeProvider,
              onPressed: () async {
                transliterationFontChanger(
                    context, themeProvider, settingsProvider, dataProvider);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: widget.cmw * 0.02),
                    child: Text(
                      'Transliteration Font Size',
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
                      '${settingsProvider.transliterationFontSize.toInt()} px',
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

          /// transliteration Settings
        ],
      ),
    );
  }

  ///
  ///
  /// custom widgets
  ///
  ///
  Future<dynamic> transliterationFontChanger(
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
                    'Transliteration Font Size',
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
                        Padding(
                          padding: EdgeInsets.only(
                            top: widget.cmh * 0.015,
                            right: widget.cmw * 0.03,
                            left: widget.cmw * 0.05,
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                /// surah arabic verses shown here

                                TextSpan(
                                  text: "Bismil laahir Rahmaanir Raheem",
                                  style: GoogleFonts.roboto(
                                    fontSize:
                                        // widget.cmh * 0.045,
                                        settingsProvider
                                            .transliterationFontSize.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                ///arabic verse end symbol with number shown here
                                // TextSpan(
                                //   text: dataProvider.getVerseEndSymbol(1),
                                //   style: GoogleFonts.robotoMono(
                                //     fontSize: 13.sp,
                                //   ),
                                // ),
                              ],
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

                  label: settingsProvider.transliterationFontSize
                      .round()
                      .toString(),
                  divisions: 21,

                  max: 21,
                  min: 10,
                  value: settingsProvider.transliterationFontSize,
                  onChanged: (value) {
                    // print(value);

                    setState(() {
                      settingsProvider.transliterationFontSizeFunc(
                          value: value);
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


                      /// this functions and saved too

                      settingsProvider.transliterationFontSizeFunc(value: 11.0);
                    });
                  },
                  child: Text(
                    'Reset to Default',
                    style: GoogleFonts.lato(
                        fontSize: 11.0,
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
