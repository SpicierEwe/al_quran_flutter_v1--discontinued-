import 'package:al_quran/components/menu.dart';
import 'package:al_quran/providers/bookmarks_provider.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:al_quran/screens/favourites_display_screen/favourites_display_screen.dart';
import 'package:al_quran/screens/juz_screens/juz_names_screen.dart';
import 'package:al_quran/screens/more_section/more_display_screen.dart';
import 'package:al_quran/screens/surah_names_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/remove_listview_glow/remove_listview_glow.dart';

class NavigatorControllerSurahNamesScreen extends StatefulWidget {
  const NavigatorControllerSurahNamesScreen({Key? key}) : super(key: key);

  @override
  _NavigatorControllerSurahNamesScreenState createState() =>
      _NavigatorControllerSurahNamesScreenState();
}

class _NavigatorControllerSurahNamesScreenState
    extends State<NavigatorControllerSurahNamesScreen>
    with SingleTickerProviderStateMixin {
  ///

  var _tabCount;

  @override
  void initState() {
    _tabCount = 3;
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
    return DefaultTabController(
      length: _tabCount,
      initialIndex: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          var cmh = constraints.maxHeight;
          var cmw = constraints.maxWidth;
          return
            Scaffold(
              backgroundColor: themeProvider.namesScaffoldBackgroundColor,
              appBar: AppBar(
                title: Text('al - Qur\'an',
                    style: TextStyle(
                      fontSize: cmh * 0.023,
                    )),
                actions: <Widget>[
                  IconButton(
                    splashRadius: 21,
                    key: const ValueKey(
                      'Last Read Surah',
                    ),
                    icon: Icon(Icons.bookmark_rounded, size: cmh * 0.03),
                    onPressed: () {
                      bookmarksProvider.navigateToLastRead(context: context);
                    },
                  ),

                  ///Last read Juz*******************
                  IconButton(
                    splashRadius: 21,
                    key: const ValueKey('last read Juz'),
                    icon: Icon(Icons.book_rounded, size: cmh * 0.03),
                    onPressed: () {
                      bookmarksProvider.navigateToLastReadJuz(
                          context: context);
                    },
                  ),

                  /// book marks button icon here
                  IconButton(
                    splashRadius: 21,
                    key: const ValueKey('bookmarks'),
                    icon: Icon(Icons.star, size: cmh * 0.03),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const FavouritesDisplayScreen(),
                          ));
                    },
                  ),

                  /// search Icon here
                  // IconButton(
                  //   splashRadius: cmh * 0.025,
                  //   onPressed: (){},
                  //   icon: Icon(Icons.search, size: cmh * 0.03),
                  // ),

                  /// menu Icon here
                  menuItems(mq: mq, cmh: cmh, cmw: cmw, context: context)
                ],
                bottom: const TabBar(
                  // overlayColor: MaterialStateProperty.all(Colors.transparent),
                  indicator: BoxDecoration(
                    border: Border(
                      bottom:
                      BorderSide(color: Color(0xffF6ECBF), width: 2.0),
                    ),
                  ),
                  indicatorColor: Colors.white,
                  isScrollable: true,
                  tabs: <Widget>[
                    // for (var i = 0; i < _tabCount; i++) Tab(text: tabNames[i]),

                    Tab(
                      text: 'Surahs',
                    ),
                    Tab(text: 'Juz'),
                    Tab(text: 'More'),
                  ],
                ),
              ),
              body: ScrollConfiguration(
                behavior: RemoveListViewGlow(),
                child: TabBarView(
                  // controller: _tabController,
                  children: [
                    SurahNamesScreen(
                      cmh: cmh,
                      cmw: cmw,
                    ),
                    JuzScreen(
                      cmh: cmh,
                      cmw: cmw,
                    ),
                    const MoreDisplayScreen()
                  ],
                ),
              ),
            );

          ///

        },
      ),
    );
  }
}
