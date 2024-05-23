import 'package:al_quran/components/ayah_on_click_menu.dart';
import 'package:al_quran/components/bottom_music_bar.dart';
import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/providers/audio_provider.dart';
import 'package:al_quran/providers/bookmarks_provider.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/favourites_provider.dart';
import 'package:al_quran/providers/miscellaneous.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

import '../components/quran_meta_data/quran_meta_data.dart';

class SurahDisplayScreen extends StatefulWidget {
  final surahIndex;
  final cmh;
  final cmw;

  SurahDisplayScreen({
    Key? key,
    this.surahIndex,
    this.cmh,
    this.cmw,
    // required this.surahIndex
  }) : super(key: key);

  @override
  _SurahDisplayScreenState createState() => _SurahDisplayScreenState();
}

class _SurahDisplayScreenState extends State<SurahDisplayScreen> {
  bool showBottomMusicBar = false;

  ///
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  ///

  ///
  List translatedSurah = [];
  List quranSurah = [];
  List tajweedTransliteration = [];

  /// fetch quran function
  fetchingQuranHere() async {
    await Provider.of<Data>(context, listen: false)
        .quranFetch(surahNumber: widget.surahIndex);
    quranSurah = Provider.of<Data>(context, listen: false).quranSurah;
  }

  /// fetch  translation function
  fetchingTranslationHere() async {
    await Provider.of<Data>(context, listen: false)
        .translationFetch(surahNumber: widget.surahIndex);
    translatedSurah = Provider.of<Data>(context, listen: false).translatedSurah;
  }

  /// fetch transliteration function
  fetchingTajweedTransliterationHere() async {
    await Provider.of<Data>(context, listen: false)
        .tajweedTransliterationFetch(surahNumber: widget.surahIndex);
    tajweedTransliteration =
        Provider.of<Data>(context, listen: false).tajweedTransliteration;
  }

  @override
  void initState() {
    ///test***************************
    fetchingQuranHere();
    fetchingTranslationHere();
    fetchingTajweedTransliterationHere();

    ///
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        ///
        ///
        ///getting opened surah index for translator assigning start
        Provider.of<SettingsProvider>(context, listen: false)
            .openedSurahNumber = widget.surahIndex;

        ///sending scroll controller to audioProvider & bookmarkProvider
        Provider.of<AudioProvider>(context, listen: false)
            .itemScrollController = itemScrollController;
        Provider.of<BookmarksProvider>(context, listen: false)
            .surahItemScrollController = itemScrollController;

        ///sending opened surah index to audio Provider here
        Provider.of<AudioProvider>(context, listen: false).openedSurahIndex =
            widget.surahIndex;
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    itemScrollController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scrollController = PrimaryScrollController.of(context);
    var mq = MediaQuery.of(context).size;
    var provider = Provider.of<Data>(context, listen: true);
    var settingsProvider = Provider.of<SettingsProvider>(context, listen: true);
    var audioProvider = Provider.of<AudioProvider>(context, listen: true);
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    var favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: true);
    var bookmarksProvider =
        Provider.of<BookmarksProvider>(context, listen: true);
    var miscellaneousProvider =
        Provider.of<MiscellaneousProvider>(context, listen: true);

    ///
    ///fetching the data here again after changes has been made in settings regarding the change language or translator
    quranSurah = Provider.of<Data>(context, listen: false).quranSurah;
    translatedSurah = Provider.of<Data>(context, listen: false).translatedSurah;

    ///

    ///

