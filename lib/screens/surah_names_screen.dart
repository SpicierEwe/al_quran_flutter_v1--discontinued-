import 'dart:ui';

import 'package:al_quran/Navigators/navigator_controller_surah_display_screen.dart';
import 'package:al_quran/components/quran_meta_data/quran_meta_data.dart';
import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/providers/audio_provider.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SurahNamesScreen extends StatefulWidget {
  final cmh;
  final cmw;

  const SurahNamesScreen({Key? key, required this.cmh, required this.cmw})
      : super(key: key);

  @override
  _SurahNamesScreenState createState() => _SurahNamesScreenState();
}

class _SurahNamesScreenState extends State<SurahNamesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Data>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    AudioProvider audioProvider = Provider.of<AudioProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return ScrollConfiguration(
      behavior: RemoveListViewGlow(),
      child: Scaffold(
        body: ListView.builder(
          padding: EdgeInsets.only(
              top: widget.cmh * 0.003, bottom: widget.cmh * 0.025),
          // index != 114
          //     ? const EdgeInsets.fromLTRB(15, 15, 15, 0)
          itemCount: provider.totalSurahs,
          itemBuilder: (context, originalIndex) {
            final index = settingsProvider.isDescending
                ? (115 - originalIndex)
                : originalIndex;
            return Column(
              children: [
                ///
                if (index != 0 && index != 115

                /// these indexes(0 & 115) are useless empty
                )

                  /// this container has the main decoration
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),

                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: !themeProvider.darkTheme
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.transparent,
                          spreadRadius: -13,
                          blurRadius: 17,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: themeProvider.namesContainerColor,
                      borderRadius: BorderRadius.circular(15),
                    ),

                    ///text button here
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(
                              color: Colors.blueGrey.withOpacity(.25)),
                        ),
                      ),

                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(),
                              ),

                              /// surah names arabic to english translation
                              Expanded(
                                flex: 6,
                                child: Text(
                                  provider.surahsMetaData[index][6]
                                      .toString()
                                      .toUpperCase(),
                                  style: GoogleFonts.openSans(
                                    fontSize: 9.3.sp,
                                    // fontSize: widget.cmh * 0.0173,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff71727e)
                                        .withOpacity(.75),
                                  ),
                                  // color: const Color(0xff223C63)),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              ///showing index here*******************************
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: widget.cmh * 0.0037,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: themeProvider
                                          .namesIndexContainerColor,
                                      radius: 15,
                                      child: Text(
                                        index.toString(),
                                        style: TextStyle(
                                          fontSize: 9.3.sp,
                                          color:
                                              themeProvider.namesIndexFontColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ///surah english names
                                    Text(
                                      provider.surahsMetaData[index][5]
                                          .toString(),
                                      style: GoogleFonts.lato(
                                        fontSize: 13.sp,
                                        // fontSize: widget.cmh * 0.025,
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider
                                            .namesEnglishSurahFontColor,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),

                              /// surah names in arabic calligraphy
                              Expanded(
                                flex: 3,
                                child: Text(
                                  QuranMetaData().surahNamesIconList[index - 1],
                                  style: TextStyle(
                                      fontFamily:
                                          settingsProvider.surahNamesFont,
                                      fontSize: 35.sp,
                                      color: themeProvider
                                          .namesArabicSurahFontColor),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),

                          ///here is the place of revelation & verses shown start
                          Row(
                            ///this row is only to level the divider

                            children: [
                              Expanded(
                                // flex: 2,
                                child: Container(),
                              ),
                              const Expanded(
                                flex: 3,
                                child: Divider(),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              Expanded(
                                  flex: 6,
                                  child: Row(
                                    children: [
                                      /// showing place of revelation here
                                      Expanded(
                                        child: Text(
                                          provider.surahsMetaData[index][7]
                                              .toString()
                                              .toUpperCase(),
                                          // style: GoogleFonts.hindVadodara(),
                                          style: GoogleFonts.hindVadodara(
                                            fontSize: 9.3.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xff71727e)
                                                .withOpacity(.75),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: widget.cmh * 0.021,
                                        width: widget.cmh * 0.003,
                                        decoration: BoxDecoration(
                                            color: const Color(0xff71727e)
                                                .withOpacity(.35),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                      Container(
                                        width: widget.cmw * 0.019,
                                      ),

                                      ///showing verses here
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          '${provider.surahsMetaData[index][1].toString().toUpperCase()}  Verses',
                                          style: GoogleFonts.sura(
                                            fontSize: 9.3.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xff71727e)
                                                .withOpacity(.75),
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),

                                      /// icon displayed when surah is playing
                                      if (audioProvider
                                                  .currentPlayingSurahNumber ==
                                              index &&
                                          audioProvider.showSpeaker)
                                        Icon(
                                          Icons.multitrack_audio_sharp,
                                          size: widget.cmh * 0.029,
                                        ),
                                    ],
                                  )),
                            ],
                          ),

                          ///here is the place of revelation  END
                        ],
                      ),

                      ///on pressed
                      onPressed: () async {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    NavigatorControllerSurahDisplayScreen(
                              surahIndex: 115 - (index + 1),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
