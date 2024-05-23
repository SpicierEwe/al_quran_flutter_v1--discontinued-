import 'dart:async';


import 'package:al_quran/components/quran_db_class/quran_db_class.dart';
import 'package:al_quran/components/subString_highlight.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/speech_to_text_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:al_quran/screens/search_screens/single_verse_display_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../Navigators/navigator_controller_surah_display_screen.dart';
import '../../providers/audio_provider.dart';
import '../../providers/data_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController textEditingController;
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  var query = '';

  @override
  void initState() {
    _initSpeech();
    super.initState();
    textEditingController = TextEditingController();
    Provider.of<SpeechToTextProvider>(context, listen: false)
        .textEditingController = textEditingController;
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var audioProvider = Provider.of<AudioProvider>(context, listen: true);
    SpeechToTextProvider speechToTextProvider =
        Provider.of<SpeechToTextProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    Data dataProvider = Provider.of<Data>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        speechToTextProvider.clearSearchInputField(formKey: _formKey);
        Navigator.of(context).pop(true);

        return true;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: themeProvider.scaffoldBackgroundColor,
          body: LayoutBuilder(
            builder: (context, constraints) {
              var cmh = constraints.maxHeight;
              var cmw = constraints.maxWidth;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: themeProvider.darkTheme == true
                              ? themeProvider.settingsScaffoldBackgroundColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(cmh * 0.02),
                            bottomLeft: Radius.circular(cmh * 0.02),
                          )),
                      child: Column(
                        children: [
                          SizedBox(
                            height: cmh * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Form(
                                key: _formKey,
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: cmw * 0.85,
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                            splashColor: Colors.transparent),
                                        child: TextFormField(
                                          ///todo
                                          onChanged: (value) async {
                                            if (value.isEmpty) {
                                              speechToTextProvider
                                                  .clearSearchInputField(
                                                      formKey: _formKey);
                                            }

                                            ///todo
                                            speechToTextProvider
                                                .assignTranslationName(
                                                    setTranslationName:
                                                        dataProvider
                                                            .translationName);

                                            setState(() {
                                              query = value;
                                            });

                                            speechToTextProvider
                                                .getInputTextWords(
                                                    inputSearchText: value);

                                            speechToTextProvider.searchQuery(
                                                query: value);
                                          },

                                          controller: textEditingController,
                                          autofocus: true,
                                          style: TextStyle(
                                              fontSize: cmh * 0.021,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: cmh * 0.025,
                                                right: cmh * 0.055),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText:
                                                'ex: surah 2 verse 15 or 2:15',
                                            hintStyle: GoogleFonts.roboto(
                                                fontSize: cmh * 0.0185,
                                                color: Colors.grey.shade500),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            alignLabelWithHint: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(cmh),
                                              borderSide: BorderSide(
                                                style: BorderStyle.solid,
                                                color: Colors.blueGrey
                                                    .withOpacity(.55),
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(cmh)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //todo
                                    if (speechToTextProvider
                                        .searchText.isNotEmpty)
                                      GestureDetector(
                                        onTap: () {
                                          speechToTextProvider
                                              .clearSearchInputField(
                                                  formKey: _formKey);
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                left: cmw * 0.75,
                                                top: cmh * 0.0125),
                                            child: const Icon(Icons.cancel)),
                                      )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap:
                                    // If not yet listening for speech start, otherwise stop
                                    _speechToText.isNotListening
                                        ? speechToTextProvider.startListening
                                        : speechToTextProvider.stopListening,
                                child: Icon(
                                  _speechToText.isNotListening
                                      ? Icons.mic_off
                                      : Icons.mic,
                                  color: _speechToText.isNotListening
                                      ? themeProvider.speakerColor
                                      : Colors.green,
                                  size: cmh * 0.031,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(cmh * 0.017),
                            child: Column(
                              children: [
                                if (query.isEmpty ||
                                    speechToTextProvider.searchText == '')
                                  Text(
                                    '"Search the entire Qur\'an"',
                                    style: GoogleFonts.roboto(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold),
                                  ),
                                if (speechToTextProvider
                                        .quranSearchResults.isEmpty &&
                                    speechToTextProvider
                                        .translationSearchResults.isEmpty &&
                                    speechToTextProvider.searchText != '')
                                  Text(
                                    '"Not Found"',
                                    style: GoogleFonts.roboto(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                if (speechToTextProvider
                                        .quranSearchResults.isNotEmpty ||
                                    speechToTextProvider
                                            .translationSearchResults
                                            .isNotEmpty &&
                                        query.isNotEmpty &&
                                        query != ' ')
                                  Column(
                                    children: [
                                      const Text('Search Results :'),
                                      Text.rich(
                                        TextSpan(
                                            children: [
                                              const TextSpan(text: 'found '),
                                              TextSpan(
                                                  text: speechToTextProvider
                                                          .quranSearchResults
                                                          .isEmpty
                                                      ? speechToTextProvider
                                                          .translationSearchResults
                                                          .length
                                                          .toString()
                                                      : speechToTextProvider
                                                          .quranSearchResults
                                                          .length
                                                          .toString(),
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.teal,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const TextSpan(
                                                text: ' verses matching your',
                                              ),
                                              TextSpan(
                                                  text: ' Query',
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.teal)),
                                            ],
                                            style: GoogleFonts.roboto(
                                                color: Colors.grey.shade600)),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (speechToTextProvider.quranSearchResults.isNotEmpty &&
                        query.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                            itemCount:
                                speechToTextProvider.quranSearchResults.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  if (index == 0) SizedBox(height: cmh * 0.02),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: cmw * 0.015, right: cmw * 0.015),
                                    child: TextButton(


                                      // shape: RoundedRectangleBorder(
                                      //   borderRadius:
                                      //       BorderRadius.circular(cmh * 0.015),
                                      // ),
                                      // minWidth: 0,
                                      // padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                SingleVerseDisplayScreen(
                                              cmh: cmh,
                                              surahNumber: speechToTextProvider
                                                  .translationSearchResults[
                                                      index]['sura']
                                                  .toString(),
                                              verseNumber: speechToTextProvider
                                                      .translationSearchResults[
                                                  index]['aya'],
                                              translationText:
                                                  speechToTextProvider
                                                      .translationSearchResults[
                                                          index]['text']
                                                      .toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: cmw * 0.025,
                                          right: cmw * 0.025,
                                          top: cmw * 0.025,
                                          bottom: cmw * 0.025,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white54,
                                          borderRadius: BorderRadius.circular(
                                              cmh * 0.015),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            SubstringHighlight(
                                              text: 'surah number = ${speechToTextProvider
                                                      .quranSearchResults[index]
                                                          ['sura']}',
                                              terms: [query],
                                            ),
                                            SubstringHighlight(
                                              text: 'verse number = ${speechToTextProvider
                                                      .quranSearchResults[index]
                                                          ['aya']}',
                                              terms: [query],
                                            ),
                                            SubstringHighlight(
                                              text: 'verse number = ${speechToTextProvider
                                                      .quranSearchResults[index]
                                                          ['text']}',
                                              terms: [query],
                                            ),
                                            SubstringHighlight(
                                              text: 'translation = ${speechToTextProvider
                                                      .translationSearchResults[
                                                          index]['text']}',
                                              terms: [query],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              );
                            }),
                      ),

                    ///here is the Listview.builder which is responsible to display thr random query results
                    if (speechToTextProvider.quranSearchResults.isEmpty &&
                        query.isNotEmpty &&
                        query != ' ')
                      Expanded(
                        child: ListView.builder(
                            itemCount: speechToTextProvider
                                .translationSearchResults.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  if (index == 0) SizedBox(height: cmh * 0.02),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: cmw * 0.015, right: cmw * 0.015),
                                    child: TextButton(
                                      style:TextButton.styleFrom(primary: Colors.black),


                                      // shape: RoundedRectangleBorder(
                                      //   borderRadius:
                                      //       BorderRadius.circular(cmh * 0.015),
                                      // ),
                                      // minWidth: 0,
                                      // padding: EdgeInsets.zero,


                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                SingleVerseDisplayScreen(
                                              cmh: cmh,
                                              surahNumber: speechToTextProvider
                                                  .translationSearchResults[
                                                      index]['sura']
                                                  .toString(),
                                              verseNumber: speechToTextProvider
                                                      .translationSearchResults[
                                                  index]['aya'],
                                              translationText:
                                                  speechToTextProvider
                                                      .translationSearchResults[
                                                          index]['text']
                                                      .toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: cmw * 0.025,
                                          right: cmw * 0.025,
                                          top: cmw * 0.025,
                                          bottom: cmw * 0.025,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              cmh * 0.015),
                                          color: Colors.white54,
                                        ),
                                        child: Column(
                                          children: [
                                            FutureBuilder(
                                                future: speechToTextProvider.aa(
                                                    surah: speechToTextProvider
                                                            .translationSearchResults[
                                                        index]['sura'],
                                                    verse: speechToTextProvider
                                                            .translationSearchResults[
                                                        index]['aya']),
                                                builder: (context,
                                                    AsyncSnapshot snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return const Text('...');
                                                  }

                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Text('surah number = ${snapshot.data[0]
                                                                  ['sura']}'),
                                                      Text('verse number = ${snapshot.data[0]
                                                                  ['aya']}' ,),
                                                      Text('verse = ${snapshot.data[0]
                                                                  ['text']}', style: TextStyle(fontFamily: settingsProvider.selectedArabicType ==
                                                          'Indo - Pak'
                                                          ? settingsProvider
                                                          .indoPakScriptFont
                                                          : settingsProvider
                                                          .uthmaniScriptFont,)),
                                                      const Text(
                                                          'translation :'),
                                                    ],
                                                  );
                                                }),
                                            SubstringHighlight(
                                              text: speechToTextProvider
                                                  .translationSearchResults[
                                                      index]['text']
                                                  .toString(),
                                              terms: [query],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              );
                            }),
                      ),

                    ///this will be displayed when query is empty
                    if (query.isEmpty || query == ' ')
                      Expanded(child: Container())
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
