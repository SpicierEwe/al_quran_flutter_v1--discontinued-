import 'dart:convert';
import 'dart:io';
import 'package:al_quran/components/quran_meta_data/quran_meta_data.dart';
import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:html/parser.dart' show parse;
import 'package:uuid/uuid.dart';
import '../components/quran_db_class/quran_db_class.dart';
import '../components/quran_db_class/quran_indopak_script_class.dart';
import '../components/tafsirs/tafsir_meta_data.dart';
import '../providers/data_provider.dart';
import '../providers/theme_provider.dart';

class DisplayTafsirScreen extends StatefulWidget {
  final surahIndex;
  final verseNumber;

  const DisplayTafsirScreen({Key? key, this.surahIndex, this.verseNumber})
      : super(key: key);

  @override
  _DisplayTafsirScreenState createState() => _DisplayTafsirScreenState();
}

class _DisplayTafsirScreenState extends State<DisplayTafsirScreen> {
  @override
  void initState() {
    Provider.of<Data>(context, listen: false).displayTafsir(
        verseNumber: widget.verseNumber,
        surahNumber: widget.surahIndex,
        arabicType: Provider.of<SettingsProvider>(context, listen: false)
            .selectedArabicType);

    Provider.of<SettingsProvider>(context, listen: false).getTafsirs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dataProvider = Provider.of<Data>(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    var mq = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Container(
        color: themeProvider.darkTheme ? Colors.black : Colors.white70,
        child: SafeArea(
          child: SizedBox(
            height: mq.height -
                (AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top),
            width: mq.width,
            child: Scaffold(
              backgroundColor:
                  themeProvider.darkTheme ? Colors.black : Colors.white70,
              body: LayoutBuilder(builder: (context, constraints) {
                var cmh = constraints.maxHeight;
                var cmw = constraints.maxWidth;
                return ScrollConfiguration(
                  behavior: RemoveListViewGlow(),
                  child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              right: cmh * 0.005,
                              left: cmh * 0.007,
                              top: cmh * 0.01),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  /// tafsir name and author
                                  Row(
                                    children: [
                                      /// switch tafsir button
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          elevation: 2,
                                          minimumSize: Size.zero,
                                          padding: EdgeInsets.zero,
                                          backgroundColor:
                                              themeProvider.lastReadIconColor,
                                        ),
                                        onPressed: () {
                                          /// SHOW MODAL BOTTOM SHEET
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => Container(
                                              color: themeProvider
                                                  .settingsFontSizeChangeModalColor,
                                              child: ListView.separated(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: cmw * 0.035,
                                                  vertical: cmh * 0.025,
                                                ),
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const Divider(),
                                                itemCount: settingsProvider
                                                    .tafsirs.length,
                                                itemBuilder: (context, index) =>
                                                    TextButton(
                                                  onPressed: () async {
                                                    /// change and display temporary tafsir of the selected tafsir
                                                    displayTemporaryTafsir(
                                                        surahNumber:
                                                            widget.surahIndex,
                                                        verseNumber: int.parse(
                                                            widget.verseNumber
                                                                .toString()),
                                                        arabicType: settingsProvider
                                                            .selectedArabicType,
                                                        tafsirId:
                                                            settingsProvider
                                                                    .tafsirs[
                                                                index]['id']);

                                                    Navigator.pop(context);
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Text(
                                                        settingsProvider
                                                            .tafsirs[index]
                                                                ['name']
                                                            .toString(),
                                                        style: GoogleFonts.lato(
                                                            color: const Color(
                                                                0xff333333),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13.sp),
                                                      ),
                                                      SizedBox(
                                                        height: cmh * 0.007,
                                                      ),
                                                      Text(
                                                        settingsProvider
                                                            .tafsirs[index]
                                                                ['author_name']
                                                            .toString(),
                                                        style: GoogleFonts.lato(
                                                            color: themeProvider
                                                                    .darkTheme
                                                                ? const Color(
                                                                    0xff555555)
                                                                : Colors
                                                                    .blueGrey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 10.5.sp),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: cmh * 0.015,
                                                  vertical: cmh * 0.009),
                                              color: Colors.white,
                                              child: Column(
                                                children: [
                                                  Text(
                                                      'Tafsir Name - ${tempTafsirName ?? settingsProvider.selectedTafsirName}',
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xff333333),
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      textAlign:
                                                          TextAlign.left),
                                                  SizedBox(
                                                    height: cmh * 0.003,
                                                  ),
                                                  Text(
                                                    'Author Name - ${tempTafsirAuthorName ?? dataProvider.tafsirAuthorName}',
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xff555555),
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                              color: Colors.white,
                                              size: cmh * 0.035,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  ///
                                  /// THE TAFSIR IS SHOWN HERE
                                  ///
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: cmh * 0.015,
                                        left: cmh * 0.025,
                                        top: cmh * 0.017),
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,

                                      ///tafsir arabic verse is show here
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text: dataProvider
                                                    .tafsirArabicVerse,
                                                style: TextStyle(
                                                  color: themeProvider
                                                      .arabicFontColor,
                                                  fontSize: settingsProvider
                                                      .arabicFontSize,
                                                  fontFamily: settingsProvider
                                                              .selectedArabicType ==
                                                          'Indo - Pak'
                                                      ? settingsProvider
                                                          .indoPakScriptFont
                                                      : settingsProvider
                                                          .uthmaniScriptFont,
                                                )),
                                            // TextSpan(
                                            //     text: ' ' +
                                            //         dataProvider
                                            //             .getVerseEndSymbol(
                                            //                 int.parse(widget
                                            //                     .verseNumber))),
                                          ],
                                        ),
                                        style: TextStyle(
                                          color: themeProvider.arabicFontColor,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),

                                  ///display quran reference here
                                  SizedBox(
                                    height: cmh * 0.013,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: cmw * 0.023,
                                    ),
                                    child: Text(
                                      "${QuranMetaData().quranSurah[widget.surahIndex][5].toString()} | ${widget.surahIndex.toString()} : ${widget.verseNumber.toString()}",
                                      style: TextStyle(
                                          color: themeProvider
                                              .settingsItemTitleFontColor),
                                    ),
                                  ),
                                  Directionality(
                                    textDirection: settingsProvider
                                        .changeDirectionalityAccordingToLanguage(),
                                    child: Html(
                                      data: tempVerseTafsir ??
                                          dataProvider.verseTafsir.toString(),
                                      style: {
                                        'html': settingsProvider
                                            .changeTafsirTextStyleAccordingToLanguage(
                                          cmh: cmh,
                                          context: context,
                                        ),

                                        // 'html': Style(backgroundColor: Colors.white12 ,),
                                        'h2': Style(
                                          color: themeProvider
                                              .settingsItemTitleFontColor,
                                        ),
                                        'div': Style(
                                            direction: TextDirection.rtl,
                                            fontFamily: settingsProvider
                                                        .selectedArabicType ==
                                                    'Indo - Pak'
                                                ? settingsProvider
                                                    .indoPakScriptFont
                                                : settingsProvider
                                                    .uthmaniScriptFont,
                                            textAlign: TextAlign.right,
                                            fontSize: FontSize(settingsProvider
                                                    .arabicFontSize -
                                                2.3)),
                                        'p': settingsProvider
                                            .changeTafsirTextStyleAccordingToLanguage(
                                                cmh: cmh, context: context)
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: cmh * 0.03,
                                  ),
                                ],
                              ),

                              ///this is the tafsir copy option
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    margin: EdgeInsets.only(right: cmw * 0.035),
                                    child: GestureDetector(
                                      child: Icon(
                                        Icons.download,
                                        color: themeProvider.lastReadIconColor,
                                      ),
                                      onTap: () async {
                                        var uuid = const Uuid();
                                        final status =
                                            await Permission.storage.request();
                                        // print(status);
                                        if (await Permission.storage
                                            .request()
                                            .isGranted) {
                                          // print('permission granted');
                                          var data = parse(
                                                  "Tafsir Name - ${tempTafsirName ?? settingsProvider.selectedTafsirName}\nAuthor Name - ${tempTafsirAuthorName ?? dataProvider.tafsirAuthorName}\n\n${tempTafsirArabicVerse ?? dataProvider.tafsirArabicVerse}\n${QuranMetaData().quranSurah[widget.surahIndex][5].toString()} | ${widget.surahIndex.toString()} : ${widget.verseNumber.toString()}\n\n${tempVerseTafsir ?? dataProvider.verseTafsir.toString()}")
                                              .documentElement!
                                              .text;
                                          String fileName =
                                              "${QuranMetaData().quranSurah[widget.surahIndex][5].toString()} verse - ${widget.verseNumber.toString()} tafsir ${uuid.v4().toString()}";
                                          var file = File(
                                              '/storage/emulated/0/Download/$fileName.txt');
                                          await file
                                              .writeAsString(data.toString());

                                          ///
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content: Text(
                                                    'Tafsir saved in Downloads folder',
                                                    style: TextStyle(
                                                        fontSize: 10.5.sp),
                                                    textAlign: TextAlign.center,
                                                  )));
                                        }
                                        if (await Permission.storage.isDenied) {
                                          // print(
                                          //     'Permission denied. Show a dialog and again ask for the permission');
                                          Permission.storage.request();
                                          if (status ==
                                              PermissionStatus
                                                  .permanentlyDenied) {
                                            // print('Take the user to the settings page.');
                                            await openAppSettings();
                                          }
                                        }
                                      },
                                    ),
                                  )),
                            ],
                          ),
                        );
                      }),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  /// these functions manage the displaying of the tafsir when the user switches the tafsir from within this screen
  /// why fetch and displaying temporarily? so that the selected tafsir is temporarily displayed and the main
  /// selected tafsir in settings in unchanged.
  ///
  /// ( temporaryTafsir is just a quick way of seeing what other tafsir say about the verse without changing the global tafsir)
  ///