    ///
    return Scaffold(
      ///
      ///bottom music  bar is here********************

      bottomNavigationBar: audioProvider.showBottomMusicBar == true
          ? BottomMusicBar(mq: mq)
          : null,

      body: LayoutBuilder(
        builder: (context, constraints) {
          final cmh = constraints.maxHeight;
          final cmw = constraints.maxWidth;
          if (translatedSurah.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
            );
          }
          if (quranSurah.length ==
              QuranMetaData().quranSurah[widget.surahIndex][1]) {
            return Stack(
              children: [
                ScrollConfiguration(
                  behavior: RemoveListViewGlow(),
                  child: Scrollbar(
                    scrollbarOrientation: ScrollbarOrientation.left,
                    radius: Radius.circular(widget.cmh * 0.01),
                    thickness: widget.cmw * 0.005,
                    child: ScrollablePositionedList.builder(

                        ///initial scroll is here ///////////////////////////////////////
                        ///listen to me ~ here im 1st checking if the audio is playing if its playing i scroll the playing ayah
                        ///if not playing then i check if any ayah is bookmarked it it is i just simply scroll to it
                        ///Audio is given preference over bookmark cause audio is playing temporary engagement and bookmark is permanent
                        ///if both are null then i open the 0 ayah by the default
                        initialScrollIndex: (audioProvider
                                        .currentSurahAyaAudioPlayingIndex !=
                                    null &&
                                audioProvider.currentPlayingSurahNumber !=
                                    null &&
                                audioProvider.currentPlayingSurahNumber ==
                                    widget.surahIndex)
                            ? audioProvider.currentSurahAyaAudioPlayingIndex
                            : (bookmarksProvider.ayahIndex != 'null' &&
                                    bookmarksProvider.surahIndex ==
                                        widget.surahIndex)
                                ? bookmarksProvider.ayahIndex - 1
                                : 0,
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
                        itemCount: quranSurah.length,
                        itemBuilder: (context, index) {
                          // print('widget.surahIndex = ' +
                          //     widget.surahIndex.toString() +
                          //     '  bookmark surahindex  = ' +
                          //     bookmarksProvider.surahIndex.toString());
                          return Column(
                            children: [
                              ayah_by_ayah_display(
                                  index,
                                  themeProvider,
                                  provider,
                                  miscellaneousProvider,
                                  settingsProvider,
                                  audioProvider,
                                  context,
                                  mq,
                                  cmh,
                                  cmw,
                                  bookmarksProvider,
                                  favouritesProvider),
                              // mushaf_stye(
                              //     index,
                              //     themeProvider,
                              //     provider,
                              //     miscellaneousProvider,
                              //     settingsProvider,
                              //     audioProvider,
                              //     context,
                              //     mq,
                              //     cmh,
                              //     cmw,
                              //     bookmarksProvider,
                              //     favouritesProvider),
                            ],
                          );
                        }),
                  ),
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
                    message: 'Loading Audio\nFetching from server.',
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
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blueGrey,
            ),
          );
        },
      ),
    );
  }

  Widget mushaf_stye(
      int index,
      ThemeProvider themeProvider,
      Data provider,
      MiscellaneousProvider miscellaneousProvider,
      SettingsProvider settingsProvider,
      AudioProvider audioProvider,
      BuildContext context,
      Size mq,
      double cmh,
      double cmw,
      BookmarksProvider bookmarksProvider,
      FavouritesProvider favouritesProvider) {
    return Container(
      child: Text(
        "hiiii",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Column ayah_by_ayah_display(
      int index,
      ThemeProvider themeProvider,
      Data provider,
      MiscellaneousProvider miscellaneousProvider,
      SettingsProvider settingsProvider,
      AudioProvider audioProvider,
      BuildContext context,
      Size mq,
      double cmh,
      double cmw,
      BookmarksProvider bookmarksProvider,
      FavouritesProvider favouritesProvider) {
    return Column(
      children: [
        if (index == 0)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ///here is the data about surah at the top start///
              Center(
                child: Container(
                  color: themeProvider.topSurahData,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: widget.cmh * 0.09,
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xffF6ECBF).withOpacity(.5),
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: Colors.blueGrey.withOpacity(.3),
                              ),
                            ),

                            ///  revelation place displaying from here
                            child: Text(
                              '${provider.surahsMetaData[widget.surahIndex][7]}',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: widget.cmh * 0.0155),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: widget.cmh * 0.02),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              ///todo the opacity change later
                              color: const Color(0xffF6ECBF).withOpacity(.5),
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: Colors.blueGrey.withOpacity(.3),
                              ),
                            ),

                            /// top surah name english translation here
                            child: Text(
                              '${provider.surahsMetaData[widget.surahIndex][6]}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: widget.cmh * 0.0195),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: widget.cmh * 0.02),
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xffF6ECBF).withOpacity(.5),
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: Colors.blueGrey.withOpacity(.3),
                              ),
                            ),

