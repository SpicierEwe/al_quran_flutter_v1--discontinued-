import 'package:al_quran/components/make_values_permanet_class/make_reciter_permanent.dart';
import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/components/settings_components/reciter_names_class.dart';
import 'package:al_quran/providers/audio_provider.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/bottom_music_bar.dart';

class TranslationsReciterScreen extends StatefulWidget {
  const TranslationsReciterScreen({Key? key}) : super(key: key);

  @override
  _TranslationsReciterScreenState createState() =>
      _TranslationsReciterScreenState();
}

class _TranslationsReciterScreenState extends State<TranslationsReciterScreen> {
  List translations = Reciters().translations;

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
        body: LayoutBuilder(
          builder: (context, constraints) {
            var cmh = constraints.maxHeight;
            var cmw = constraints.maxWidth;
            return GridView.builder(
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
                        whatToSave:
                            translations[index]['short_name'].toString());
                    ReciterFileStorage().writeRecitationStyle(
                        fileNameToSaveIn: 'recitationStyle',
                        whatToSave: translations[index]['recitation_style_1']
                            .toString());

                    Navigator.pop(context);
                  },
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          ///reciter image is here
                          Expanded(
                              child: Container(
                            width: cmw,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: themeProvider.reciterImageShadowColor,
                                  blurRadius: 17,
                                  spreadRadius: -2)
                            ]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(cmh * 0.03),
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
                                translations[index]['reciter_name'].toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: themeProvider.reciterNamesColor,
                                    fontSize: cmh * 0.021),
                                textAlign: TextAlign.center,
                              ),
                              const Divider(),
                              Text(
                                "${'( ' + translations[index]['language']} )",
                                style: TextStyle(
                                    color: Provider.of<ThemeProvider>(context)
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
                              if (translations[index]['birth_city'] != '')
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
                              if (translations[index]['death_city'] != '')
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
                              if (translations[index]['occupation'] != '')
                                reciterInfo(
                                    cmh: cmh,
                                    cmw: cmw,
                                    index: index,
                                    title: 'Occupation',
                                    info: 'occupation'),
                            ],
                          )),
                        ],
                      ),

                      /// preview audio  button
                    ],
                  ),
                );
              },
            );
          },
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
}
