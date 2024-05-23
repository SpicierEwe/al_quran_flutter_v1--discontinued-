import 'package:al_quran/hive_model/bookmarks_hive_model.dart';
import 'package:al_quran/hive_model/boxes.dart';
import 'package:al_quran/providers/bookmarks_provider.dart';
import 'package:al_quran/providers/favourites_provider.dart';
import 'package:al_quran/providers/juz_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:al_quran/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../providers/audio_provider.dart';
import '../../providers/miscellaneous.dart';
import '../../screens/tafsir_display_screen.dart';

TextStyle customStyle({cmh, cmw}) {
  return TextStyle(fontSize: cmh * 0.05);
}

Widget customSizedBox({cmh, cmw}) {
  return SizedBox(
    width: cmw * 0.05,
  );
}
// customSizedBox(cmh:cmh ,cmw:cmw),

juzAyahOnClickMenu(
    {context,
    mq,
    surahName,
    verseNumber,
    index,
    juzIndex,
    verseTranslation,
    surahIndex}) {
  return showModalBottomSheet(
    backgroundColor: Provider.of<ThemeProvider>(context, listen: false)
        .onClickMenuBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(
          mq.height * 0.035,
        ),
        topRight: Radius.circular(
          mq.height * 0.035,
        ),
      ),
    ),
    context: context,
    builder: (context) => ayahMenuItems(
        verseTranslation: verseTranslation,
        juzIndex: juzIndex,
        surahIndex: surahIndex,
        index: index,
        mq: mq,
        context: context,
        surahName: surahName,
        verseNumber: verseNumber),
  );
}

// SurahDisplayScreen xx = SurahDisplayScreen();

/// ayah menu item widget goes from here
///

