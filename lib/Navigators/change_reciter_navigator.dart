import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/components/settings_components/reciter_names_class.dart';
import 'package:al_quran/providers/audio_provider.dart';
import 'package:al_quran/providers/bookmarks_provider.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:al_quran/screens/settings/change_reciters_screen.dart';
import 'package:al_quran/screens/settings/reciters_with_mistakes_screen.dart';
import 'package:al_quran/screens/settings/translations_reciter_screen.dart';
import 'package:al_quran/screens/settings/translations_reciters_with_mistakes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeReciterNavigator extends StatefulWidget {
  const ChangeReciterNavigator({Key? key}) : super(key: key);

  @override
  _ChangeReciterNavigatorState createState() => _ChangeReciterNavigatorState();
}

class _ChangeReciterNavigatorState extends State<ChangeReciterNavigator>
    with SingleTickerProviderStateMixin {
  ///

  ///

  var _tabCount;
  late final TabController _tabController;

  @override
  void initState() {
    _tabCount = 4;
    _tabController = TabController(length: _tabCount, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List recitersCount = [
      Reciters().reciters.length.toString(),
      Reciters().recitersWithMistakes.length.toString(),
      Reciters().translations.length.toString(),
      Reciters().translationsWithMistakes.length.toString()
    ];
    var mq = MediaQuery.of(context).size;
    var provider = Provider.of<Data>(context);
    AudioProvider audioProvider = Provider.of<AudioProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    var bookmarksProvider = Provider.of<BookmarksProvider>(context);
    return ScrollConfiguration(
      behavior: RemoveListViewGlow(),
      child: DefaultTabController(
          length: _tabCount,
          initialIndex: 0,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: themeProvider.appBarColor,
              title: const Text('Select Reciter'),
              actions: [
                Center(
                    child: Padding(
                  padding: EdgeInsets.only(right: mq.width * 0.05),
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: recitersCount[_tabController.index].toString()),
                      TextSpan(
                          text: _tabController.index == 0 ||
                                  _tabController.index == 2
                              ? '  reciters'
                              : '  translators')
                    ]),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ))
              ],
              bottom: TabBar(
                controller: _tabController,
                indicator: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffF6ECBF), width: 2.0),
                  ),
                ),
                indicatorColor: Colors.white,
                isScrollable: true,
                tabs: const <Widget>[
                  Tab(
                    text: 'Reciters',
                  ),
                  Tab(text: 'Translations'),
                  Tab(text: 'Reciters with Mistakes'),
                  Tab(text: 'Translations With Mistakes'),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    var cmh = constraints.maxHeight;
                    var cmw = constraints.maxWidth;

                    return const ChangeReciterScreen();
                  },
                ),
                SizedBox(
                  height: mq.height -
                      (AppBar().preferredSize.height +
                          MediaQuery.of(context).padding.top),
                  width: mq.width,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      var cmh = constraints.maxHeight;
                      var cmw = constraints.maxWidth;

                      return const TranslationsReciterScreen();
                    },
                  ),
                ),
                SizedBox(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return const RecitersWithMistakes();
                    },
                  ),
                ),
                SizedBox(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return const TranslationsRecitersWithMistakes();
                    },
                  ),
                ),
              ],
            ),
          )

          // appBar:

          ),
    );
  }
}
