import 'package:al_quran/components/juz/juz_ayah_on_click_menu.dart';
import 'package:al_quran/components/quran_meta_data/quran_meta_data.dart';
import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/providers/bookmarks_provider.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/favourites_provider.dart';
import 'package:al_quran/providers/juz_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

import '../../components/bottom_music_bar.dart';
import '../../providers/audio_provider.dart';
import '../../providers/miscellaneous.dart';

class JuzDisplayScreen extends StatefulWidget {
  final juzIndex;

  const JuzDisplayScreen({
    Key? key,
    required this.juzIndex,
  }) : super(key: key);

  @override
  _JuzDisplayScreenState createState() => _JuzDisplayScreenState();
}

class _JuzDisplayScreenState extends State<JuzDisplayScreen> {
  final ItemScrollController juzItemScrollController = ItemScrollController();
  final ItemPositionsListener juzItemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    Provider.of<JuzProvider>(context, listen: false).openedJuz =
        widget.juzIndex;
    Provider.of<JuzProvider>(context, listen: false).translationName =
        Provider.of<Data>(context, listen: false).translationName;

    Provider.of<JuzProvider>(context, listen: false).juzTranslationFetch();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ///sending scroll controller to audioProvider & bookmarkProvider
      ///
      Provider.of<AudioProvider>(context, listen: false)
          .juzItemScrollController = juzItemScrollController;

      ///
      Provider.of<BookmarksProvider>(context, listen: false)
          .juzItemScrollController = juzItemScrollController;

      /// getting opened juz index
      Provider.of<AudioProvider>(context, listen: false).openedJuzIndex =
          widget.juzIndex;

      // print("THE JUX INDEX IS  = " + widget.juzIndex.toString());

