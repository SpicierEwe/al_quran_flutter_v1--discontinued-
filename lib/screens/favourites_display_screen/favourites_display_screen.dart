import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/hive_model/bookmarks_hive_model.dart';
import 'package:al_quran/hive_model/boxes.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/favourites_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:al_quran/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FavouritesDisplayScreen extends StatefulWidget {
  const FavouritesDisplayScreen({Key? key}) : super(key: key);

  @override
  _FavouritesDisplayScreenState createState() =>
      _FavouritesDisplayScreenState();
}

class _FavouritesDisplayScreenState extends State<FavouritesDisplayScreen> {
  @override
  void initState() {
    ///executing fetching of arabic 4 Translated verses here
    Provider.of<FavouritesProvider>(context, listen: false)
        .fetchFavouritesQuranVerse();
    Provider.of<Data>(context, listen: false).favouritesTranslationFetch();

    ///
    super.initState();
  }

  @override
  void dispose() {
    // Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var favouritesProvider = Provider.of<FavouritesProvider>(context);
    var dataProvider = Provider.of<Data>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        backgroundColor: themeProvider.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text("Favourites"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ));
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        body: ValueListenableBuilder<Box<BookmarksHiveModel>>(
          valueListenable: Boxes().getFavourites().listenable(),
          builder: (context, box, _) {
            final favourites = box.values.toList().cast<BookmarksHiveModel>();

            if (favourites.isEmpty) {
              return LayoutBuilder(builder: (context, constraints) {
                var cmh = constraints.maxHeight;
                var cmw = constraints.maxWidth;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: cmh * 0.05,
                    ),
                    Column(
                      children: [
                        Text(
                          'No Favourite verses Yet !',
                          style: GoogleFonts.roboto(
                              color: const Color(0xff223C63),
                              fontSize: cmh * 0.023),
                        ),
                        SizedBox(
                          height: cmh * 0.015,
                        ),
                        const Text(
                          'To " add " verses to favourites click on a " verse "\n and click on " add to favourite " option. ',
                          style: TextStyle(color: Color(0xff223C63)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                );
              });
            }
            if (dataProvider.favouritesTranslatedVerses.isEmpty ||
                favouritesProvider.favouritesQuranVerses.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueGrey,
                ),
              );
            }
            return ScrollConfiguration(
              behavior: RemoveListViewGlow(),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  var cmh = constraints.maxHeight;
                  var cmw = constraints.maxWidth;
                  return Theme(
                    data: ThemeData(
                      highlightColor: themeProvider.scrollBarColor,
                    ),
                    child: Scrollbar(
                      radius: Radius.circular(cmh * 0.01),
                      thickness: cmw * 0.005,
                      scrollbarOrientation: ScrollbarOrientation.left,
                      child: ListView.builder(
                        itemCount: favourites.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    color: themeProvider
                                        .favouritesVerseContainerDividerColor,
                                    height: cmh * 0.01,
                                  ),

                                  ///showing meta data about the favourite verse here
                                  Container(
                                    decoration: BoxDecoration(
                                      color: themeProvider
                                          .favouritesVerseContainerDividerColor,
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.only(
                                        top: cmh * 0.01, bottom: cmh * 0.01),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          favourites[index].surahName,
                                          style: GoogleFonts.roboto(
                                              color: themeProvider
                                                  .favouritesVerseInfoColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: cmw * 0.017,
                                              right: cmw * 0.017),
                                          height: cmh * 0.03,
                                          width: cmw * 0.005,
                                          decoration: BoxDecoration(
                                              color: themeProvider
                                                  .favouritesVerseInfoDividerColor,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                      cmh * 0.01),
                                                  topLeft: Radius.circular(
                                                      cmh * 0.01))),
                                        ),
                                        Text(
                                          favourites[index]
                                              .surahNumber
                                              .toString(),
                                          style: GoogleFonts.roboto(
                                              color: themeProvider
                                                  .favouritesVerseInfoColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          ' : ',
                                          style: GoogleFonts.roboto(
                                              color: themeProvider
                                                  .favouritesVerseInfoColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          favourites[index]
                                              .verseNumber
                                              .toString(),
                                          style: GoogleFonts.roboto(
                                              color: themeProvider
                                                  .favouritesVerseInfoColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    padding: EdgeInsets.only(
                                        top: cmh * 0.015,
                                        right: cmh * 0.015,
                                        left: cmh * 0.041,
                                        bottom: index == favourites.length - 1
                                            ? cmh * 0.027
                                            : 0.0),

                                    ///verse container color
                                    color: index.isEven
                                        ? themeProvider.evenContainerColor
                                        : themeProvider.oddContainerColor,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Directionality(
                                          textDirection: TextDirection.rtl,

                                          ///
                                          ///showing the favourite quranic verse (arabic) here
                                          ///
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: cmh * 0.011),
                                            child: Text.rich(
                                              TextSpan(
                                                //todo*******************************************************************
                                                children: [
                                                  TextSpan(
                                                    text: favouritesProvider
                                                            .favouritesQuranVerses[
                                                        index],
                                                    style: TextStyle(
                                                      fontSize: settingsProvider
                                                                  .selectedArabicType ==
                                                              'Indo - Pak'
                                                          ? settingsProvider
                                                                  .arabicFontSize
                                                                  .sp -
                                                              5.5
                                                          : settingsProvider
                                                                  .arabicFontSize
                                                                  .sp -
                                                              5,
                                                      fontFamily: settingsProvider
                                                                  .selectedArabicType ==
                                                              'Indo - Pak'

                                                          // ? 'me-quran'
                                                          ? settingsProvider
                                                              .indoPakScriptFont
                                                          : settingsProvider
                                                              .uthmaniScriptFont,
                                                      color: themeProvider
                                                          .arabicFontColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: cmh * 0.025,
                                        ),

                                        ///
                                        /// verse translation shown here
                                        Directionality(
                                            textDirection: favouritesProvider
                                                .changeDirectionalityAccordingToFavouriteVerseTranslationLanguage(
                                                    favouriteVerseTranslationLanguage:
                                                        settingsProvider
                                                            .selectedLanguage
                                                    // favourites[index]
                                                    //     .translationLanguage
                                                    ),
                                            child: Text(
                                              dataProvider
                                                      .favouritesTranslatedVerses[
                                                  index],

                                              ///verse translation text styling here
                                              style: favouritesProvider
                                                  .changeFavouriteVerseTranslationTxtStyleAccordingToLanguage(
                                                      cmh: cmh,
                                                      context: context,
                                                      selectedLanguage:
                                                          settingsProvider
                                                              .selectedLanguage,
                                                      // favourites[index]
                                                      //     .translationLanguage,
                                                      translationFontSize:
                                                          settingsProvider
                                                              .translationFontSize
                                                              .sp),
                                            )),

                                        SizedBox(
                                          height: cmh * 0.045,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              ///numbering displayed here
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: cmh * 0.0075,
                                      top: cmh * 0.015,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: themeProvider
                                                  .favouritesEnglishNumberBorderColor),
                                          borderRadius: BorderRadius.circular(
                                            cmh * 0.023,
                                          )),
                                      child: CircleAvatar(
                                        // backgroundColor: Colors.blueGrey.shade50,
                                        backgroundColor: Colors.transparent,
                                        radius: cmh * 0.02,
                                        child: Text(
                                          (index + 1).toString(),
                                          style: TextStyle(
                                            fontSize: cmh * 0.019,
                                            fontWeight: FontWeight.bold,
                                            color: themeProvider
                                                .favouritesEnglishNumberColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                      // minWidth: 0,
                                      // padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                /// delete confirmation popup is here
                                                Container(
                                                    color: themeProvider
                                                        .arabicChangeRecitationStylePopUpContainerColor,
                                                    height: cmh * 0.3,
                                                    width: cmw * 0.7,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Remove From Favourites ?',
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: cmh *
                                                                      0.019),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: cmh *
                                                                      0.01,
                                                                  bottom: cmh *
                                                                      0.01),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                favourites[
                                                                        index]
                                                                    .surahName,
                                                                style: GoogleFonts.roboto(
                                                                    color: const Color(
                                                                        0xff223C63),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(
                                                                    left: cmw *
                                                                        0.017,
                                                                    right: cmw *
                                                                        0.017),
                                                                height:
                                                                    cmh * 0.03,
                                                                width:
                                                                    cmw * 0.005,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius: BorderRadius.only(
                                                                        topRight:
                                                                            Radius.circular(cmh *
                                                                                0.01),
                                                                        topLeft:
                                                                            Radius.circular(cmh *
                                                                                0.01))),
                                                              ),
                                                              Text(
                                                                favourites[
                                                                        index]
                                                                    .surahNumber
                                                                    .toString(),
                                                                style: GoogleFonts.roboto(
                                                                    color: const Color(
                                                                        0xff223C63),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                ' : ',
                                                                style: GoogleFonts.roboto(
                                                                    color: const Color(
                                                                        0xff223C63),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                favourites[
                                                                        index]
                                                                    .verseNumber
                                                                    .toString(),
                                                                style: GoogleFonts.roboto(
                                                                    color: const Color(
                                                                        0xff223C63),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            TextButton(
                                                                // color:
                                                                //     Colors.red,
                                                                onPressed: () {
                                                                  favouritesProvider
                                                                      .deleteFavourite(
                                                                          index,
                                                                          context);
                                                                },
                                                                child: Text(
                                                                  'YES',
                                                                  style: GoogleFonts
                                                                      .roboto(
                                                                          color:
                                                                              Colors.white),
                                                                )),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'NO'))
                                                          ],
                                                        )
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: cmw * 0.019),
                                        child: const Icon(
                                          Icons.remove_circle_rounded,
                                          color: Colors.red,
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
