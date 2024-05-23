import 'package:al_quran/Navigators/navigator_controller_juz_display_screen.dart';
import 'package:al_quran/Navigators/navigator_controller_surah_display_screen.dart';
import 'package:al_quran/components/bookmarks/make_last_read_juz_permanent.dart';
import 'package:al_quran/components/bookmarks/make_last_read_surah_permanent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BookmarksProvider extends ChangeNotifier {
  ///
  ///last read**************
  ///
  var lastReadDataSurah;

  ///
  var displayScreenItemScrollController;

  ///
  var surahType;
  var surahIndex;
  var ayahIndex;

  fetchLastReadSurah() async {
    lastReadDataSurah = await LastReadSurah().loadBookMarkSurah();
    // print(lastReadData);
    surahType = lastReadDataSurah[0];
    surahIndex = lastReadDataSurah[1] != 'null'
        ? int.parse(lastReadDataSurah[1])
        : 'null';
    ayahIndex = lastReadDataSurah[2] != 'null'
        ? int.parse(lastReadDataSurah[2])
        : 'null';

    // print(type + surahIndex.toString() + ayahIndex.toString());

    notifyListeners();
  }

  writeSurahData({required surahIndex, required ayahIndex}) {
    LastReadSurah()
        .writeSurahLastRead(juzIndex: surahIndex, juzAyahIndex: ayahIndex);
    // print('SURAH LAST READ DATA SAVED');
  }

  updateLastReadData({newSurahIndex, newAyahIndex}) {
    surahType = 'surah';
    surahIndex = newSurahIndex;
    ayahIndex = newAyahIndex;

    notifyListeners();
  }

  navigateToLastRead({required context}) {
    if (surahType != 'null' || surahIndex != 'null' || ayahIndex != 'null') {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              NavigatorControllerSurahDisplayScreen(
            surahIndex: 114 - surahIndex,
          ),
        ),
      );

      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.bookmark_rounded,
                color: Colors.white,
                size: 21,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "No Surah Last Read marked yet",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          duration: const Duration(milliseconds: 1300),
        ),
      );
    }
  }

  removeLastRead() {
    LastReadSurah().removeLastReadSurah();
    // print('deleted');
  }

  ///just pass everything as 'null
  updateDeleted() {
    surahType = 'null';
    surahIndex = 'null';
    ayahIndex = 'null';
    notifyListeners();
  }

  late ItemScrollController surahItemScrollController;
  var openedSurahNumber;

  scrollToBookMarkedSurahAyah() {
    // print('hiii');
    surahItemScrollController.jumpTo(
      index: ayahIndex - 1,
    );
  }

  ///last read juz section start**********************************************************************
  ///\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  ///\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  ///\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

  ///
  ///last read**************JUZ
  ///
  var lastReadDataJuz;

  ///
  var juzType;
  var juzIndex;
  var juzAyahIndex;

  ///
  ///
  fetchLastReadJuz() async {
    lastReadDataJuz = await LastReadJuz().loadBookMarkJuz();
    print(lastReadDataJuz);
    juzType = lastReadDataJuz[0];
    juzIndex =
        lastReadDataJuz[1] != 'null' ? int.parse(lastReadDataJuz[1]) : 'null';
    juzAyahIndex =
        lastReadDataJuz[2] != 'null' ? int.parse(lastReadDataJuz[2]) : 'null';

    notifyListeners();
  }

  ///
  writeJuzData({required juzIndex, required index}) {
    // print(index);

    LastReadJuz().writeJuzLastRead(juzIndex: juzIndex, index: index);
    // print('JUZ LAST READ DATA SAVED');
  }

  updateLastReadJuzData({newJuzIndex, newJuzAyahIndex}) {
    juzType = 'juz';
    juzIndex = newJuzIndex;
    juzAyahIndex = newJuzAyahIndex;

    notifyListeners();
  }

  removeLastReadJuz() {
    LastReadJuz().removeLastReadJuz();
    // print('deleted');
  }

  ///just pass everything as 'null
  updateJuzDeleted() {
    juzType = 'null';
    juzIndex = 'null';
    juzAyahIndex = 'null';
    notifyListeners();
  }

  navigateToLastReadJuz({required context}) {
    if (juzType != 'null' || juzIndex != 'null' || juzAyahIndex != 'null') {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              NavigatorControllerJuzDisplayScreen(
            juzIndex: 30 - juzIndex,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.book_rounded,
                color: Colors.white,
                size: 21,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "No Juz Last Read marked yet",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          duration: const Duration(milliseconds: 1500),
        ),
      );
    }
  }

  late ItemScrollController juzItemScrollController;

  scrollToBookMarkedJuzAyah() {
    print('hiii');
    juzItemScrollController.jumpTo(
      index: juzAyahIndex,
    );
  }
}