      /// its in didChangeDependencies so that whenever the arabic quran script is changed its auto updated
      Provider.of<JuzProvider>(context, listen: false).juzFilter(
          arabicScriptType:
              Provider.of<SettingsProvider>(context, listen: false)
                  .selectedArabicType);
    });

    super.initState();
  }

  // @override
  // void dispose() {
  //   juzItemScrollController;
  //   super.dispose();
  // }

  @override
  void didChangeDependencies() {
    // /// its in didChangeDependencies so that whenever the arabic quran script is changed its auto updated
    // Provider.of<JuzProvider>(context, listen: false).juzFilter(
    //     arabicScriptType: Provider.of<SettingsProvider>(context, listen: false)
    //         .selectedArabicType);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Data>(context);
    AudioProvider audioProvider = Provider.of<AudioProvider>(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    var favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: true);
    var bookmarksProvider =
        Provider.of<BookmarksProvider>(context, listen: true);
    var juzProvider = Provider.of<JuzProvider>(
      context,
    );
    var miscellaneousProvider =
        Provider.of<MiscellaneousProvider>(context, listen: true);
    var mq = MediaQuery.of(context).size;

    ///
    // List translatedJuz = juzProvider.juzTranslatedSurah;

    ///
    return Scaffold(
      resizeToAvoidBottomInset: false,

      /// bottom music nav bar
      bottomNavigationBar: audioProvider.showBottomMusicBar == true
          ? BottomMusicBar(mq: mq)
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final cmh = constraints.maxHeight;
          final cmw = constraints.maxHeight;

          if (juzProvider.juzTranslatedSurah == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
            );
          }
          return Scrollbar(
            scrollbarOrientation: ScrollbarOrientation.left,
            radius: Radius.circular(cmh * 0.01),
            thickness: cmw * 0.005,
            child: Stack(
              children: [
                ScrollConfiguration(
                  behavior: RemoveListViewGlow(),
                  child: ScrollablePositionedList.builder(
                      initialScrollIndex:
                          // bookmarksProvider.juzAyahIndex != 'null' &&
                          //         bookmarksProvider.juzIndex == widget.juzIndex
                          //     ? bookmarksProvider.juzAyahIndex
                          //     : 0,

                          (audioProvider.juzCurrentAyahAudioPlayingIndex !=
                                      null &&
                                  audioProvider.currentPlayingJuzIndex !=
                                      null &&
                                  audioProvider.currentPlayingJuzIndex ==
                                      widget.juzIndex)
                              ? audioProvider.juzCurrentAyahAudioPlayingIndex
                              : bookmarksProvider.juzAyahIndex != 'null' &&
                                      bookmarksProvider.juzIndex ==
                                          widget.juzIndex
                                  ? bookmarksProvider.juzAyahIndex
                                  : 0,
                      itemScrollController: juzItemScrollController,
                      itemPositionsListener: juzItemPositionsListener,
                      itemCount: juzProvider.juzData.length,
                      itemBuilder: (context, index) {
                        ///updating app bar surah here

                        return Column(
                          children: [
                            Column(
                              children: [
                                if (index == 0 ||
                                    juzProvider.juzData[index]['sura'] !=
                                            juzProvider.juzData[0]['sura'] &&
                                        juzProvider.juzData[index]['aya'] == 1)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ///here is the data about verse at the top start///
                                      ///
                                      ///
                                      /// Surah calligraphy icon
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: cmh * 0.015),
                                        color: themeProvider.darkTheme
                                            ? themeProvider
                                                .namesArabicSurahFontColor
                                            : Colors.white,
                                        child: Text(
                                          // QuranMetaData().surahNamesIconList[
                                          //     (juzProvider.juzData[index]['sura'])],
                                          QuranMetaData().surahNamesIconList[
                                              juzProvider.juzData[index]
                                                      ['sura'] -
                                                  1],
                                          style: TextStyle(
                                              fontFamily: settingsProvider
                                                  .surahNamesFont,
                                              fontSize: 45.sp,
                                              // color: themeProvider
                                              //     .namesArabicSurahFontColor,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                      Center(
                                        child: Container(
                                          color: themeProvider.topSurahData,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: cmh * 0.09,
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                              0xffF6ECBF)
                                                          .withOpacity(.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      border: Border.all(
                                                        color: Colors.blueGrey
                                                            .withOpacity(.3),
                                                      ),
                                                    ),

                                                    ///  revelation place displaying  here
                                                    child: Text(
                                                      '${provider.surahsMetaData[juzProvider.juzData[index]['sura']][7]}',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontSize:
                                                              cmh * 0.0155),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: cmh * 0.02),
                                              Expanded(
                                                flex: 2,
                                                child: Center(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                              0xffF6ECBF)
                                                          .withOpacity(.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      border: Border.all(
                                                        color: Colors.blueGrey
                                                            .withOpacity(.3),
                                                      ),
                                                    ),

                                                    /// top surah arabic name here
                                                    child: Text(
                                                      provider.surahsMetaData[
                                                              juzProvider
                                                                      .juzData[
                                                                  index]['sura']]
                                                              [5]
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize:
                                                              cmh * 0.0195),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: cmh * 0.02),
                                              Expanded(
                                                child: Center(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                              0xffF6ECBF)
                                                          .withOpacity(.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      border: Border.all(
                                                        color: Colors.blueGrey
                                                            .withOpacity(.3),
                                                      ),
                                                    ),

                                                    /// top verse count here
                                                    child: Text(
                                                        '${provider.surahsMetaData[juzProvider.juzData[index]['sura']][1]}  verses',
                                                        style: TextStyle(
                                                            fontSize:
                                                                cmh * 0.0155),
                                                        textAlign:
                                                            TextAlign.start),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      ///here is the data about verse at the top END
                                      ///
                                      /// bismillah image displayed  here
                                      if (juzProvider.juzData[index]['sura'] !=
                                              1 &&
                                          juzProvider.juzData[index]['sura'] !=
                                              9)
                                        Container(
                                          color: themeProvider
                                              .bismillahContainerColor,
                                          child: Image.asset(
                                            'images/bismillah.png',
                                            height: cmh * 0.07,
                                          ),
                                        ),
                                    ],
                                  ),
                                Stack(
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: () {
                                        ///**************************
                                        ///here sending data to [miscellaneousProvider] so that it can we copied if the user wants to copy
                                        ///*************************
                                        miscellaneousProvider
                                            .gatherVerseInformation(
                                          surahName: provider.surahsMetaData[
                                              juzProvider.juzData[index]
                                                  ['sura']][5],
                                          arabicFullVerse: juzProvider
                                              .juzData[index]['text']
                                              .toString(),
                                          verseTranslation: juzProvider
                                                  .juzTranslatedSurah[index]
                                              ['text'],
                                          versenumber: (juzProvider
                                                      .juzData[index]['aya'] -
                                                  1)
                                              .toString(),
                                          translationName: settingsProvider
                                              .selectedTranslatorName,
                                          audioProvider: audioProvider,
                                          surahNumber: juzProvider
                                              .juzData[index]['sura']
                                              .toString(),
                                        );

                                        /// sending the context to miscellaneous  provider so that it can show snack bar on
                                        /// audio download
                                        miscellaneousProvider
                                            .juzDisplayScreenContext = context;

                                        ///sending verse and surahName to (ayah oppressed menu)****************************
                                        // ///
                                        juzAyahOnClickMenu(
                                            surahIndex: juzProvider
                                                .juzData[index]['sura']
                                                .toString(),
                                            verseTranslation: juzProvider
                                                    .juzTranslatedSurah[index]
                                                ['text'],
                                            context: context,
                                            index: index,
                                            surahName: provider.surahsMetaData[
                                                juzProvider.juzData[index]
                                                    ['sura']][5],
                                            mq: mq,
                                            juzIndex: widget.juzIndex,
                                            verseNumber: juzProvider
                                                .juzData[index]['aya']
                                                .toString());

                                        ///
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          top: cmh * 0.015,
                                          bottom: cmh * 0.015,
                                        ),
                                        // color: Colors.pink.withOpacity(.5),
                                        color: index.isEven
                                            ? themeProvider.evenContainerColor
                                            : themeProvider.oddContainerColor,
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
                                                    textDirection:
                                                        TextDirection.rtl,
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
                                                                text: juzProvider.juzData[index]
                                                                            [
                                                                            'sura'] !=
                                                                        1
                                                                    ? juzProvider
                                                                        .juzData[
                                                                            index]
                                                                            [
                                                                            'text']
                                                                        .toString()
                                                                        .replaceFirst(
                                                                            "بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ",
                                                                            '')
                                                                    : juzProvider
                                                                        .juzData[
                                                                            index]
                                                                            [
                                                                            'text']
                                                                        .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:

                                                                      /// FONTS ARE HERE INDO AND UTHMANI
                                                                      settingsProvider.selectedArabicType ==
                                                                              'Indo - Pak'
                                                                          ? settingsProvider.arabicFontSize.sp -
                                                                              3
                                                                          : settingsProvider.arabicFontSize.sp -
                                                                              5,
                                                                  fontFamily: settingsProvider
                                                                              .selectedArabicType ==
                                                                          'Indo - Pak'
                                                                      ? settingsProvider
                                                                          .indoPakScriptFont
                                                                      : settingsProvider
                                                                          .uthmaniScriptFont,
                                                                  color: themeProvider
                                                                      .arabicFontColor,
                                                                ),
                                                              ),

                                                            ///arabic verse end symbol with number shown here
                                                            // if (settingsProvider
                                                            //         .showArabic ==
                                                            //     true)
                                                            //   TextSpan(
                                                            //     text: ' ' +
                                                            //         provider.getVerseEndSymbol(
                                                            //             juzProvider
                                                            //                     .juzData[index]
                                                            //                 [
                                                            //                 'aya']),
                                                            //     style: GoogleFonts
                                                            //         .robotoMono(
                                                            //       fontSize: 21,
                                                            //       color: themeProvider
                                                            //           .arabicFontColor,
                                                            //     ),
                                                            //   )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: cmh * 0.015,
                                                  ),

                                                  /// show Transliteration here
                                                  if (settingsProvider
                                                      .showTransliteration)
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: cmh * 0.01,
                                                          right: cmw * 0.05),
                                                      child: Text(
                                                        juzProvider
                                                                .juzTransliteration
                                                                .isNotEmpty
                                                            ? juzProvider
                                                                .juzTransliteration[
                                                                    index]
                                                                    ['text']
                                                                .toString()
                                                            : "...",
                                                        style:
                                                            GoogleFonts.roboto(

                                                                /// transliteration font size
                                                                fontSize:
                                                                    settingsProvider
                                                                        .transliterationFontSize
                                                                        .sp,
                                                                color: Provider.of<
                                                                            ThemeProvider>(
                                                                        context)
                                                                    .translationFontColor
                                                                    .withOpacity(
                                                                        .75),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    ),

                                                  /// surah translation shown here

                                                  if (settingsProvider
                                                          .showTranslation ==
                                                      true)
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        right: cmw * 0.03,
                                                        top: cmh * 0.019,
                                                      ),
                                                      child: Directionality(
                                                        textDirection:
                                                            settingsProvider
                                                                .changeDirectionalityAccordingToLanguage(),
                                                        child: Text(
                                                          juzProvider
                                                                  .juzTranslatedSurah[
                                                              index]['text'],
                                                          style: settingsProvider
                                                              .changeTranslationTxtStyleAccordingToLanguage(
                                                                  context:
                                                                      context,
                                                                  widget:
                                                                      widget),
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
                                                          themeProvider:
                                                              themeProvider,
                                                          surahNumber:
                                                              juzProvider
                                                                  .juzData[
                                                                      index]
                                                                      ['sura']
                                                                  .toString(),
                                                          verseNumber:
                                                              juzProvider
                                                                  .juzData[
                                                                      index]
                                                                      ['aya']
                                                                  .toString())
                                                    ],
                                                  )

                                                  ///this was used in test to know the surah name and ayah at the bottom of the display container
                                                  // Text(provider.surahsMetaData[juzProvider
                                                  //         .juzData[index]['sura']][5] +
                                                  //     '  ' +
                                                  //     'ayah = ' +
                                                  //     juzProvider.juzData[index]['aya']
                                                  //         .toString()),

                                                  // Text(juzProvider.juzData[index]
                                                  //         ['sura']
                                                  //     .toString()),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    ///ayah number is english on left side is displayed here
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
                                            (juzProvider.juzData[index]['aya'])
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: cmh * 0.019,
                                              fontWeight: FontWeight.bold,
                                              color: themeProvider
                                                  .ayahEnglishNumbersColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),

                                    ///speaker icon is here
                                    if (index ==
                                            audioProvider
                                                .juzCurrentAyahAudioPlayingIndex &&
                                        widget.juzIndex ==
                                            audioProvider
                                                .currentPlayingJuzIndex &&
                                        audioProvider.showSpeaker != false)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: cmh * 0.0133,
                                          top: cmh * 0.081,
                                        ),
                                        child: Icon(Icons.volume_up,
                                            size: cmh * 0.033,
                                            color: themeProvider.speakerColor),
                                      ),
                                    if (bookmarksProvider.juzType == 'juz' &&
                                        widget.juzIndex ==
                                            bookmarksProvider.juzIndex &&
                                        bookmarksProvider.juzAyahIndex == index)

                                      /// this is the spacing for the bookmark icon when the speaker icon
                                      /// is active at that index so that they don't overlap
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: index ==
                                                      audioProvider
                                                          .juzCurrentAyahAudioPlayingIndex &&
                                                  widget.juzIndex ==
                                                      audioProvider
                                                          .currentPlayingJuzIndex &&
                                                  audioProvider.showSpeaker !=
                                                      false
                                              ? cmh * 0.13
                                              : cmh * 0.081,
                                          left: cmh * 0.0133,
                                        ),
                                        child: Icon(
                                          Icons.book_rounded,
                                          color:
                                              themeProvider.lastReadIconColor,
                                          size: cmh * 0.03,
                                        ),
                                      ),
                                    if (favouritesProvider.favouriteVersesArray
                                        .contains(
                                            "${juzProvider.juzData[index]['sura']}:${juzProvider.juzData[index]['aya']}"))
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: bookmarksProvider.juzType ==
                                                          'juz' &&
                                                      widget.juzIndex ==
                                                          bookmarksProvider
                                                              .juzIndex &&
                                                      bookmarksProvider
                                                              .juzAyahIndex ==
                                                          index ||
                                                  index ==
                                                          audioProvider
                                                              .juzCurrentAyahAudioPlayingIndex &&
                                                      widget.juzIndex ==
                                                          audioProvider
                                                              .currentPlayingJuzIndex &&
                                                      audioProvider
                                                              .showSpeaker !=
                                                          false
                                              ? cmh * 0.159
                                              : cmh * 0.081,
                                          left: cmh * 0.0165,
                                        ),

                                        ///this icon shows if the verse is favourite
                                        child: Icon(
                                          Icons.star,
                                          size: cmh * 0.025,
                                          color:
                                              themeProvider.lastReadIconColor,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            if (provider.surahsMetaData[
                                    juzProvider.juzData[index]['sura']][1] ==
                                juzProvider.juzData[index]['aya'])
                              Divider(
                                thickness: cmh * 0.005,
                                // color: Colors.blueGrey.withOpacity(.50),
                                color: const Color(0xffF6ECBF).withOpacity(.5),
                              ),
                          ],
                        );
                      }),
                ),

                ///*************************************
                ///*************************************
                ///Loading INDICATOR FOR AUDIO PLAYER loading start
                ///*************************************
                ///*************************************

                if (audioProvider.showAudioLoaderPopUp == true)
                  customLoadingWidget(
                    themeProvider: themeProvider,
                    cmw: cmw,
                    cmh: cmh,
                    actionButtonName: 'CANCEL',
                    actionButtonOnPressed: () {
                      audioProvider.setShowAudioLoaderPopUp(value: false);
                    },
                    message: 'Loading Audio\nFetching from Server.',
                  ),
                if (audioProvider.showNetworkErrorPopUp == true)
                  Container(
                    color: Colors.black.withOpacity(.3),
                    child: AlertDialog(
                      backgroundColor:
                          themeProvider.settingsFontSizeChangeModalColor,
                      // contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(cmh * 0.025)),
                      title: const Text('(Audio Player) Network Error'),
                      content: const Text(
                        'Please Check your INTERNET CONNECTION and try again.',
                      ),
                      actions: <Widget>[
                        TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(
                                  themeProvider.darkTheme
                                      ? Colors.blueGrey
                                      : themeProvider.appBarColor),
                            ),
                            child: Text(
                              'Close',
                              style: GoogleFonts.roboto(
                                  fontSize: 11.sp, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              audioProvider.setShowNetworkErrorPopUp(
                                  value: false);
                            }),
                      ],
                    ),
                  ),

                ///*************************************
                ///Loading INDICATOR FOR AUDIO PLAYER loading END
                ///*************************************
                ////////////////////////////////////////////////////////
                ///*************************************
                /// Downloading POPUP  loading start
                ///*************************************
                if (miscellaneousProvider.showDownloadPopUp == true)
                  customLoadingWidget(
                    themeProvider: themeProvider,
                    cmw: cmw,
                    cmh: cmh,
                    message:
                        'Downloading ${miscellaneousProvider.globalSurahName} | verse ${(int.parse(miscellaneousProvider.globalVerseNumber.toString()) + 1).toString()}\n progress ${miscellaneousProvider.downloadProgress} ',
                    // actionButtonOnPressed: () {
                    //   miscellaneousProvider.assignDownloadPopUp(value: false);
                    // },
                    // actionButtonName: 'CLOSE',
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  Container customLoadingWidget(
      {required double cmw,
      required double cmh,
      actionButtonName,
      actionButtonOnPressed,
      required ThemeProvider themeProvider,
      message}) {
    return Container(
        width: cmw,
        height: cmh,
        color: Colors.black.withOpacity(0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  // color: Colors.white,
                  color: themeProvider.settingsFontSizeChangeModalColor,
                  borderRadius: BorderRadius.circular(cmh * 0.025)),
              width: cmw * 0.5,
              // height: cmh * 0.3,

              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: actionButtonName != null ? cmh * 0.05 : cmh * 0.017,
                      bottom: cmh * 0.017,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Colors.blueGrey),
                        SizedBox(
                          width: cmh * 0.03,
                        ),
                        AutoSizeText(
                          '$message',
                          maxLines: 2,
                          style: GoogleFonts.roboto(
                              // fontWeight: FontWeight.bold
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (actionButtonName != null)
                    TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                              themeProvider.darkTheme
                                  ? Colors.blueGrey
                                  : themeProvider.appBarColor),
                        ),
                        onPressed: actionButtonOnPressed,
                        child: Text('$actionButtonName',
                            style: TextStyle(fontSize: 11.5.sp))),
                  // if(actionButtonName == null)
                  //   SizedBox(height: cmh*0.03),
                ],
              ),
            ),
          ],
        ));
  }
}

//background-image: linear-gradient(
// 346deg, #155799, #159957);
