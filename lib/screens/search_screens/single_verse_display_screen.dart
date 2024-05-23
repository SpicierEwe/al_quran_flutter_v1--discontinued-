import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:al_quran/screens/tafsir_display_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/speech_to_text_provider.dart';

class SingleVerseDisplayScreen extends StatefulWidget {
  // final String arabicVerse;
  //
  final String translationText;

  final String surahNumber;

  final int verseNumber;
  final cmh;

  const SingleVerseDisplayScreen({
    Key? key,
    required this.cmh,
    required this.verseNumber,
    required this.surahNumber,
    required this.translationText,
  }) : super(key: key);

  @override
  State<SingleVerseDisplayScreen> createState() =>
      _SingleVerseDisplayScreenState();
}

class _SingleVerseDisplayScreenState extends State<SingleVerseDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    SpeechToTextProvider speechToTextProvider =
        Provider.of<SpeechToTextProvider>(context);
    var scrollController = PrimaryScrollController.of(context);
    var mq = MediaQuery.of(context).size;
    var provider = Provider.of<Data>(context, listen: true);
    var settingsProvider = Provider.of<SettingsProvider>(context, listen: true);

    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return SafeArea(
      child: Scaffold(
        backgroundColor: themeProvider.scaffoldBackgroundColor,
        body: LayoutBuilder(builder: (context, constraints) {
          var cmh = constraints.maxHeight;
          var cmw = constraints.maxWidth;
          return FutureBuilder(
              future: speechToTextProvider.aa(
                surah: widget.surahNumber,
                verse: widget.verseNumber,
              ),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: themeProvider.circularProgressIndicatorColor,
                  ));
                }
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: cmh * 0.021,
                          bottom: cmh * 0.01,
                        ),
                        child: Text(
                          'surah : ${widget.surahNumber} | verse : ${widget.verseNumber}',
                          style: TextStyle(
                            fontSize: cmh * 0.019,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.ayahEnglishNumbersColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              top: cmh * 0.015,
                              bottom: cmh * 0.015,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  ///this container is just for space for number displayed using stack
                                  child: Container(),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: cmh * 0.019),
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                /// surah arabic verses shown here
                                                if (settingsProvider
                                                        .showArabic ==
                                                    true)
                                                  TextSpan(
                                                    text: snapshot.data[0]
                                                            ['text']
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize:
                                                          // cmh * 0.045,
                                                          settingsProvider
                                                                      .selectedArabicType ==
                                                                  'Indo - Pak'
                                                              ? cmh * 0.005 +
                                                                  settingsProvider
                                                                      .arabicFontSize
                                                              : cmh * 0.0 +
                                                                  settingsProvider
                                                                      .arabicFontSize,
                                                      fontFamily:
                                                          settingsProvider
                                                                      .selectedArabicType ==
                                                                  'Indo - Pak'
                                                              ? settingsProvider
                                                                  .indoPakScriptFont
                                                              : settingsProvider
                                                                  .uthmaniScriptFont,
                                                      fontWeight: settingsProvider
                                                                  .selectedArabicType ==
                                                              'Indo - Pak'
                                                          ? FontWeight.w100
                                                          : FontWeight.bold,
                                                      color: themeProvider
                                                          .arabicFontColor,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Text('\u06dd'+ '۲۹'),
                                      SizedBox(
                                        height: cmh * 0.015,
                                      ),

                                      /// surah translation shown here
                                      if (settingsProvider.showTranslation ==
                                          true)
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: cmw * 0.03,
                                            top: cmh * 0.019,
                                          ),
                                          child: Directionality(
                                            textDirection: settingsProvider
                                                .changeDirectionalityAccordingToLanguage(),
                                            child: Text(
                                              widget.translationText,
                                              style: settingsProvider
                                                  .changeTranslationTxtStyleAccordingToLanguage(
                                                context: context,
                                                widget: widget,
                                              ),
                                            ),
                                          ),
                                        ),
                                      SizedBox(
                                        height: cmh * 0.021,
                                      ),

                                      ///sjda shown here
                                      Row(
                                        children: [
                                          provider.showSjda(
                                              themeProvider: themeProvider,
                                              surahNumber: widget.surahNumber,
                                              verseNumber: widget.verseNumber)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ///ayah number is english is displayed here
                          Padding(
                            padding: EdgeInsets.only(
                              left: cmh * 0.0075,
                              top: cmh * 0.015,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: themeProvider
                                          .ayahEnglishNumberBorderColor),
                                  borderRadius: BorderRadius.circular(
                                    cmh * 0.023,
                                  )),
                              child: CircleAvatar(
                                // backgroundColor: Colors.blueGrey.shade50,
                                backgroundColor: Colors.transparent,
                                radius: cmh * 0.02,
                                child: Text(
                                  (widget.verseNumber).toString(),
                                  style: TextStyle(
                                    fontSize: cmh * 0.019,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        themeProvider.ayahEnglishNumbersColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      const Text(
                        '* **  ** *',
                        style: TextStyle(),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DisplayTafsirScreen(
                                    verseNumber: widget.verseNumber.toString(),
                                    surahIndex: int.parse(widget.surahNumber)),
                              ));
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.teal)),
                        child: const Text(
                          'Read Tafsir',
                        ),
                      )
                    ],
                  ),
                );
              });
        }),
      ),
    );
  }
}
