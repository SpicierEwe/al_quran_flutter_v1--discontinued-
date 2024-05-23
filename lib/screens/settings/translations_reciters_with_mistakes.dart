import 'package:al_quran/components/make_values_permanet_class/make_reciter_permanent.dart';
import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/components/settings_components/reciter_names_class.dart';
import 'package:al_quran/providers/audio_provider.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TranslationsRecitersWithMistakes extends StatefulWidget {
  const TranslationsRecitersWithMistakes({Key? key}) : super(key: key);

  @override
  _TranslationsRecitersWithMistakesState createState() =>
      _TranslationsRecitersWithMistakesState();
}

class _TranslationsRecitersWithMistakesState
    extends State<TranslationsRecitersWithMistakes> {
  List translations = Reciters().translationsWithMistakes;

  @override
  Widget build(BuildContext context) {
    var dataProvider = Provider.of<Data>(context, listen: true);
    var settingsProvider = Provider.of<SettingsProvider>(context, listen: true);
    var audioProvider = Provider.of<AudioProvider>(context, listen: true);
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    var mq = MediaQuery.of(context).size;
    return ScrollConfiguration(
      behavior: RemoveListViewGlow(),
      child: Scaffold(
        /// bottom music nav bar

        backgroundColor: themeProvider.reciterScaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          height: mq.height -
              (AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top),
          child: LayoutBuilder(
            builder: (context, constraints) {
              var cmh = constraints.maxHeight;
              var cmw = constraints.maxWidth;
              return Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.center,
                          // color: Colors.red,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Caution :',
                                style: TextStyle(color: Colors.red),
                              ),
                              SizedBox(
                                height: cmh * 0.003,
                              ),
                              Text(
                                'The Mistakes are only in Arabic Recitation',
                                style: TextStyle(
                                    fontSize: cmh * 0.017,
                                    color: Provider.of<ThemeProvider>(context)
                                        .reciterSubInfoTitleColor),
                              ),
                              Text(
                                'These Translations have mistakes in mentioned verses.',
                                style: TextStyle(
                                    fontSize: cmh * 0.017,
                                    color: Provider.of<ThemeProvider>(context)
                                        .reciterSubInfoTitleColor),
                              ),
                              Text(
                                'This warning is just to make sure you keep in mind while listening.',
                                style: TextStyle(
                                    fontSize: cmh * 0.017,
                                    color: Provider.of<ThemeProvider>(context)
                                        .reciterSubInfoTitleColor),
                              ),
                            ],
                          ))),
                  Expanded(
                    flex: 13,
                    child: GridView.builder(
                      itemCount: translations.length,
                      padding: EdgeInsets.all(cmh * 0.015),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4 / 10,
                          crossAxisSpacing: cmw * 0.03,
                          mainAxisSpacing: cmh * 0.015),
                      itemBuilder: (context, index) {
                        return TextButton(
                          // padding: const EdgeInsets.all(0),

                          ///on pressed is here
                          onPressed: () {
                            audioProvider.assignRecitationStyle(
                                style: translations[index]['recitation_style_1']
                                    .toString());

                            ///sending reciter short name and name to setting provider to update the reciter showing in settings
                            audioProvider.assignReciterName(
                                selectedReciterShortName: translations[index]
                                    ['short_name'],

                                ///reciter_name is (full name)
                                selectedReciterFullName: translations[index]
                                    ['reciter_name']);

                            audioProvider.switchToSelectedRecitationStyle(
                                context: context);

                            ///saving reciter to permanent file
                            ReciterFileStorage().writeReciterName(
                                fileNameToSaveIn: 'reciter',
                                whatToSave: translations[index]['short_name']
                                    .toString());
                            ReciterFileStorage().writeRecitationStyle(
                                fileNameToSaveIn: 'recitationStyle',
                                whatToSave: translations[index]
                                        ['recitation_style_1']
                                    .toString());

                            // audioProvider.previewStop();
                            Navigator.pop(context);
                          },
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  ///reciter image is here
                                  Expanded(
                                      child: Container(
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: themeProvider
                                              .reciterImageShadowColor,
                                          blurRadius: 17,
                                          spreadRadius: -2)
                                    ]),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(cmh * 0.03),
                                      child: Image.asset(
                                        translations[index]['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )),
                                  SizedBox(
                                    height: cmh * 0.005,
                                  ),
                                  Expanded(
                                      child: Column(
                                    children: [
                                      SizedBox(
                                        height: cmh * 0.03,
                                      ),
                                      Text(
                                        translations[index]['reciter_name']
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                themeProvider.reciterNamesColor,
                                            fontSize: cmh * 0.021),
                                        textAlign: TextAlign.center,
                                      ),
                                      const Divider(),
                                      Text(
                                        "${'( ' + translations[index]['language']} )",
                                        style: TextStyle(
                                            color: Provider.of<ThemeProvider>(
                                                    context)
                                                .reciterSubInfoTitleColor),
                                      ),

                                      ///translations info
                                      if (translations[index]['born'] != '')
                                        reciterInfo(
                                            cmh: cmh,
                                            cmw: cmw,
                                            index: index,
                                            title: 'Born',
                                            info: 'born'),
                                      if (translations[index]['birth_city'] !=
                                          '')
                                        reciterInfo(
                                            cmh: cmh,
                                            cmw: cmw,
                                            index: index,
                                            title: 'Birth City',
                                            info: 'birth_city'),
                                      if (translations[index]['died'] != '')
                                        reciterInfo(
                                            cmh: cmh,
                                            cmw: cmw,
                                            index: index,
                                            title: 'Death',
                                            info: 'died'),
                                      if (translations[index]['death_city'] !=
                                          '')
                                        reciterInfo(
                                            cmh: cmh,
                                            cmw: cmw,
                                            index: index,
                                            title: 'Death City',
                                            info: 'death_city'),

                                      ///only showing for alafasy
                                      if (translations[index]['genre'] != '')
                                        reciterInfo(
                                            cmh: cmh,
                                            cmw: cmw,
                                            index: index,
                                            title: 'Genre',
                                            info: 'genre'),

                                      ///only showing for sudais
                                      if (translations[index]['occupation'] !=
                                          '')
                                        reciterInfo(
                                            cmh: cmh,
                                            cmw: cmw,
                                            index: index,
                                            title: 'Occupation',
                                            info: 'occupation'),

                                      ///showing mistakes here
                                      mistakesDisplayWidget(
                                          title: 'Mistakes',
                                          cmw: cmw,
                                          cmh: cmh,
                                          index: index)
                                    ],
                                  )),
                                ],
                              ),

                              /// preview audio  button
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget reciterInfo({index, cmh, cmw, title, info}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '$title :',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: cmh * 0.017,
              color:
                  Provider.of<ThemeProvider>(context).reciterSubInfoTitleColor),
        ),
        SizedBox(
          width: cmw * 0.03,
        ),
        Text(
          translations[index]['$info'],
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
              fontSize: cmh * 0.017),
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: cmh * 0.007,
        )
      ],
    );
  }

  Widget mistakesDisplayWidget({index, cmh, cmw, title}) {
    return Expanded(
      child: PrimaryScrollController(
        controller: ScrollController(),
        child: Scrollbar(
          isAlwaysShown: true,
          thickness: cmw * 0.01,
          child: ListView.builder(
            physics: translations[index]['reciter_name'] != 'Minshawy'
                ? const NeverScrollableScrollPhysics()
                : null,
            itemCount: translations[index]['mistakes'].length,
            itemBuilder: (context, index2) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ///
                if (translations[index]['reciter_name'] == 'Minshawy' &&
                    index2 == 0)
                  const Text.rich(
                    TextSpan(children: [
                      TextSpan(text: 'Only in'),
                      TextSpan(
                          text: ' Mujawwad',
                          style: TextStyle(color: Colors.red)),
                    ]),
                    textAlign: TextAlign.center,
                  ),
                if (index2 == 0)
                  Text(
                    '$title :',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: cmh * 0.017,
                        color: Colors.red
                        // color: Provider.of<ThemeProvider>(context)
                        //     .reciterSubInfoTitleColor
                        ),
                  ),
                if (index2 == 0)
                  SizedBox(
                    height: cmh * 0.005,
                  ),
                SizedBox(
                  width: cmw * 0.03,
                ),

                ///
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Surah : ',
                      style: TextStyle(
                          fontSize: cmh * 0.017,
                          color: Provider.of<ThemeProvider>(context)
                              .reciterSubInfoTitleColor),
                    )),
                    Expanded(
                      child: Text(
                        translations[index]['mistakes'][index2]['surah_number']
                            .toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                            fontSize: cmh * 0.017),
                        // textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      ' verse : ',
                      style: TextStyle(
                          fontSize: cmh * 0.017,
                          color: Provider.of<ThemeProvider>(context)
                              .reciterSubInfoTitleColor),
                    )),
                    Expanded(
                      child: Text(
                        translations[index]['mistakes'][index2]['verse_number']
                            .toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                            fontSize: cmh * 0.017),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: cmh * 0.007,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
