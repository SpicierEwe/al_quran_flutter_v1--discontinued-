import 'package:al_quran/components/default_transaltion.dart';
import 'package:al_quran/components/make_values_permanet_class/make_translators_permanent.dart';
import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/juz_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChangeLanguageSettings extends StatefulWidget {
  const ChangeLanguageSettings({Key? key}) : super(key: key);

  @override
  _ChangeLanguageSettingsState createState() => _ChangeLanguageSettingsState();
}

class _ChangeLanguageSettingsState extends State<ChangeLanguageSettings> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      /** these below 2 lines of codes are to reset the searched language to show all languages and not just one language next time when the user comme back to the respective screen
          provider.searchedQuery = '';
          provider.searchLanguage(query: '');
       **/
      Provider.of<Data>(context, listen: false).searchedQuery = '';
      Provider.of<Data>(context, listen: false).searchLanguage(query: '');
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Data>(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    var mq = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Container(
        color: themeProvider.languageScreenScaffoldColor,
        child: SafeArea(
          child: ScrollConfiguration(
            behavior: RemoveListViewGlow(),
            child: Scaffold(
              backgroundColor: themeProvider.languageScreenScaffoldColor,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: themeProvider.languageScreenScaffoldColor,
                title: Container(
                  margin: EdgeInsets.only(
                    left: mq.width * 0.07,
                    right: mq.width * 0.07,
                    top: mq.height * 0.01,
                    bottom: mq.height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(mq.height * 0.015),
                    border: Border.all(color: Colors.blueGrey),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: mq.width * 0.025,
                      right: mq.width * 0.015,
                    ),
                    child: TextField(
                      cursorColor: Colors.blueGrey,
                      style: TextStyle(
                        color: themeProvider.languageScreenSearchFontColor,
                      ),
                      onChanged: (value) {
                        provider.searchedQuery = value;
                        provider.searchLanguage(query: value.toString());
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search language....',
                          hintStyle: TextStyle(
                            color:
                                themeProvider.languageScreenSearchHintFontColor,
                          )),
                    ),
                  ),
                ),
                // backgroundColor: Color(0xffFEECE3),
                // backgroundColor : Colors.black,
                elevation: 0,
              ),
              body: SizedBox(
                height: mq.height - AppBar().preferredSize.height,
                width: mq.width,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    var cmh = constraints.maxHeight;
                    var cmw = constraints.maxWidth;
                    return SizedBox(
                      height: cmh,
                      width: cmw,
                      child: Column(
                        children: [
                          Container(
                            height: cmh * 0.15,
                            decoration: const BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    left: cmh * 0.03,
                                    top: cmh * 0.035,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Choose',
                                        style: GoogleFonts.lato(
                                            color: themeProvider
                                                .languageScreenTitleFontColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: cmh * 0.04),
                                      ),
                                      Text(
                                        'your new language',
                                        style: GoogleFonts.josefinSans(
                                          color: themeProvider
                                              .languageScreenTitleFontColor,
                                          fontSize: cmh * 0.035,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: cmh * 0.01,
                                ),
                              ],
                            ),
                          ),

                          ///displaying languages here
                          SizedBox(
                            height: cmh * 0.85,

                            child: GridView.builder(
                              padding: EdgeInsets.all(cmh * 0.013),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3 / 2,
                                mainAxisSpacing: cmw * 0.1,
                              ),
                              itemCount: provider.foundLanguages.length,
                              itemBuilder: (context, index) => Center(
                                child: Container(
                                  height: cmh * 0.15,
                                  width: cmw * 0.4,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius:
                                          BorderRadius.circular(cmh * 0.017),
                                      //todo****************************
                                      color: themeProvider
                                          .languageScreenLanguageContainerColor,
                                      // color: const Color(0xffB0A988),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: -2,
                                          blurRadius: 5.0,
                                        ),
                                      ]),
                                  child: TextButton(
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius:
                                    //       BorderRadius.circular(cmh * 0.017),
                                    // ),
                                    child: Center(
                                      child: Text(
                                        ///showing language name here
                                        provider.foundLanguages[index]
                                                    ['local_language_name'] ==
                                                ''
                                            ? provider.foundLanguages[index]
                                                    ['language_name']
                                                .toString()
                                            : provider.foundLanguages[index]
                                                ['local_language_name'],

                                        ///
                                        // provider.foundLanguages[index]
                                        //         ['language_name']
                                        //     .toString(),

                                        style: provider.foundLanguages[index]
                                                    ['language_name'] ==
                                                'Urdu'
                                            ? TextStyle(
                                                fontFamily: 'Noto',
                                                color: const Color(0xffd68468),
                                                fontSize: cmh * 0.027,
                                                fontWeight: FontWeight.bold)
                                            : GoogleFonts.lato(
                                                // color: const Color(0xffD89A84),
                                                color: const Color(0xffd68468),
                                                fontSize: cmh * 0.027,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    ///on pressed is here***** this deals what happens when user clicks on language button
                                    onPressed: () {
                                      ///
                                      ///getting selected language for settings
                                      settingsProvider.selectedLanguage =
                                          provider.foundLanguages[index]
                                              ['language_name'];

                                      ///
                                      ///
                                      ///sending language translations as default for the 1st time for evey language start
                                      ///sending language translations as default for the 1st time for evey language start
                                      ///sending language translations as default for the 1st time for evey language start
                                      TranslatorFileStorage().writeFile(
                                          whatToSave:
                                              provider.foundLanguages[index]
                                                  ['language_name'],
                                          fileNameToSaveIn: 'languageName');

                                      ///
                                      ///
                                      ///
                                      defaultTranslation(
                                          languageName:
                                              provider.foundLanguages[index]
                                                  ['language_name'],
                                          context: context);
                                      settingsProvider
                                          .fetchOpenedTranslatorSurah(
                                              context: context);
                                      provider.rabbanaDuaTranslationFetch();

                                      ///sending language translations as default for the 1st time for evey language ENDED here*****************

                                      // setState(() {});
                                      ///sending selected language to juzProvider
                                      Provider.of<JuzProvider>(context,
                                              listen: false)
                                          .updateLanguage(
                                              value: Provider.of<Data>(context,
                                                      listen: false)
                                                  .translationName);
                                      Provider.of<JuzProvider>(context,
                                              listen: false)
                                          .juzTranslationFetch();

                                      ///sending selected language to juzProvider END***
                                      ///
                                      ///re-fetching favourites quran verse after the user has selected a new language
                                      ///when i re-fetching its basically to update the screen instantly.
                                      provider.favouritesTranslationFetch();

                                      ///[assignTafsirOnLanguageChange()] assigning the tafsir data on language change here
                                      settingsProvider
                                          .assignTafsirOnLanguageChange();

                                      ///
                                      Navigator.pop(context);

                                      ///
                                    },
                                  ),
                                ),
                              ),
                            ),
                            // ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