  var tempVerseTafsir;

  var tempTafsirArabicVerse;

  var tempTafsirAuthorName;
  var tempTafsirName;

  displayTemporaryTafsir(
      {required int surahNumber,
      required int verseNumber,
      required String arabicType,
      required int tafsirId}) async {
    final prefs = await SharedPreferences.getInstance();

    tempTafsirAuthorName = tafsirs_meta_data
        .where((e) => e['id'] == tafsirId)
        .map((e) => e['author_name'])
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');

    tempTafsirName = tafsirs_meta_data
        .where((e) => e['id'] == tafsirId)
        .map((e) => e['name'])
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');

    ///getting arabic verse here
    tempTafsirArabicVerse = arabicType == "Indo - Pak"
        ? Quran_indo_pak_script_DB()
            .quran_indo_pak_script
            .where((e) =>
                e['sura'] == surahNumber &&
                e['aya'] == int.parse(verseNumber.toString()))
            .map((e) => e['text'])
            .toString()
            .replaceAll('(', '')
            .replaceAll(')', '')
        : QuranDb()
            .fullQuran
            .where((e) =>
                e['sura'] == surahNumber &&
                e['aya'] == int.parse(verseNumber.toString()))
            .map((e) => e['text'])
            .toString()
            .replaceAll('(', '')
            .replaceAll(')', '');

    ///getting verse tafsir here
    final String response = await rootBundle.loadString(
        'db/tafsirs/${QuranMetaData().quranSurah[surahNumber][5]}.json');
    final data = await json.decode(response);

    var incomingTafsir = data
        .where((e) =>
            e['sura'] == surahNumber &&
            e['verse'] == int.parse(verseNumber.toString()))
        .map((e) => e['tafsirs']
            .where((e) => e['resource_id'] == tafsirId)
            .map((e) => e['text']))
        .toString()
        .replaceFirst('((', '');
    var formattedTafsir =
        incomingTafsir.substring(0, incomingTafsir.length - 2);
    if (formattedTafsir != "") {
      tempVerseTafsir = formattedTafsir;
    } else {
      tempVerseTafsir = '<h2>Sorry we don\'t have tafsir for this ayah</h2>';
    }
    setState(() {});
  }
}
