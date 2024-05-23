import 'package:al_quran/Navigators/navigator_controller_juz_display_screen.dart';
import 'package:al_quran/components/juz_meta_data.dart';
import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/providers/audio_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../providers/settings_provider.dart';

class JuzScreen extends StatefulWidget {
  final cmh;

  final cmw;

  const JuzScreen({Key? key, this.cmh, this.cmw}) : super(key: key);

  @override
  _JuzScreenState createState() => _JuzScreenState();
}

class _JuzScreenState extends State<JuzScreen> {
  var juz = JuzMetaData().Juz;

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    AudioProvider audioProvider = Provider.of<AudioProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        var cmh = constraints.maxHeight;
        var cmw = constraints.maxWidth;
        return ScrollConfiguration(
          behavior: RemoveListViewGlow(),
          child: ListView.builder(
            padding: EdgeInsets.only(
                top: widget.cmh * 0.003, bottom: widget.cmh * 0.02),
            itemCount: juz.length,
            itemBuilder: (context, originalIndex) {
              final index = settingsProvider.isDescending
                  ? (29 - originalIndex)
                  : originalIndex;
              return Column(
                children: [
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

                    ///flat button here
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(
                              color: Colors.blueGrey.withOpacity(.25)),
                        ),
                      ),

                      // padding: const EdgeInsets.all(15),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(15.0),
                      //   side: BorderSide(color: Colors.blueGrey.withOpacity(.25)),
                      // ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(),
                              ),

                              /// juz start surah and start Ayah*************
                              Expanded(
                                flex: 6,
                                child: Text(
                                  'START :  ${juz[index]['start-surah'].toString().toUpperCase()}  verse  : ${juz[index]['start-ayah']}',
                                  style: GoogleFonts.openSans(
                                    fontSize: 9.3.sp,
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
                                        (index + 1).toString(),
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
                                      'Juz' +
                                          '   ' +
                                          juz[index]['Juz']
                                              .toString()
                                              .toUpperCase(),
                                      style: GoogleFonts.lato(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider
                                            .namesEnglishSurahFontColor,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),

                              /// surah arabic Names
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '',
                                  style: GoogleFonts.lato(
                                      fontSize: 19,
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

                              ///juz end surah and end ayah displayed from here
                              Expanded(
                                flex: 6,
                                child: Text(
                                  'END :  ${juz[index]['end-surah'].toString().toUpperCase()}  verse  : ${juz[index]['end_ayah']}',
                                  style: GoogleFonts.openSans(
                                    fontSize: 9.3.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff71727e)
                                        .withOpacity(.75),
                                  ),
                                  // color: const Color(0xff223C63)),
                                ),
                              ),

                              /// icon displayed when juz is playing
                              if (audioProvider.currentPlayingJuzIndex ==
                                      index + 1 &&
                                  audioProvider.showSpeaker)
                                Icon(
                                  Icons.multitrack_audio_sharp,
                                  size: widget.cmh * 0.029,
                                ),
                            ],
                          ),
                        ],
                      ),

                      ///on pressed
                      onPressed: () async {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    NavigatorControllerJuzDisplayScreen(
                              juzIndex: 30 - (index + 1),
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
        );
      },
    );
  }
}
