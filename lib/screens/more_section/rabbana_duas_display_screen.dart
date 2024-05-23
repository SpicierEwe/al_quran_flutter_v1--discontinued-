// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:math' as math;

import 'package:al_quran/components/quran_meta_data/quran_meta_data.dart';
import 'package:al_quran/providers/audio_provider.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/favourites_provider.dart';
import 'package:al_quran/providers/more_section_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

import '../../components/bottom_music_bar.dart';
import '../../providers/theme_provider.dart';

class RabbanaDuasDisplayScreen extends StatefulWidget {
  const RabbanaDuasDisplayScreen({Key? key}) : super(key: key);

  @override
  _RabbanaDuasDisplayScreenState createState() =>
      _RabbanaDuasDisplayScreenState();
}

class _RabbanaDuasDisplayScreenState extends State<RabbanaDuasDisplayScreen> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    Provider.of<Data>(context, listen: false).rabbanaDuaTranslationFetch();
    Provider.of<Data>(context, listen: false).rabbanaDuaQuranVerseFetch();
    super.initState();
  }

  var currentPlayingDua;

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var moreSectionProvider = Provider.of<MoreSectionProvider>(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var favouritesProvider = Provider.of<FavouritesProvider>(context);
    var dataProvider = Provider.of<Data>(context);
    var mq = MediaQuery.of(context).size;
    var audioProvider = Provider.of<AudioProvider>(context);

    return Scaffold(
        backgroundColor: themeProvider.scaffoldBackgroundColor,
        bottomNavigationBar: audioProvider.showBottomMusicBar == true
            ? BottomMusicBar(mq: mq)
            : null,
        appBar: AppBar(
          title: const Text('Duas'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        body: SizedBox(
          height: mq.height -
              (AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top),
          width: mq.width,
          child: LayoutBuilder(
            builder: (context, constraints) {
              var cmh = constraints.maxHeight;
              var cmw = constraints.maxWidth;
              if (dataProvider.rabbanaDuasQuranVerses.length ==
                      QuranMetaData().rabbanaDuas.length &&
                  dataProvider.rabbanaDuaTranslatedVerses.length ==
                      QuranMetaData().rabbanaDuas.length &&
                  dataProvider.rabbanaDuasQuranVerses.isNotEmpty &&
                  dataProvider.rabbanaDuaTranslatedVerses.isNotEmpty) {
                return Scrollbar(
                  scrollbarOrientation: ScrollbarOrientation.left,
                  child: ScrollablePositionedList.builder(
                      itemCount: QuranMetaData().rabbanaDuas.length,
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                      initialScrollIndex: audioProvider.duaInitialIndex,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: cmw * 0.05, right: cmw * 0.025),
                          child: Column(
                            children: [
                              if (index == 0)
                                SizedBox(
                                  height: cmh * 0.015,
                                ),
                              if (index != 0)
                                SizedBox(
                                  height: cmh * 0.036,
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(cmh * 0.01),
                                        decoration: BoxDecoration(
                                            color: themeProvider
                                                .settingsItemTitleFontColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                cmh * 0.01,
                                              ),
                                              topRight: Radius.circular(
                                                cmh * 0.01,
                                              ),
                                            )),
                                        child: Text(
                                          'Dua ' + (index + 1).toString(),
                                          style: TextStyle(
                                              fontSize: cmh * 0.025,
                                              color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        width: cmh * 0.01,
                                      ),

                                      ///play dua audio Icon --------------------------------------------
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            currentPlayingDua = index;
                                          });

                                          audioProvider.singleDuaAudioPlayer(
                                            duaIndex: index,
                                            itemScrollController:
                                                itemScrollController,
                                            context: context,
                                            surahName: QuranMetaData()
                                                    .quranSurah[
                                                QuranMetaData()
                                                    .rabbanaDuas[index][0]][5],
                                            surahNumber: QuranMetaData()
                                                .rabbanaDuas[index][0],
                                            verseNumber: QuranMetaData()
                                                .rabbanaDuas[index][1],
                                          );
                                        },
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          semanticLabel: 'Play Dua',
                                          size: cmh * 0.041,
                                          color: themeProvider.speakerColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  ///currently playing audio icon is here======================================
                                  if (index ==
                                          audioProvider
                                              .duaCurrentPlayingIndex &&
                                      audioProvider.duaCurrentPlayingIndex !=
                                          null &&
                                      audioProvider.showSpeaker == true)
                                    Icon(
                                      Icons.volume_up_rounded,
                                      semanticLabel: 'Currently Playing',
                                      size: cmh * 0.039,
                                      color: themeProvider.speakerColor,
                                    ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(cmh * 0.003),
                                decoration: BoxDecoration(
                                  color:
                                      themeProvider.settingsItemTitleFontColor,
                                  border: Border.all(
                                    color: themeProvider
                                        .settingsItemTitleFontColor,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(
                                      cmh * 0.01,
                                    ),
                                    topRight: Radius.circular(
                                      cmh * 0.01,
                                    ),
                                    bottomLeft: Radius.circular(
                                      cmh * 0.01,
                                    ),
                                  ),
                                ),

                                ///top dua surah no and verse number is shown here
                                child: Center(
                                  child: Text(
                                    '${QuranMetaData().quranSurah[QuranMetaData().rabbanaDuas[index][0]][5]} | verse : ${QuranMetaData().rabbanaDuas[index][1]}',
                                    style: TextStyle(
                                      fontSize: cmh * 0.02,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Transform.rotate(
                                  angle: -180 * math.pi / 360,
                                  child: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color: themeProvider
                                        .settingsItemTitleFontColor,
                                  )),
                              Directionality(
                                textDirection: TextDirection.rtl,

                                ///
                                ///showing the dua quranic verse (arabic) here
                                ///
                                child: Padding(
                                  padding: EdgeInsets.only(top: cmh * 0.011),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: dataProvider
                                              .rabbanaDuasQuranVerses[index],
                                          style: TextStyle(
                                            fontSize: settingsProvider
                                                        .selectedArabicType ==
                                                    'Indo - Pak'
                                                ? settingsProvider
                                                        .arabicFontSize.sp -
                                                    5.1
                                                : settingsProvider
                                                        .arabicFontSize.sp -
                                                    7.5,
                                            fontFamily: settingsProvider
                                                        .selectedArabicType ==
                                                    'Indo - Pak'

                                                // ? 'me-quran'
                                                ? settingsProvider
                                                    .indoPakScriptFont
                                                : settingsProvider
                                                    .uthmaniScriptFont,
                                            color:
                                                themeProvider.arabicFontColor,
                                          ),
                                        ),
                                        WidgetSpan(
                                            child: SizedBox(
                                          width: cmw * 0.015,
                                        )),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: cmw * 0.03,
                                  top: cmh * 0.019,
                                ),

                                ///translated dua is here
                                child: Directionality(
                                  textDirection: settingsProvider
                                      .changeDirectionalityAccordingToLanguage(),
                                  child: Text(
                                    dataProvider
                                        .rabbanaDuaTranslatedVerses[index],
                                    style: moreSectionProvider
                                        .changeTranslationTxtStyleAccordingToLanguage(
                                      cmh: cmh,
                                      cmw: cmw,
                                      context: context,
                                    ),
                                  ),
                                ),
                              ),
                              if (index ==
                                  QuranMetaData().rabbanaDuas.length - 1)
                                SizedBox(
                                  height: cmh * 0.05,
                                ),
                            ],
                          ),
                        );
                      }),
                );
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueGrey,
                ),
              );
            },
          ),
        ));
  }
}