                            /// top verse count here
                            child: Text(
                                '${provider.surahsMetaData[widget.surahIndex][1]}  verses',
                                style: TextStyle(fontSize: widget.cmh * 0.0155),
                                textAlign: TextAlign.start),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///here is the data about verse at the top END
              ///
              /// /// bismillah image displayed  here
              if (widget.surahIndex != 1 && widget.surahIndex != 9)
                Container(
                  color: themeProvider.bismillahContainerColor,
                  child: Image.asset(
                    'images/bismillah.png',
                    height: widget.cmh * 0.07,
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
              // padding: EdgeInsets.zero,
              onPressed: () async {
                ///**************************
                ///here sending data to [miscellaneousProvider] so that it can we copied if the user wants to copy
                ///*************************
                miscellaneousProvider.gatherVerseInformation(
                  surahName: provider.surahsMetaData[widget.surahIndex][5],
                  arabicFullVerse: quranSurah[index]['text'].toString(),
                  verseTranslation: translatedSurah[index]['text'],
                  versenumber: (index).toString(),
                  translationName: settingsProvider.selectedTranslatorName,
                  audioProvider: audioProvider,
                  surahNumber: widget.surahIndex,
                );

                ///

                audioProvider.initialSurahAyahIndex = index;

                ///sending verse and surahName to (ayah oppressed menu)
                ///
                miscellaneousProvider.assignSurahDisplayScreenContext(
                    context: context);

                ayahOnClickMenu(
                    translationLanguage: settingsProvider.selectedLanguage,
                    verseTranslation: translatedSurah[index]['text'],
                    surahIndex: widget.surahIndex,
                    context: context,
                    index: index,
                    mq: mq,
                    verseNumber: (index + 1).toString(),
                    surahName: provider.surahsMetaData[widget.surahIndex][5]);

                ///
              },
              child: Container(
                padding: EdgeInsets.only(
                  top: widget.cmh * 0.015,
                  bottom: widget.cmh * 0.015,
                ),
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: widget.cmh * 0.019),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    /// surah arabic verses shown here
                                    if (settingsProvider.showArabic == true)
                                      TextSpan(
                                        text: index == 0 &&
                                                widget.surahIndex != 1
                                            ? quranSurah[index]['text']
                                                .toString()
                                                .replaceFirst(
                                                    "بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ",
                                                    '')
                                            : quranSurah[index]['text']
                                                .toString(),
                                        style: TextStyle(
                                          /// indo
                                          /// and uthmani font
                                          ///
                                          fontSize:
                                              // widget.cmh * 0.045,
                                              settingsProvider
                                                          .selectedArabicType ==
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
                                              ? settingsProvider
                                                  .indoPakScriptFont
                                              : settingsProvider
                                                  .uthmaniScriptFont,
                                          // fontFamily:
                                          //     "p1",

                                          color: themeProvider.arabicFontColor,
                                        ),
                                      ),

                                    ///arabic verse end symbol with number shown here
                                    ///
                                    /// commented because the script itself has ayah ending symbol
                                    // if (settingsProvider
                                    //         .showArabic ==
                                    //     true)
                                    //   TextSpan(
                                    //     text: ' ' +
                                    //         provider.getVerseEndSymbol(
                                    //             index +
                                    //                 1),
                                    //     style: GoogleFonts
                                    //         .roboto(
                                    //       fontSize:
                                    //           13.sp,
                                    //       color: themeProvider
                                    //           .arabicFontColor,
                                    //     ),
                                    //   ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Text('\u06dd'+ '۲۹'),
                          SizedBox(
                            height: widget.cmh * 0.015,
                          ),

                          /// show Transliteration here
                          if (settingsProvider.showTransliteration)
                            Padding(
                              padding: EdgeInsets.only(
                                  top: cmh * 0.01, right: cmw * 0.05),
                              child: Text(
                                tajweedTransliteration.isNotEmpty
                                    ? tajweedTransliteration[index]['text']
                                        .toString()
                                    : "...",
                                style: GoogleFonts.roboto(

                                    /// transliteration font size
                                    fontSize: settingsProvider
                                        .transliterationFontSize.sp,
                                    color: Provider.of<ThemeProvider>(context)
                                        .translationFontColor
                                        .withOpacity(.75),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),

                          ///
                          /// surah translation shown here
                          ///
                          if (settingsProvider.showTranslation == true)
                            Padding(
                              padding: EdgeInsets.only(
                                right: widget.cmw * 0.03,
                                // top: widget.cmh *
                                //     0.019,
                                top: widget.cmh * 0.017,
                              ),
                              child: Directionality(
                                textDirection: settingsProvider
                                    .changeDirectionalityAccordingToLanguage(),
                                child: Text(
                                  translatedSurah[index]['text'],
                                  style: settingsProvider
                                      .changeTranslationTxtStyleAccordingToLanguage(
                                    context: context,
                                    widget: widget,
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(
                            height: widget.cmh * 0.021,
                          ),

                          ///sjda shown here
                          Row(
                            children: [
                              provider.showSjda(
                                  themeProvider: themeProvider,
                                  surahNumber: widget.surahIndex,
                                  verseNumber: index + 1)
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ///ayah number is english is displayed here
            Padding(
              padding: EdgeInsets.only(
                left: widget.cmh * 0.0075,
                top: widget.cmh * 0.015,
              ),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: themeProvider.ayahEnglishNumberBorderColor),
                    borderRadius: BorderRadius.circular(
                      widget.cmh * 0.023,
                    )),
                child: CircleAvatar(
                  // backgroundColor: Colors.blueGrey.shade50,
                  backgroundColor: Colors.transparent,
                  radius: widget.cmh * 0.02,
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      fontSize: widget.cmh * 0.019,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.ayahEnglishNumbersColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            if (index == audioProvider.currentSurahAyaAudioPlayingIndex &&
                widget.surahIndex == audioProvider.currentPlayingSurahNumber &&
                audioProvider.showSpeaker != false)
              Padding(
                padding: EdgeInsets.only(
                  left: widget.cmh * 0.0133,
                  top: widget.cmh * 0.081,
                ),
                child: Icon(Icons.volume_up,
                    size: widget.cmh * 0.033,
                    color: themeProvider.speakerColor),
              ),
            if (bookmarksProvider.surahType == 'surah' &&
                bookmarksProvider.surahIndex == widget.surahIndex &&
                bookmarksProvider.ayahIndex == index + 1)
              Padding(
                padding: EdgeInsets.only(
                  top:
                      index == audioProvider.currentSurahAyaAudioPlayingIndex &&
                              widget.surahIndex ==
                                  audioProvider.currentPlayingSurahNumber &&
                              audioProvider.showSpeaker != false
                          ? widget.cmh * 0.13
                          : widget.cmh * 0.081,
                  left: widget.cmh * 0.0133,
                ),
                child: Icon(
                  Icons.bookmark_rounded,
                  size: widget.cmh * 0.033,
                  color: themeProvider.lastReadIconColor,
                ),
              ),

            if (favouritesProvider.favouriteVersesArray
                .contains("${widget.surahIndex}:${index + 1}"))
              Padding(
                padding: EdgeInsets.only(
                  top: bookmarksProvider.surahType == 'surah' &&
                              bookmarksProvider.surahIndex ==
                                  widget.surahIndex &&
                              bookmarksProvider.ayahIndex == index + 1 ||
                          index ==
                                  audioProvider
                                      .currentSurahAyaAudioPlayingIndex &&
                              widget.surahIndex ==
                                  audioProvider.currentPlayingSurahNumber &&
                              audioProvider.showSpeaker != false
                      ? widget.cmh * 0.155
                      : widget.cmh * 0.081,
                  left: widget.cmh * 0.0165,
                ),
                child: Icon(
                  Icons.star,
                  size: widget.cmh * 0.025,
                  color: themeProvider.lastReadIconColor,
                ),
              ),
          ],
        ),
      ],
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
              width: cmw * 0.75,
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
