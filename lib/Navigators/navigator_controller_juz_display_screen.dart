import 'package:al_quran/components/juz_meta_data.dart';
import 'package:al_quran/components/menu.dart';
import 'package:al_quran/providers/bookmarks_provider.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:al_quran/screens/favourites_display_screen/favourites_display_screen.dart';
import 'package:al_quran/screens/juz_screens/juz_display_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/internal_menu.dart';
import '../providers/audio_provider.dart';

class NavigatorControllerJuzDisplayScreen extends StatefulWidget {
  final juzIndex;

  const NavigatorControllerJuzDisplayScreen({
    Key? key,
    required this.juzIndex,
  }) : super(key: key);

  @override
  _NavigatorControllerJuzDisplayScreenState createState() =>
      _NavigatorControllerJuzDisplayScreenState();
}

class _NavigatorControllerJuzDisplayScreenState
    extends State<NavigatorControllerJuzDisplayScreen>
    with SingleTickerProviderStateMixin {
  ///everything  here is mainly regarding to tab display

  var _juzTabCount;

  late final TabController _juzTabController;

  @override
  void initState() {
    /// assigning tabCount length here START
    _juzTabCount = JuzMetaData().Juz.length;

    /// assigning tabCount length here END
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
    _juzTabController = TabController(length: _juzTabCount, vsync: this);
    _juzTabController.index = widget.juzIndex;

    ///sending _tabController to audio provider here
    Provider
        .of<AudioProvider>(context, listen: false)
        .juzTabController =
        _juzTabController;

    _juzTabController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery
        .of(context)
        .size;
    var provider = Provider.of<Data>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    var bookmarksProvider = Provider.of<BookmarksProvider>(context);
    var audioProvider = Provider.of<AudioProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          var cmh = constraints.maxHeight;
          var cmw = constraints.maxWidth;
          return Scaffold(
            backgroundColor: themeProvider.scaffoldBackgroundColor,
            appBar: AppBar(
              title: Text(
                'Juz  ${30 - _juzTabController.index}',
                style: TextStyle(fontSize: cmh * 0.0235),
              ),
              actions: <Widget>[

                ///start playing the juz icon
                IconButton(
                  splashRadius: cmh * 0.025,
                  onPressed: () async {
                    audioProvider.setShowAudioLoaderPopUp(value: true);
                    if (await audioProvider.checkInternet() == true) {
                      audioProvider.juzAyahInitialIndex = 0;
                      await audioProvider.setupJuzPlaylist(context: context,
                          isRequestFromAppbarPlayButton: true);
                      audioProvider.play();
                      audioProvider.setShowAudioLoaderPopUp(value: false);
                      audioProvider.displayBottomMusicBar(bool: true);
                    } else {
                      print('NOT CONNECTED TO THE INTERNET');
                      audioProvider.setShowAudioLoaderPopUp(value: false);
                      audioProvider.setShowNetworkErrorPopUp(value: true);
                    }
                  },
                  key: const ValueKey('Play Juz'),
                  tooltip: "Play Juz",
                  iconSize: cmh * 0.035,
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    semanticLabel: "Play Juz",
                  ),
                ),

                /// last read icon
                IconButton(
                  splashRadius: cmh * 0.025,
                  key: const ValueKey('juz last read'),
                  icon: Icon(Icons.book_rounded,
                      size: cmh * 0.03, semanticLabel: "Juz Last Read"),
                  tooltip: "Juz Last Read",
                  onPressed: () {
                    if (bookmarksProvider.juzIndex.toString() != 'null' &&
                        int.parse(bookmarksProvider.juzIndex.toString()) ==
                            int.parse(bookmarksProvider.juzIndex.toString())) {
                      // print(bookmarksProvider.juzIndex);
                      bookmarksProvider.scrollToBookMarkedJuzAyah();
                    }
                    if (bookmarksProvider.juzIndex != 'null') {
                      _juzTabController
                          .animateTo((30 - bookmarksProvider.juzIndex).toInt());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.book_rounded,
                                  color: Colors.white,
                                  size: cmh * 0.03,
                                  semanticLabel: "Favourites"),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                "No Juz Last Read marked yet",
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

                IconButton(
                  splashRadius: cmh * 0.025,
                  key: const ValueKey('bookmarks'),
                  icon: Icon(Icons.star,
                      size: cmh * 0.03, semanticLabel: "Favourites"),
                  tooltip: "Favourites",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavouritesDisplayScreen(),
                        ));
                  },
                ),

                /// menu Icon here
                internalMenuItems(
                    context: context, mq: mq, cmh: cmh, cmw: cmw),
              ],
              bottom: TabBar(
                dragStartBehavior: DragStartBehavior.start,
                controller: _juzTabController,
                indicator: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffF6ECBF), width: 4.0),
                  ),
                ),
                indicatorColor: Colors.white,
                // physics: const BouncingScrollPhysics(),
                isScrollable: true,
                tabs: <Widget>[
                  for (var i = _juzTabCount - 1; i >= 0; i--)

                  // if (i != 0 && i != 115)
                    Tab(text: 'Juz  ${JuzMetaData().Juz[i]['Juz']}')
                  // , Tab(text: 'xxx'), Tab(text: 'xxx')
                ],
              ),
            ),
            body: TabBarView(
              controller: _juzTabController,

              ///this physics handles the pages sliding currently its turned off
              physics: const NeverScrollableScrollPhysics(),
              dragStartBehavior: DragStartBehavior.start,
              children: [
                for (int i = _juzTabCount - 1; i >= 0; i--)
                  SizedBox(
                    height: mq.height -
                        (AppBar().preferredSize.height +
                            MediaQuery
                                .of(context)
                                .padding
                                .top),
                    width: mq.width,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return JuzDisplayScreen(
                          juzIndex: i + 1,
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
