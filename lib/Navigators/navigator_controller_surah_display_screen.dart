import 'package:al_quran/components/internal_menu.dart';
import 'package:al_quran/components/menu.dart';
import 'package:al_quran/components/quran_meta_data/quran_meta_data.dart';
import 'package:al_quran/providers/audio_provider.dart';
import 'package:al_quran/providers/bookmarks_provider.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:al_quran/screens/contact_us_screens/contact_us_screen.dart';
import 'package:al_quran/screens/contact_us_screens/report_screen.dart';
import 'package:al_quran/screens/contact_us_screens/suggest_feature_screen.dart';
import 'package:al_quran/screens/favourites_display_screen/favourites_display_screen.dart';
import 'package:al_quran/screens/mushaf_style_display/mushaf_style.dart';
import 'package:al_quran/screens/settings/settings_screen.dart';
import 'package:al_quran/screens/surah_display_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../providers/settings_provider.dart';

class NavigatorControllerSurahDisplayScreen extends StatefulWidget {
  final surahIndex;

  const NavigatorControllerSurahDisplayScreen({
    Key? key,
    required this.surahIndex,
    // required this.surahIndex,
  }) : super(key: key);

  @override
  _NavigatorControllerSurahDisplayScreenState createState() =>
      _NavigatorControllerSurahDisplayScreenState();
}