Widget ayahMenuItems(
    {required mq,
    required context,
    surahName,
    surahIndex,
    verseNumber,
    index,
    juzIndex,
    verseTranslation}) {
  final audioProvider = Provider.of<AudioProvider>(context);
  final favouritesProvider =
      Provider.of<FavouritesProvider>(context, listen: false);
  final settingsProvider =
      Provider.of<SettingsProvider>(context, listen: false);
  final bookmarkProvider =
      Provider.of<BookmarksProvider>(context, listen: false);
  final juzProvider = Provider.of<JuzProvider>(context, listen: false);
  final miscellaneousProvider = Provider.of<MiscellaneousProvider>(context);
  return SizedBox(
    height: mq.height * 0.39,
    child: LayoutBuilder(
      builder: (context, constraints) {
        var cmh = constraints.maxHeight;
        var cmw = constraints.maxWidth;
        return Padding(
          padding: EdgeInsets.only(
            top: cmh * 0.035,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                  child: Text(
                '$surahName : verse  $verseNumber',
                style: GoogleFonts.roboto(
                    fontSize: cmh * 0.045, fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: cmh * 0.035,
              ),
              const Divider(),

              ///play audio button is here
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: cmw * 0.01,
                  ),
                  child: customTextButton(
                    cmh: cmh,
                    cmw: cmw,

                    /// oppressed #1 ~ //Play audio option is here
                    onPressed: () async {
                      Navigator.pop(context);

                      /// show loading
                      audioProvider.setShowAudioLoaderPopUp(value: true);

                      if (await audioProvider.checkInternet() == true) {
                        audioProvider.currentPlayingJuzIndex = juzIndex;

                        /// assigning the initial index
                        /// the player will start playing the ayah from this index
                        audioProvider.juzAyahInitialIndex = index;

                        /// settings up the playlist check code for more information
                        await audioProvider.setupJuzPlaylist(context: context);

                        /// start playing
                        audioProvider.play();

                        /// hiding loading screen
                        audioProvider.setShowAudioLoaderPopUp(value: false);

                        /// displaying the music bar on jus display screen
                        audioProvider.displayBottomMusicBar(bool: true);
                      } else {
                        print('NOT CONNECTED TO THE INTERNET');
                        audioProvider.setShowAudioLoaderPopUp(value: false);
                        audioProvider.setShowNetworkErrorPopUp(value: true);
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.volume_up_sharp,
                          color: Colors.red,
                        ),
                        customSizedBox(cmh: cmh, cmw: cmw),
                        Text(
                          'Play Audio',
                          style: customStyle(cmw: cmw, cmh: cmh),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              ///read tafsir option is here
              ///specifying that tafsir option should show only for mentioned languages cause they are not available for the rest of the languages
              if (settingsProvider.selectedLanguage.toString().toLowerCase() == 'english' ||
                  settingsProvider.selectedLanguage.toString().toLowerCase() ==
                      'arabic' ||
                  settingsProvider.selectedLanguage.toString().toLowerCase() ==
                      'russian' ||
                  settingsProvider.selectedLanguage.toString().toLowerCase() ==
                      'urdu' ||
                  settingsProvider.selectedLanguage.toString().toLowerCase() ==
                      'bengali')
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: cmw * 0.01,
                    ),
                    child: customTextButton(
                      cmh: cmh,
                      cmw: cmw,

                      /// oppressed
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DisplayTafsirScreen(
                                    surahIndex:
                                        int.parse(surahIndex.toString()),
                                    verseNumber:
                                        int.parse(verseNumber.toString()))));
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.menu_book,
                            // color: Colors.white,
                          ),
                          customSizedBox(cmh: cmh, cmw: cmw),
                          Text(
                            'Read Tafsir',
                            style: customStyle(cmw: cmw, cmh: cmh),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ///last read button here ***************************************************
              ///this is the last read icon which is shown with in the book marked surah
              if (surahIndex == bookmarkProvider.surahIndex &&
                  index != bookmarkProvider.ayahIndex - 1)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: cmw * 0.01,
                    ),
                    child: customTextButton(
                      cmh: cmh,
                      cmw: cmw,

                      /// oppressed #3
                      onPressed: () {
                        bookmarkProvider.updateLastReadData(
                            newSurahIndex: surahIndex,
                            newAyahIndex: int.parse(verseNumber));
                        bookmarkProvider.writeSurahData(
                            surahIndex: surahIndex.toString(),
                            ayahIndex: verseNumber.toString());
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bookmark_border_outlined,
                            // color: Colors.white,
                          ),
                          customSizedBox(cmh: cmh, cmw: cmw),
                          Text(
                            'Mark as Last Read',
                            style: customStyle(cmw: cmw, cmh: cmh),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ///last read button here ***************************************************
              ///this is the last read icon which is shown with in the book marked surah
              if (juzIndex == bookmarkProvider.juzIndex &&
                  index != bookmarkProvider.juzAyahIndex)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: cmw * 0.01,
                    ),
                    child: customTextButton(
                      cmh: cmh,
                      cmw: cmw,

                      /// oppressed #3
                      onPressed: () {
                        print(index.runtimeType);
                        bookmarkProvider.updateLastReadJuzData(
                          newJuzIndex: juzIndex,
                          newJuzAyahIndex: index,
                        );

                        bookmarkProvider.writeJuzData(
                          index: index,
                          juzIndex: juzIndex.toString(),
                        );
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.book_rounded,
                            // color: Colors.white,
                          ),
                          customSizedBox(cmh: cmh, cmw: cmw),
                          Text(
                            'Mark as Last Read',
                            style: customStyle(cmw: cmw, cmh: cmh),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ///this is the last read icon which is shown when the bookmarked surah index is != surah index in the book marked surah
              ///universal last read button
              if (juzIndex != bookmarkProvider.juzIndex)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: cmw * 0.01,
                    ),
                    child: customTextButton(
                      cmh: cmh,
                      cmw: cmw,

                      /// oppressed #3
                      onPressed: () {
                        // print(index.runtimeType);
                        bookmarkProvider.updateLastReadJuzData(
                          newJuzIndex: juzIndex,
                          newJuzAyahIndex: index,
                        );

                        bookmarkProvider.writeJuzData(
                          index: index,
                          juzIndex: juzIndex.toString(),
                        );
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.book_rounded,
                            // color: Colors.white,
                          ),
                          customSizedBox(cmh: cmh, cmw: cmw),
                          Text(
                            'Mark as Last Read',
                            style: customStyle(cmw: cmw, cmh: cmh),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ///***REMOVE the LAST READ *******************button
              ///this is the remove from the last read option showing for the surah which is saved as last read
              if (juzIndex == bookmarkProvider.juzIndex &&
                  index == bookmarkProvider.juzAyahIndex)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: cmw * 0.01,
                    ),
                    child: customTextButton(
                      cmh: cmh,
                      cmw: cmw,

                      /// oppressed #3
                      onPressed: () {
                        bookmarkProvider.updateJuzDeleted();

                        bookmarkProvider.removeLastReadJuz();

                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.remove,
                            // color: Colors.white,
                          ),
                          customSizedBox(cmh: cmh, cmw: cmw),
                          Text(
                            'Remove as Last Read',
                            style: customStyle(cmw: cmw, cmh: cmh),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: cmw * 0.01,
                  ),
                  child: customTextButton(
                    cmh: cmh,
                    cmw: cmw,

                    /// oppressed #2
                    onPressed: () {
                      print(
                          'surahname = $surahName verseNumber = $verseNumber index = $surahIndex surahIndex = ${surahIndex}verseTranslation = ${verseTranslation}translationLanguage = ' +
                              settingsProvider.selectedLanguage);

                      if (!favouritesProvider.favouriteVersesArray
                          .contains("$surahIndex:$verseNumber")) {
                        ///adding single favourite verse to bookmarks storage
                        final favouriteItem = BookmarksHiveModel()
                          ..surahIndex = surahIndex
                          ..index = surahIndex
                          ..verseNumber = verseNumber
                          ..surahName = surahName
                          ..surahNumber = surahIndex
                          ..translationLanguage =
                              settingsProvider.selectedLanguage
                          ..verseTranslation = verseTranslation;

                        final box = Boxes().getFavourites();
                        box.add(favouriteItem);
                        favouritesProvider.getFavouriteVersesList();
                        Navigator.pop(context);
                      } else {
                        favouritesProvider
                            .removeFromFavourites('$surahIndex:$verseNumber');
                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      children: [
                        ///conditional rendering of already added to favourites or not
                        Icon(!favouritesProvider.favouriteVersesArray
                                .contains("$surahIndex:$verseNumber")
                            ? Icons.star
                            : Icons.remove),
                        customSizedBox(cmh: cmh, cmw: cmw),
                        Text(
                          !favouritesProvider.favouriteVersesArray
                                  .contains("$surahIndex:$verseNumber")
                              ? 'Add to Favourites'
                              : 'Remove from Favourites',
                          style: customStyle(cmw: cmw, cmh: cmh),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: cmw * 0.01,
                  ),
                  child: customTextButton(
                    cmh: cmh,
                    cmw: cmw,

                    /// oppressed #4
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsScreen()));
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.settings, color: Colors.orange),
                        customSizedBox(cmh: cmh, cmw: cmw),
                        Text(
                          'Settings',
                          style: customStyle(cmw: cmw, cmh: cmh),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              ///
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: cmw * 0.01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///****************************************
                      ///COPY VERSE  button
                      ///****************************************
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.copy),
                        // color: Colors.orange,
                        onPressed: () async {
                          Clipboard.setData(ClipboardData(
                              text: await miscellaneousProvider
                                  .copyVerseToClipBoard()));
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              'Verse copied',
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.green,
                          ));
                        },
                      ),

                      ///****************************************
                      ///SHARE VERSE  button
                      ///****************************************
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.share),
                        // color: Colors.orange,
                        onPressed: () async {
                          Navigator.of(context).pop();
                          Share.share(
                              "${miscellaneousProvider.globalArabicVerse.toString()} \n\n${miscellaneousProvider.globalVerseTranslation.toString()}\n\n( ${miscellaneousProvider.globalSurahName.toString()} | verse ${(int.parse(miscellaneousProvider.globalVerseNumber) + 1).toString()} )\n\nTranslation : ${miscellaneousProvider.globalTranslationName.toString()}",
                              subject: 'Look what I made!');
                        },
                      ),

                      ///****************************************
                      ///DOWNLOAD ayah button
                      ///****************************************
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.file_download),
                        // color: Colors.orange,
                        onPressed: () async {
                          Navigator.of(context).pop();
                          final status = await Permission.storage.request();
                          // print(status);
                          if (await Permission.storage.request().isGranted) {
                            // print('permission granted');
                            miscellaneousProvider.assignDownloadPopUp(
                                value: true);
                            await miscellaneousProvider.downloadVerseAudio(
                              surahNumber: surahIndex,
                                ayahIndex: verseNumber,
                                context: context, isJuzAyahDownloading: true);
                          }
                          if (await Permission.storage.isDenied) {
                            // print(
                            //     'Permission denied. Show a dialog and again ask for the permission');
                            Permission.storage.request();
                            if (status == PermissionStatus.permanentlyDenied) {
                              // print('Take the user to the settings page.');
                              await openAppSettings();
                            }
                          }
                        },
                      ),
                      customSizedBox(cmh: cmh, cmw: cmw),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

/// custom Text Widget widget
Widget customTextButton(
    {required onPressed,
    required Widget child,
    required double cmh,
    required double cmw}) {
  return TextButton(
    style: TextButton.styleFrom( foregroundColor: Colors.black),
    onPressed: onPressed,
    child: child,
  );
}
