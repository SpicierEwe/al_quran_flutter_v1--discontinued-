import 'package:al_quran/Navigators/navigator_controller_surah_names_screen.dart';
import 'package:al_quran/components/default_transaltion.dart';
import 'package:al_quran/components/make_values_permanet_class/make_translators_permanent.dart';
import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({Key? key}) : super(key: key);

  @override
  _SelectLanguageScreenState createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Data>(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var mq = MediaQuery.of(context).size;
    return Container(
      color: const Color(0xffFEECE3),
      child: SafeArea(
        child: ScrollConfiguration(
          behavior: RemoveListViewGlow(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
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
                    left: mq.width * 0.015,
                    right: mq.width * 0.015,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      provider.searchedQuery = value;
                      provider.searchLanguage(query: value.toString());
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search language....'),
                  ),
                ),
              ),
              backgroundColor: Color(0xffFEECE3),
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
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            height: cmh * 0.15,
                            decoration: const BoxDecoration(
                              color: Color(0xffFEECE3),
                            ),
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
                                            // color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: cmh * 0.04),
                                      ),
                                      Text(
                                        'your language',
                                        style: GoogleFonts.josefinSans(
                                          // fontWeight: FontWeight.bold,
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
                          Container(
                            height: cmh * 0.85,
                            color: const Color(0xffFEECE3),
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
                                      color: Colors.white,
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

                                        ///showing language name here
                                        provider.foundLanguages[index]
                                        ['local_language_name'] ==
                                            ''
                                            ? provider.foundLanguages[index]
                                        ['language_name']
                                            .toString()
                                            : provider.foundLanguages[index]
                                        ['local_language_name'],

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

                                      ///assigning default tafsirs
                                      settingsProvider
                                          .assignTafsirOnLanguageChange();

                                      ///sending language translations as default for the 1st time for evey language END*****************
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const NavigatorControllerSurahNamesScreen(),
                                          ));
                                    },
                                  ),
                                ),
                              ),
                            ),
                            // ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