class _NavigatorControllerSurahDisplayScreenState
    extends State<NavigatorControllerSurahDisplayScreen>
    with SingleTickerProviderStateMixin {
  ///everything  here is mainly regarding to tab display

  var _tabCount;

  late final TabController _tabController;

  @override
  void initState() {
    /// assigning tabCount length here START
    _tabCount =
        Provider.of<Data>(context, listen: false).surahArabicNames.length;

    /// assigning tabCount length here END
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      /// precaching the ayah jumper image icon so that ere is no popping
      precacheImage(const AssetImage("images/jump_ayah_icon.png"), context);
    });
    _tabController = TabController(length: _tabCount, vsync: this);
    _tabController.index = widget.surahIndex;

    ///sending _tabController to audio provider here
    Provider.of<AudioProvider>(context, listen: false).tabController =
        _tabController;
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  bool isAyahJumperAppBarOpen = false;

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    var mq = MediaQuery.of(context).size;
    var provider = Provider.of<Data>(context);
    var bookmarksProvider = Provider.of<BookmarksProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        /// closing ayah jumper appbar if the user presses back and the ayah  jumper search  appbar is open
        if (isAyahJumperAppBarOpen) {
          setState(() => isAyahJumperAppBarOpen = false);
          return false;
        } else {
          return true;
        }
      },
      child: LayoutBuilder(builder: (context, constraints) {
        var cmh = constraints.maxHeight;
        var cmw = constraints.maxWidth;
        return DefaultTabController(
          length: _tabCount,
          initialIndex: widget.surahIndex,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: themeProvider.scaffoldBackgroundColor,
            appBar: isAyahJumperAppBarOpen
                ? jumpToVerseAppBar(
                    cmw: cmw, cmh: cmh, bookmarksProvider: bookmarksProvider)
                : AppBar(
                    title: Text(
                      provider.surahsMetaData[114 - (_tabController.index)][5],
                      style: TextStyle(fontSize: cmh * 0.0235),
                    ),
                    actions: <Widget>[
                      ///
                      ///start playing the surah icon
                      IconButton(
                        splashRadius: cmh * 0.025,
                        onPressed: () async {
                          audioProvider.setShowAudioLoaderPopUp(value: true);
                          if (await audioProvider.checkInternet() == true) {
                            audioProvider.initialSurahAyahIndex = 0;
                            await audioProvider.setupSurahPlaylist(
                                context: context);
                            audioProvider.play();
                            audioProvider.setShowAudioLoaderPopUp(value: false);
                            audioProvider.displayBottomMusicBar(bool: true);
                          } else {
                            print('NOT CONNECTED TO THE INTERNET');
                            audioProvider.setShowAudioLoaderPopUp(value: false);
                            audioProvider.setShowNetworkErrorPopUp(value: true);
                          }
                        },
                        key: const ValueKey('Play Surah'),
                        tooltip: "Play Surah",
                        iconSize: cmh * 0.035,
                        icon: const Icon(
                          Icons.play_arrow_rounded,
                        ),
                      ),

                      ///

                      IconButton(
                        key: const ValueKey('last read'),
                        tooltip: "Last Read",
                        splashRadius: cmh * 0.025,
                        icon: Icon(Icons.bookmark, size: cmh * 0.03),
                        onPressed: () {
                          // print(
                          //     'openedSurahNumber = ${bookmarksProvider.openedSurahNumber} surahNUmber = ${bookmarksProvider.surahIndex}');
                          if (bookmarksProvider.surahIndex ==
                                  bookmarksProvider.surahIndex &&
                              bookmarksProvider.surahIndex != 'null') {
                            print(
                                'bookmak surah index = ${bookmarksProvider.surahIndex}');
                            bookmarksProvider.scrollToBookMarkedSurahAyah();
                          }
                          if (bookmarksProvider.surahIndex != 'null') {
                            _tabController.animateTo(
                                (114 - bookmarksProvider.surahIndex).toInt());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.bookmark_rounded,
                                        color: Colors.white, size: cmh * 0.03),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      "No Surah Last Read marked yet",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                duration: const Duration(milliseconds: 1500),
                              ),
                            );
                          }
                        },
                      ),

                      ///
                      /// AYAH JUMPER ICON
                      ///
                      IconButton(
                        tooltip: "Ayah Jumper",
                        splashRadius: cmh * 0.025,
                        onPressed: () =>
                            setState(() => isAyahJumperAppBarOpen = true),
                        icon: Image.asset("images/jump_ayah_icon.png",
                            width: cmw * 0.065),
                      ),

                      /// menu Icon here

                      internalMenuItems(
                          context: context, mq: mq, cmh: cmh, cmw: cmw),
                    ],
                    bottom: TabBar(
                      dragStartBehavior: DragStartBehavior.start,
                      controller: _tabController,
                      indicator: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xffF6ECBF), width: 4.0),
                        ),
                      ),
                      indicatorColor: Colors.white,
                      // physics: const BouncingScrollPhysics(),
                      isScrollable: true,
                      tabs: <Widget>[
                        for (var i = _tabCount - 1; i >= 0; i--)

                          // if (i != 0 && i != 115)
                          Tab(
                              text:
                                  '${i + 1}.  ${provider.surahArabicNames[i]['latin']}')
                        // , Tab(text: 'xxx'), Tab(text: 'xxx')
                      ],
                    ),
                  ),
            body: TabBarView(
              controller: _tabController,

              ///this physics handles the pages sliding currently its turned off keep it off
              physics: const NeverScrollableScrollPhysics(),
              dragStartBehavior: DragStartBehavior.start,
              children: [
                for (int i = _tabCount - 1; i >= 0; i--)
                  SizedBox(
                    height: mq.height -
                        (AppBar().preferredSize.height +
                            MediaQuery.of(context).padding.top),
                    width: mq.width,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        var cmh = constraints.maxHeight;
                        var cmw = constraints.maxWidth;
                        // print(i+1);

                        // return SurahDisplayScreen(
                        //   cmh: cmh,
                        //   cmw: cmw,
                        //   surahIndex: i + 1,
                        // );

                        if (settingsProvider.displayMushafStyle) {
                          return Mushaf_style(
                            cmh: cmh,
                            cmw: cmw,
                            surahIndex: i + 1,
                          );
                        }

                        return SurahDisplayScreen(
                          cmh: cmh,
                          cmw: cmw,
                          surahIndex: i + 1,
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// ayah jumper app bar
  AppBar jumpToVerseAppBar(
      {required double cmh,
      required double cmw,
      required BookmarksProvider bookmarksProvider}) {
    return AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_sharp,
          ),
          splashRadius: cmh * 0.025,
          iconSize: cmh * 0.03,
          onPressed: () => setState(() => isAyahJumperAppBarOpen = false),
        ),
        title: Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.transparent),
          child: TextField(
            keyboardType: TextInputType.number,
            autofocus: true,
            style: TextStyle(fontSize: 11.sp, color: const Color(0xff333333)),
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText:
                    'available ayahs ( 1 - ${QuranMetaData().quranSurah[114 - (_tabController.index)][1]} )',
                border: InputBorder.none),

            /// if the user clicks tick on the key board close the aya jumper search search
            onSubmitted: (value) {
              setState(() => isAyahJumperAppBarOpen = false);
            },

            onChanged: (incomingValue) async {
              String value = incomingValue.trim();

              if (value.isNotEmpty && int.tryParse(value) != null) {
                if (int.parse(value) > 0) {
                  bookmarksProvider.surahItemScrollController
                      .jumpTo(index: int.parse(value) - 1);
                }
              }
            },
          ),
        ));
  }
}
