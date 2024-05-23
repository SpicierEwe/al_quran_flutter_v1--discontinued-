import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/remove_listview_glow/remove_listview_glow.dart';
import '../../providers/data_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';

class SelectTafsirScreen extends StatefulWidget {
  const SelectTafsirScreen({Key? key}) : super(key: key);

  @override
  _SelectTafsirScreenState createState() => _SelectTafsirScreenState();
}

class _SelectTafsirScreenState extends State<SelectTafsirScreen> {
  @override
  void initState() {
    Provider.of<SettingsProvider>(context, listen: false).getTafsirs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var dataProvider = Provider.of<Data>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);

    var mq = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        backgroundColor: themeProvider.translatorScaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Select Tafsir'),
        ),
        body: SizedBox(
          height: mq.height -
              (AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top),
          width: mq.width,
          child: ScrollConfiguration(
            behavior: RemoveListViewGlow(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                var cmh = constraints.maxHeight;
                var cmw = constraints.maxWidth;
                return Column(
                  children: [
                    SizedBox(
                      height: cmh * 0.13,
                      child: Column(
                        children: [
                          SizedBox(
                            height: cmh * 0.02,
                          ),
                          Text(
                            ' ${settingsProvider.selectedLanguage}',
                            style: GoogleFonts.lato(
                              fontSize: cmh * 0.025,
                              color: themeProvider.translatorTitleColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: cmh * 0.007,
                          ),
                          Text(
                            '${settingsProvider.tafsirs.length}  Tafsirs available',
                            style: GoogleFonts.lato(
                              color: themeProvider.translatorTitleColor,
                              fontSize: cmh * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: cmh * 0.87,
                      child: ListView.builder(
                          itemCount: settingsProvider.tafsirs.length,
                          itemBuilder: (context, index) {
                            if (settingsProvider.tafsirs.isEmpty) {
                              return const CircularProgressIndicator();
                            }
                            return Column(
                              children: [
                                TextButton(
                                  // padding: EdgeInsets.only(
                                  //   top: cmh * 0.02,
                                  //   left: cmh * 0.02,
                                  //   right: cmh * 0.02,
                                  //   bottom: cmh * 0.015,
                                  // ),

                                  ///onPressed start*******************
                                  onPressed: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();

                                    await prefs.setInt('tafsir_id',
                                        settingsProvider.tafsirs[index]['id']);

                                    await prefs.setString(
                                        'tafsir_name',
                                        settingsProvider.tafsirs[index]
                                            ['name']);

                                    ///assigning tafsir name here
                                    settingsProvider.updateSelectedTafsirName(
                                        tafsirName: settingsProvider
                                            .tafsirs[index]['name']);
                                    Navigator.pop(context);
                                    // print(
                                    //     settingsProvider.tafsirs[index]['id']);
                                  },

                                  ///onPressed ENDED************
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        settingsProvider.tafsirs[index]['name']
                                            .toString(),
                                        textScaleFactor: 1.5,
                                        style: GoogleFonts.lato(
                                            color: themeProvider
                                                .translationFontColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: cmh * 0.017),
                                      ),
                                      SizedBox(
                                        height: cmh * 0.005,
                                      ),
                                      Text(
                                        settingsProvider.tafsirs[index]
                                                ['author_name']
                                            .toString(),
                                        style: GoogleFonts.lato(
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: cmh * 0.020),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: themeProvider.translatorDividerColor,
                                )
                              ],
                            );
                          }),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
