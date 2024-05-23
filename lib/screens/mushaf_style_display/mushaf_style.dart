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

import '../../components/quran_meta_data/quran_meta_data.dart';

class Mushaf_style extends StatefulWidget {
  final surahIndex;
  final cmh;
  final cmw;

  const Mushaf_style({
    Key? key,
    this.surahIndex,
    this.cmh,
    this.cmw,
    // required this.surahIndex
  }) : super(key: key);

  @override
  _Mushaf_styleState createState() => _Mushaf_styleState();
}

class _Mushaf_styleState extends State<Mushaf_style> {
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
  String mushaf_text = "";

  String current = "";

  /// fetch quran function
  fetchingQuranHere() async {
    mushaf_text = "";
    await Provider.of<Data>(context, listen: false)
        .quranFetch(surahNumber: widget.surahIndex);
    quranSurah = Provider.of<Data>(context, listen: false).quranSurah;
    mushaf_text = Provider.of<Data>(context, listen: false).mushaf_text;
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

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
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
    quranSurah = Provider.of<Data>(context, listen: true).quranSurah;
    mushaf_text = Provider.of<Data>(context, listen: true).mushaf_text;

    translatedSurah = Provider.of<Data>(context, listen: false).translatedSurah;
    setState(() {});

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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            /// bismillah image is here
                            if (widget.surahIndex != 9)
                              Container(
                                padding:
                                    EdgeInsets.symmetric(vertical: cmh * 0.01),
                                color: themeProvider.bismillahContainerColor,
                                child: Image.asset(
                                  'images/bismillah.png',
                                  height: widget.cmh * 0.07,
                                ),
                              ),

                            ///MUSHAF DISPLAYED HERE
                            //
                            mushaf_stye(
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
                          ],
                        ),
                      )),
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
      decoration: BoxDecoration(
          color: !themeProvider.darkTheme
              ? Color(0xfff0dfc4).withOpacity(.3)
              : Color(0xff1f2125)),
      margin:
          EdgeInsets.symmetric(horizontal: cmw * 0.03, vertical: cmh * 0.01),
      padding:
          EdgeInsets.symmetric(horizontal: cmw * 0.07, vertical: cmh * 0.02),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          mushaf_text,
          textAlign: TextAlign.justify,
          style: TextStyle(
            /// indo
            /// and uthmani font
            ///
            ///

            fontSize:
                // widget.cmh * 0.045,
                settingsProvider.selectedArabicType == 'Indo - Pak'
                    ? settingsProvider.arabicFontSize.sp - 3
                    : settingsProvider.arabicFontSize.sp - 5,
            fontFamily: settingsProvider.selectedArabicType == 'Indo - Pak'
                ? settingsProvider.indoPakScriptFont
                : settingsProvider.uthmaniScriptFont,

            // fontFamily:
            //     "p1",

            color: themeProvider.arabicFontColor,
          ),
        ),
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
