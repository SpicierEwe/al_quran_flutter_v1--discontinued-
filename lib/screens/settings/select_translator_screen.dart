import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/juz_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SelectTranslator extends StatefulWidget {
  const SelectTranslator({Key? key}) : super(key: key);

  @override
  _SelectTranslatorState createState() => _SelectTranslatorState();
}

class _SelectTranslatorState extends State<SelectTranslator> {
  @override
  void initState() {
    //firing search translators function here
    // WidgetsBinding.instance!.addPostFrameCallback(
    //   (_) {
    Provider.of<SettingsProvider>(context, listen: false).searchTranslators();

    // TODO: implement initState
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
          title: const Text('Select Translator'),
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
                            '${settingsProvider.translators[0]['total_translations']}  Translators available',
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
                          itemCount: settingsProvider
                              .translators[0]['translations'].length,
                          itemBuilder: (context, index) {
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
                                  onPressed: () {
                                    /*
                                    * writing the selected translation Name and Translator Name to permanent storage
                                    *  */
                                    settingsProvider
                                        .writeTranslatorNameAndTranslationName(
                                            translatorName: settingsProvider
                                                .translators[0]['translations']
                                                    [index]
                                                    ['translation_${(index + 1).toString()}']
                                                    ['name']
                                                .toString(),
                                            translationName: settingsProvider
                                                .translators[0]['translations']
                                                    [index]
                                                    ['translation_${(index + 1).toString()}']
                                                    ['translation_Name']
                                                .toString());

                                    /*
                                    * writing the selected translation Name and Translator Name to permanent storage ENDED*/
                                    /*
                                     ///END****************
                                    *  */

                                    ///
                                    ///
                                    ///

                                    ///translationName is used to fetch the translation iin fetchTranslationFunction()
                                    dataProvider.translationName = settingsProvider
                                        .translators[0]['translations'][index][
                                            'translation_${(index + 1).toString()}']
                                            ['translation_Name']
                                        .toString();

                                    ///
                                    /// AssignTranslatorName func assigns the new selected translator from the settings
                                    settingsProvider.assignTranslatorName(
                                        translatorName: settingsProvider
                                            .translators[0]['translations']
                                                [index][
                                                'translation_${(index + 1).toString()}']
                                                ['name']
                                            .toString());

                                    ///

                                    ///here we are fetching the surah which is opened by the user if no surah is opened by the user nothing will be fetched
                                    settingsProvider.fetchOpenedTranslatorSurah(
                                        context: context);

                                    ///re-fetching rabbana duas translation here after the use selected different translator
                                    dataProvider.rabbanaDuaTranslationFetch();

                                    ///re-fetching favourites verses translation here after the use selected different translator
                                    dataProvider.favouritesTranslationFetch();

                                    ///updating translation name for juz provider
                                    Provider.of<JuzProvider>(context,
                                            listen: false)
                                        .updateLanguage(
                                            value: Provider.of<Data>(context,
                                                    listen: false)
                                                .translationName);
                                    Navigator.pop(context);
                                  },

                                  ///onPressed ENDED************
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        settingsProvider.translators[0]
                                                ['translations'][index][
                                                'translation_${(index + 1).toString()}']
                                                ['name']
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
                                        settingsProvider.translators[0]
                                                ['translations'][index][
                                                'translation_${(index + 1).toString()}']
                                                ['translator']
                                            .toString(),
                                        style: GoogleFonts.lato(
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: cmh * 0.020),
                                      ),
                                    ],
                                  ),
                                ),
                                if (index !=
                                    settingsProvider
                                            .translators[0]['translations']
                                            .length -
                                        1)
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

// onPressed: () {
// dataProvider.translationName = settingsProvider
//     .translators[0]['translations'][index][
// 'translation_${(index + 1).toString()}']
// ['translation_name']
//     .toString();
//
// ///
// settingsProvider.assignTranslatorName(
// translatorName: settingsProvider
//     .translators[0]['translations'][index]
// [
// 'translation_${(index + 1).toString()}']
// ['translator']
//     .toString());
// },
///
///  Text(
//                                     settingsProvider.translators[0]
//                                             ['translations'][index][
//                                             'translation_${(index + 1).toString()}']
//                                             ['name']
//                                         .toString(),
//                                     textScaleFactor: 1.5,
//                                     style: GoogleFonts.lato(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: cmh * 0.017),
//                                   ),
// /   Text(
//                                           settingsProvider.translators[0]
//                                                   ['translations'][index][
//                                                   'translation_${(index + 1).toString()}']
//                                                   ['translator']
//                                               .toString(),
//                                           style: GoogleFonts.lato(
//                                               color: Colors.blueGrey,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: cmh * 0.020),
//                                         ),
