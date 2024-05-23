import 'package:al_quran/components/allah_rasoolallah_names/allah_names.dart';
import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/providers/more_section_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:al_quran/screens/settings/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../providers/data_provider.dart';
import '../../providers/settings_provider.dart';

class AllahNamesScreen extends StatefulWidget {
  const AllahNamesScreen({Key? key}) : super(key: key);

  @override
  _AllahNamesScreenState createState() => _AllahNamesScreenState();
}

class _AllahNamesScreenState extends State<AllahNamesScreen> {
  var showMoreInfo;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var themeProvider = Provider.of<ThemeProvider>(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var dataProvider = Provider.of<Data>(context);
    var moreSectionProvider = Provider.of<MoreSectionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Allah Names'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ));
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      backgroundColor: themeProvider.scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          var cmh = constraints.maxHeight;
          var cmw = constraints.maxWidth;

          return ScrollConfiguration(
            behavior: RemoveListViewGlow(),
            child: ListView.builder(
              itemCount: AllahNamesClass().allahNames.length,
              itemBuilder: (context, index) {
                ///==================================================================================
                ///==================================================================================
                /// ////for URDU return *************************
                ///==================================================================================
                ///==================================================================================
                if (settingsProvider.selectedLanguage == 'Urdu') {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ///allah name image is show here
                      if (index == 0)
                        themeProvider.darkTheme == false
                            ? Image.asset('images/allah_name_white.png')
                            : Image.asset('images/allah_name_golden.png'),

                      Container(
                        padding: EdgeInsets.only(
                            top: cmh * 0.015, bottom: cmh * 0.015),
                        child: Row(
                          children: [
                            ///index number is here
                            indexNumberDisplay(
                                cmh: cmh,
                                index: index,
                                cmw: cmw,
                                themeProvider: themeProvider),
                            Expanded(
                              flex: index == 83 || index == 84 ? 1 : 3,
                              child: Padding(
                                padding: EdgeInsets.only(left: cmw * 0.05),
                                child: Text(
                                  AllahNamesClass()
                                      .allahNames[index]["urdu_meaning"]
                                      .toString(),
                                  style: moreSectionProvider
                                      .changeTranslationTxtStyleAccordingToLanguage(
                                          cmw: cmw, context: context, cmh: cmh),
                                ),
                              ),
                            ),
                            Expanded(
                              // flex: index == 83 || index == 84 ? 2 : 2,
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(right: cmw * 0.013),
                                child: Text(
                                  AllahNamesClass()
                                      .allahNames[index]['arabic_name']
                                      .toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize:
                                        settingsProvider.arabicFontSize.sp,
                                    fontFamily:
                                        settingsProvider.selectedArabicType ==
                                                'Indo - Pak'
                                            ? 'noorehira'
                                            : 'uthmanihafs',
                                    fontWeight:
                                        settingsProvider.selectedArabicType ==
                                                'Indo - Pak'
                                            ? FontWeight.w100
                                            : FontWeight.bold,
                                    color: themeProvider.allahNamesFontColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///i don't know to search a certain world in arabic string
                      // moreInfo(cmw: cmw, cmh: cmh),

                      ///
                      ///here is the divider
                      if (index + 1 != AllahNamesClass().allahNames.length)
                        Container(
                          color: themeProvider.translatorDividerColor,
                          height: cmh * 0.00035,
                        ),
                      if (index + 1 == AllahNamesClass().allahNames.length)
                        SizedBox(
                          height: cmh * 0.02,
                        )
                    ],
                  );
                }

                ///==================================================================================
                ///==================================================================================
                /// ////for ENGLISH return *************************
                ///==================================================================================
                ///==================================================================================
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (index == 0)
                      themeProvider.darkTheme == false
                          ? Image.asset('images/allah_name_white.png')
                          : Image.asset('images/allah_name_golden.png'),
                    TextButton(
                      // padding: EdgeInsets.zero,
                      onPressed: null,
                      // onPressed: () {
                      // if (showMoreInfo != index) {
                      //   setState(() {
                      //     showMoreInfo = index;
                      //   });
                      // } else {
                      //   setState(() {
                      //     showMoreInfo = null;
                      //   });
                      // }
                      // },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              indexNumberDisplay(
                                  cmh: cmh,
                                  index: index,
                                  cmw: cmw,
                                  themeProvider: themeProvider),
                              Expanded(
                                // flex: index == 83 || index == 84 ? 2 : 3,
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: cmh * 0.005,
                                    bottom: cmh * 0.005,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      AllahNamesClass()
                                          .allahNames[index]["english_name"]
                                          .toString(),
                                      style: GoogleFonts.roboto(
                                        color:
                                            themeProvider.translationFontColor,
                                        fontSize: settingsProvider
                                                .translationFontSize.sp -
                                            3.5,
                                      ),
                                    ),
                                    // tileColor: Colors.red,
                                    subtitle: Text(
                                      AllahNamesClass()
                                          .allahNames[index]["english_meaning"]
                                          .toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: settingsProvider
                                                  .translationFontSize.sp -
                                              6.5,
                                          color: themeProvider
                                              .translationFontColor
                                              .withOpacity(.9)),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                // flex: index == 83 || index == 84 ? 2 : 0,
                                child: Padding(
                                  padding: EdgeInsets.only(right: cmw * 0.013),
                                  child: Text(
                                    AllahNamesClass()
                                        .allahNames[index]['arabic_name']
                                        .toString(),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize:
                                          settingsProvider.arabicFontSize.sp,

                                      /// allah  name arabic fonts
                                      fontFamily: settingsProvider
                                                  .selectedArabicType ==
                                              'Indo - Pak'
                                          ? settingsProvider.indoPakScriptFont
                                          : settingsProvider.uthmaniScriptFont,

                                      color: themeProvider.allahNamesFontColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          ///i don't know to search a certain world in arabic string
                          // if (index == showMoreInfo)
                          //   moreInfo(cmw: cmw, cmh: cmh),
                        ],
                      ),
                    ),
                    if (index + 1 != AllahNamesClass().allahNames.length)
                      Container(
                        // color: Color(0x52d5a537),

                        color: themeProvider.translatorDividerColor,
                        height: cmh * 0.00035,
                      ),
                    if (index + 1 == AllahNamesClass().allahNames.length)
                      SizedBox(
                        height: cmh * 0.02,
                      )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget indexNumberDisplay({themeProvider, cmh, cmw, index}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: cmh * 0.025,
          ),
          Container(
            padding: EdgeInsets.all(cmh * 0.01),
            decoration: BoxDecoration(
              color: themeProvider.namesIndexContainerColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(cmh * 0.01),
                bottomRight: Radius.circular(cmh * 0.01),
              ),
            ),
            child: Text(
              (index + 1).toString(),
              style: TextStyle(
                  fontSize: cmh * 0.015,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.namesIndexFontColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget moreInfo({cmh, cmw}) {
    return Row(
      children: [
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              Icon(Icons.info, size: cmh * 0.015, color: Colors.grey),
              SizedBox(
                width: cmw * 0.01,
              ),
              Text(
                'more info',
                style: TextStyle(fontSize: cmh * 0.013, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//#D5A537
