import 'dart:convert';

import 'package:al_quran/providers/audio_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' as services;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import '../components/quran_meta_data/quran_meta_data.dart';

class MiscellaneousProvider extends ChangeNotifier {
  var globalArabicVerse;

  var globalVerseTranslation;

  var globalVerseNumber;

  var globalTranslationName;

  var globalSurahName;

  var globalSurahNumber;

  var surahDisplayScreenContext;
  var juzDisplayScreenContext;
  late AudioProvider globalAudioProvider;

  assignSurahDisplayScreenContext({required context}) {
    surahDisplayScreenContext = context;
    notifyListeners();
  }

  ///*****************
  ///[gatherVerseInformation]gathers and assigns verse information to global variables
  ///******************
  gatherVerseInformation({
    required arabicFullVerse,
    required verseTranslation,
    required versenumber,
    required translationName,
    required surahName,
    required surahNumber,
    required audioProvider,
  }) {
    globalArabicVerse = arabicFullVerse;
    globalVerseTranslation = verseTranslation;
    globalVerseNumber = versenumber;
    globalTranslationName = translationName;
    globalSurahName = surahName;
    globalSurahNumber = surahNumber;
    globalAudioProvider = audioProvider;
    notifyListeners();
  }


  ///*****************
  ///Copies verse to clipboard
  ///******************

  copyVerseToClipBoard() {
    return "${globalArabicVerse.toString()} \n\n${globalVerseTranslation.toString()}\n\n( ${globalSurahName.toString()} | verse ${(int.parse(globalVerseNumber) + 1).toString()} )\n\nTranslation : ${globalTranslationName.toString()}";
  }

  ///*****************
  ///DOWNLOAD verse
  ///******************
  bool showDownloadPopUp = false;
  String downloadProgress = '0%';

  assignDownloadPopUp({required bool value}) {
    showDownloadPopUp = value;
    notifyListeners();
  }

  assignDownloadProgress({value}) {
    print('value');
    downloadProgress = value;
    notifyListeners();
  }

  downloadVerseAudio({ required surahNumber , required ayahIndex ,  context ,bool  isJuzAyahDownloading = false}) async {
    var uuid = const Uuid();

    AudioProvider audioProvider = AudioProvider();
    var linkTemplate = audioProvider.fetchGeneratableTemplateUrl();



          // "$linkTemplate/${surahNumber.toString().padLeft(3, "0")}${(ayahIndex).toString().padLeft(3, "0")}${ audioProvider. reciterShortName == "Husary" ? ".ogg" : ".mp3"}";


    ///snack bar failed
    showSnackBarFailed({error}) =>
        ScaffoldMessenger.of(isJuzAyahDownloading ? juzDisplayScreenContext :surahDisplayScreenContext).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Something went wrong',
            // error.toString(),
            style: TextStyle(fontSize: 9.5.sp),
            textAlign: TextAlign.center,
          ),
        ));

    ///snack bar success
    showSnackBarSuccess() =>
        ScaffoldMessenger.of(isJuzAyahDownloading ? juzDisplayScreenContext :surahDisplayScreenContext).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Download Complete (check Downloads Folder)',
            style: TextStyle(fontSize: 9.5.sp),
            textAlign: TextAlign.center,
          ),
        ));
    final dio = Dio();
    final appStorageDir = await getApplicationDocumentsDirectory();
    // String url = 'https://everyayah.com/data/Alafasy_128kbps/001001.mp3';
    const phoneStoragePath = '/storage/emulated/0/Download/';

    String fileName = (globalAudioProvider.recitationStyle == 'Mujawwad' ||
            globalAudioProvider.recitationStyle == 'Murattal')
        ? "$globalSurahName - verse ${(int.parse(globalVerseNumber) + 1).toString()} style - ${globalAudioProvider.recitationStyle} by ${globalAudioProvider.reciterFullName} ${uuid.v1()}"
        : "$globalSurahName - verse ${(int.parse(globalVerseNumber) + 1).toString()} by ${globalAudioProvider.reciterFullName} ${uuid.v1()}";

    ///
    // final url = await services.rootBundle
    //     .loadString(
    //         'db/links/${globalAudioProvider.fetchingAudio()}/$globalSurahName.json')
    //     .then((jsonData) =>
    //         jsonDecode(jsonData)[int.parse(globalVerseNumber)]['ayah_url']);

   // final url =  "$linkTemplate/${surahNumber.toString().padLeft(3, "0")}${(ayahIndex).toString().padLeft(3, "0")}${ audioProvider. reciterShortName == "Husary" ? ".ogg" : ".mp3"}";

   final url =  "${audioProvider.fetchGeneratableTemplateUrl(optionalReciterShortName: globalAudioProvider.reciterShortName , optionalRecitationStyle: globalAudioProvider.recitationStyle )}${globalSurahNumber.toString().padLeft(3, "0")}${(ayahIndex).toString().padLeft(3, "0")}${ globalAudioProvider.reciterShortName == "Husary" ? ".ogg" : ".mp3"}";


   print(url);

    try {
      // print('$url');
      // print('$fileName');

      /// download on ios
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await dio.download(
          url,
          '$appStorageDir/$fileName.mp3',
          onReceiveProgress: (count, total) {
            assignDownloadProgress(
                value: ((count / total) * 100).truncate().toString() + '%');

            // print(
            //     "count : $count  , Total : $total  ||| Percentage : ${(count / total) * 100}%");
            if (((count / total) * 100).truncate() == 100) {
              showSnackBarSuccess();
            }
          },
        ).whenComplete(() {
          assignDownloadProgress(value: '0%');
          return assignDownloadPopUp(value: false);
        });
      } else {
        ///****////////*********
        /// DOWNLOAD ON ANDROID
        ///****/////////***********

        // await dio.delete('$phoneStoragePath/$fileName.mp3');
        await dio.download(
          url,
          '$phoneStoragePath/$fileName.mp3',
          onReceiveProgress: (count, total) {
            assignDownloadProgress(
                value: ((count / total) * 100).truncate().toString() + '%');
            // print(

            //   "count : $count  , Total : $total  ||| Percentage : ${(count / total) * 100}%");
            if (((count / total) * 100).truncate() == 100) {
              showSnackBarSuccess();
            }
          },
        ).whenComplete(() {
          assignDownloadProgress(value: '0%');

          return assignDownloadPopUp(value: false);
        });
      }
    } catch (err) {
      print('verse downloading error');
      print(err);
      assignDownloadPopUp(value: false);
      // print(err);
      showSnackBarFailed(error: err);
    }
    dio.close(force: true);
  }
}
