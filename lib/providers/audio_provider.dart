// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:al_quran/components/juz_meta_data.dart';
import 'package:al_quran/components/make_values_permanet_class/make_reciter_permanent.dart';
import 'package:al_quran/components/quran_meta_data/quran_meta_data.dart';
import 'package:al_quran/providers/juz_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'data_provider.dart';

class AudioProvider extends ChangeNotifier {
  final player = AudioPlayer();
  var surahAudioComplete;
  var itemScrollController;
  var tabController;

  var currentSurahAyaAudioPlayingIndex;
  var currentPlayingSurahNumber;
  bool showSpeaker = false;

  //
  bool showBottomMusicBar = false;

  ///surah index is used to know on which surah index has the user played the audio / or of which surah audio is playing
  var openedSurahIndex;
  var initialSurahAyahIndex;

  /// [reciterSwitchedOnIndex] this variable tracks the index on which the reciter was changed
  var reciterSwitchedOnIndex;

  ///

  ///*******************************************************************
  late ConcatenatingAudioSource _juz_playlist;
  late ConcatenatingAudioSource _surah_playlist;

  ///
  var surahPlayListListenerCanceler;

  ///

  setupSurahPlaylist({required context}) async {
    // print("opened surah index = $openedSurahIndex");

    /// cancelling juz playlist here
    cancelJuzPlaylist();
    isJuzPlaying = false;

    ///
    isSurahPlaying = true;

    // var uuid = const Uuid();

    List links = [];

    /// this variables hold the surah playlist canceler and cancels the listener when the juz is played

    try {
      var linkTemplate = fetchGeneratableTemplateUrl();

      for (int x = 0;
          x < (QuranMetaData().quranSurah[openedSurahIndex][1] as int);
          x++) {
        links.add(AudioSource.uri(Uri.parse(
            "$linkTemplate/${openedSurahIndex.toString().padLeft(3, "0")}${(x + 1).toString().padLeft(3, "0")}${reciterShortName == "Husary" ? ".ogg" : ".mp3"}")));
      }
      // print(links.length);
      // print(QuranMetaData().quranSurah[openedSurahIndex][1]);

      ///this works with just audio background (give audio player into status bar) ive removes it cause its causing
      ///grave errors while switching  the reciters
      // tag: MediaItem(
      //   // Specify a unique ID for each media item:
      //   id: uuid.v1(),
      //   // Metadata to display in the notification:
      //   album: reciterFullName,
      //   title: surahName,
      //   artUri: Uri.parse('https://example.com/albumart.jpg'),
      //   // ),
      // ),
      // ));
      currentPlayingSurahNumber = openedSurahIndex;
      // }))

      _surah_playlist = ConcatenatingAudioSource(
        // Start loading next item just before reaching it.
        useLazyPreparation: true, // default
        // Customise the shuffle algorithm.
        shuffleOrder: DefaultShuffleOrder(), // default
        // Specify the items in the playlist.
        children: [...links],
      );

      print(_surah_playlist);
      await player.setAudioSource(
        _surah_playlist,

        // Playback will be prepared to start from track1.mp3
        initialIndex: initialSurahAyahIndex, // default
        // Playback will be prepared to start from position zero.

        initialPosition: Duration.zero, // default
      );

      ///

      // print('*' * 10);

      surahPlayListListenerCanceler = player.currentIndexStream.listen((index) {
        // print(
        //     '************************* IM THE SURAH AUDIO PLAYLIST AND AIM  RUNNNING *************************************');
        currentSurahAyaAudioPlayingIndex = index;
        try {
          if (openedSurahIndex != currentPlayingSurahNumber) {
            tabController.animateTo(114 - currentPlayingSurahNumber);
          } else {
            // print('surah index = ' +
            //     surahIndex.toString() +
            //     'and Playing index is ${currentPlayingSurahNumber}');
            reciterSwitchedOnIndex = index;
            print('reciterSwitchedOnIndex = = $reciterSwitchedOnIndex');
            itemScrollController.scrollTo(
                index: index,
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOutCubic);
            notifyListeners();
            // }

            ///
          }
        } catch (err) {
          print(err);
          print(
              'hellooo im error 1 ||||||||||||||||||||||||||||||||||||||||||||||||||');
        }
        // print(index);
      });
    } catch (err) {
      print(err);
      print(
          'hellooo im error 2 ****************************************************************');
    }
  }

  fetchGeneratableTemplateUrl(
      {optionalReciterShortName, optionalRecitationStyle}) {
    ///manual recitation
    var manualRecitationStyle =
        optionalRecitationStyle != null || optionalRecitationStyle != ""
            ? optionalRecitationStyle
            : null;

    // print("this the function = ${optionalRecitationStyle}");

    https: //audio.qurancdn.com/
    switch (optionalReciterShortName ?? reciterShortName) {
      case ('Alafasy'):
        return "https://audio.qurancdn.com/Alafasy/mp3/";

      case ('Sudais'):
        return "https://audio.qurancdn.com/Sudais/mp3/";

      case ('AbdulBaset'):
        return "https://audio.qurancdn.com/AbdulBaset/${manualRecitationStyle ?? recitationStyle}/mp3/";

      case ('Husary'):
        return "https://audio.qurancdn.com/Husary/${manualRecitationStyle ?? recitationStyle}/ogg/";

      case ('Shuraym'):
        return "https://audio.qurancdn.com/Shuraym/mp3/";

      case ('Jibreel'):
        return "https://audio.qurancdn.com/Jibreel/mp3/";

      case ('Tunaiji'):
        return 'https://audio.qurancdn.com/Tunaiji/mp3/';

      case ('Ibrahim_Al-Dosary'):
        return 'https://everyayah.com/data/warsh/warsh_ibrahim_aldosary_128kbps/';

      case ('Yassin_Al-Jazaery'):
        return 'https://everyayah.com/data/warsh/warsh_yassin_al_jazaery_64kbps/';

      case ('Abdullaah_3awwaad_Al-Juhaynee'):
        return 'https://everyayah.com/data/Abdullaah_3awwaad_Al-Juhaynee_128kbps/';

      case ('Abdullah_Matroud'):
        return 'https://everyayah.com/data/Abdullah_Matroud_128kbps/';

      case ('Ahmed_Ibn_Ali_Al_Ajamy'):
        return 'https://everyayah.com/data/ahmed_ibn_ali_al_ajamy_128kbps/';

      case ('Ahmed_Neana'):
        return 'https://everyayah.com/data/Ahmed_Neana_128kbps/';

      case ('Akram_Al_Alaqimy'):
        return 'https://everyayah.com/data/Akram_AlAlaqimy_128kbps/';

      case ('Ali_Jaber'):
        return 'https://everyayah.com/data/Ali_Jaber_64kbps/';

      case ('Ali_Hajjaj_AlSuesy'):
        return 'https://everyayah.com/data/Ali_Hajjaj_AlSuesy_128kbps/';

      case ('Ayman_Sowaid'):
        return 'https://everyayah.com/data/Ayman_Sowaid_64kbps/';

      case ('Fares_Abbad'):
        return 'https://everyayah.com/data/Fares_Abbad_64kbps/';

      case ('Hudhaify'):
        return 'https://everyayah.com/data/Hudhaify_128kbps/';

      case ('Ibrahim_Akhdar'):
        return 'https://everyayah.com/data/Ibrahim_Akhdar_32kbps/';

      case ('Karim_Mansoori'):
        return 'https://everyayah.com/data/Karim_Mansoori_40kbps/';

      case ('Khalid_Abdullah_al-Qahtanee'):
        return 'https://everyayah.com/data/Khaalid_Abdullaah_al-Qahtaanee_192kbps/';

      case ('Maher_Al_Muaiqly'):
        return 'https://everyayah.com/data/MaherAlMuaiqly128kbps/';

      case ('Mahmoud_Ali_Al-Banna'):
        return "https://everyayah.com/data/mahmoud_ali_al_banna_32kbps/";

      // minshawy and minshawi bother names are of same reciter i named i change y to i in last name
      // i represents murattal recitation which has no errors y represents the mujawwad recitation which has errors
      case ('Minshawi'):
        return "https://everyayah.com/data/Minshawy_Murattal_128kbps/";
      case ('Minshawy'):
        return (manualRecitationStyle ?? recitationStyle) == "Mujawwad"
            ? "https://everyayah.com/data/Minshawy_Mujawwad_192kbps/"
            : "https://everyayah.com/data/Minshawy_Murattal_128kbps/";
      //
      case ('Mohammad_al_Tablaway'):
        return 'https://everyayah.com/data/Mohammad_al_Tablaway_128kbps/';

      case ('Muhammad_AbdulKareem'):
        return 'https://everyayah.com/data/Muhammad_AbdulKareem_128kbps/';

      case ('Muhammad_Ayyoub'):
        return 'https://everyayah.com/data/Muhammad_Ayyoub_128kbps/';

      case ('Muhsin_Al_Qasim'):
        return 'https://everyayah.com/data/Muhsin_Al_Qasim_192kbps/';

      case ('Nabil_Rifa3i'):
        return 'https://everyayah.com/data/Nabil_Rifa3i_48kbps/';

      case ('Nasser_Alqatami'):
        return 'https://everyayah.com/data/Nasser_Alqatami_128kbps/';

      case ('Parhizgar'):
        return 'https://everyayah.com/data/Parhizgar_48kbps/';

      case ('Sahl_Yassin'):
        return 'https://everyayah.com/data/Sahl_Yassin_128kbps/';

      case ('Salaah_AbdulRahman_Bukhatir'):
        return 'https://everyayah.com/data/Salaah_AbdulRahman_Bukhatir_128kbps/';

      case ('Salah_Al_Budair'):
        return 'https://everyayah.com/data/Salah_Al_Budair_128kbps/';

      case ('Yaser_Salamah'):
        return 'https://everyayah.com/data/Yaser_Salamah_128kbps/';

      case ('Yasser_Ad-Dussary'):
        return 'https://everyayah.com/data/Yasser_Ad-Dussary_128kbps/';

      case ('Abdullah_Basfar'):
        return 'https://everyayah.com/data/Abdullah_Basfar_192kbps/';

      case ('Abu_Bakr_Ash-Shaatree'):
        return 'https://everyayah.com/data/Abu_Bakr_Ash-Shaatree_128kbps/';

      case ('Aziz_Alili'):
        return 'https://everyayah.com/data/aziz_alili_128kbps/';

      case ('Ghamadi'):
        return 'https://everyayah.com/data/Ghamadi_40kbps/';

      case ('Hani_Rifai'):
        return 'https://everyayah.com/data/Hani_Rifai_192kbps/';

      case ('Fooladvand'):
        return 'https://everyayah.com/data/translations/Fooladvand_Hedayatfar_40Kbps/';

      case ('Makarem'):
        return "https://everyayah.com/data/translations/Makarem_Kabiri_16Kbps/";

      case ('Shamshad_Ali_Khan'):
        return 'https://everyayah.com/data/translations/urdu_shamshad_ali_khan_46kbps/';

      case ('Balayev'):
        return 'https://everyayah.com/data/translations/azerbaijani/balayev/';

      case ('Besim_Korkut'):
        return 'https://everyayah.com/data/translations/besim_korkut_ajet_po_ajet/';

      case ('Farhat_Hashmi'):
        return 'https://everyayah.com/data/translations/urdu_farhat_hashmi/';

      case ('Sahih_International'):
        return "https://everyayah.com/data/English/Sahih_Intnl_Ibrahim_Walk_192kbps/";

      case ('Sahih_International_with_recitation'):
        return 'https://everyayah.com/data/MultiLanguage/Basfar_Walk_192kbps/';
    }
  }

  ///
  ///******************************************************************

  ///

  play() async {
    player.play();

    showSpeaker = true;
    surahAudioComplete = false;
    notifyListeners();
    player.playerStateStream.listen((state) {
      if (state.playing) {
        // print('state = ' + state.playing.toString());
        switch (state.processingState) {
          case ProcessingState.completed:
            {
              //

              currentSurahAyaAudioPlayingIndex = null;
              surahAudioComplete = true;
              showSpeaker = false;

              /// surah resetting
              initialSurahAyahIndex = 0;
              currentSurahAyaAudioPlayingIndex = null;

              /// dua resetting
              duaInitialIndex = 0;
              duaCurrentPlayingIndex = null;

              ///juz
              juzAyahInitialIndex = 0;
              juzCurrentAyahAudioPlayingIndex = null;
              notifyListeners();
              displayBottomMusicBar(bool: false);
              // print('ProcessingState.completed = ' +
              //     ProcessingState.completed.toString());
            }
        }
      }
    });
  }

  pause() async {
    player.pause();
  }

  stop() async {
    player.stop();

    displayBottomMusicBar(bool: false);

    /// surah resetting
    currentPlayingSurahNumber = null;
    currentSurahAyaAudioPlayingIndex = null;
    initialSurahAyahIndex = 0;

    /// juz resetting

    currentPlayingJuzIndex = null;

    juzAyahInitialIndex = 0;

    /// dua resetting
    duaInitialIndex = 0;
    duaCurrentPlayingIndex = null;

    ///
    isSurahPlaying = false;
    isJuzPlaying = false;
  }

  next() async {
    player.seekToNext();
  }

  previous() async {
    player.seekToPrevious();
  }

  checkPlayer() {
    // print(player.playing);
    // print(player.playerState.playing);
    return player.playing;
  }

  displayBottomMusicBar({required bool}) async {
    showBottomMusicBar = bool;
    notifyListeners();
  }

  ///loopmode***************************************************function here

  ///if [repeatValue] == 0 repeat is off
  ///if [repeatValue] == 1 only repeat one verse
  ///if [repeatValue] == 2 repeat full surah
  int repeatValue = 0;

  changeRepeatValue({required setRepeatValue}) async {
    repeatValue = setRepeatValue;
    notifyListeners();
    switch (repeatValue) {
      case 0:
        {
          return player.setLoopMode(LoopMode.off);
        }

      case 1:
        {
          return player.setLoopMode(LoopMode.one);
        }
      case 2:
        {
          // final prefs = await SharedPreferences.getInstance();
          return player.setLoopMode(LoopMode.all);
        }
    }
    notifyListeners();
  }

  ///
  /// ///
  /// this section  deals with changing reciters starts here**************************
  ///
  ///.

  ///getting selectedReciterName here
  var reciterShortName;
  var reciterFullName;
  var recitationStyle;

  assignReciterName({selectedReciterShortName, selectedReciterFullName}) {
    reciterShortName = selectedReciterShortName;
    reciterFullName = selectedReciterFullName;
    notifyListeners();
  }

  assignRecitationStyle({style}) {
    recitationStyle = style;
    notifyListeners();
  }

  fetchRecitationStyle() async {
    recitationStyle = await ReciterFileStorage()
        .readReciterName(fileNameToReadFrom: 'recitationStyle');
    notifyListeners();
  }

  ///fetch reciter from permanent save file fetching everything in surah_names_init
  fetchReciterName() async {
    reciterShortName = await ReciterFileStorage()
        .readReciterName(fileNameToReadFrom: 'reciter');
    notifyListeners();
    if (reciterShortName == 'Alafasy') {
      reciterFullName = 'Mishary bin Rashid Alafasy';
      notifyListeners();
    }
    if (reciterShortName == 'Sudais') {
      reciterFullName = 'Abdul Rahman Al-Sudais';
      notifyListeners();
    }
    if (reciterShortName == 'AbdulBaset') {
      reciterFullName = 'Abdul Basit Muhammad Abdus Samad';
      notifyListeners();
    }
    if (reciterShortName == 'Husary') {
      reciterFullName = 'Mahmoud Khalil Al-Hussary';
      notifyListeners();
    }
    if (reciterShortName == 'Shuraym') {
      reciterFullName = 'Saud Al-Shuraim';
      notifyListeners();
    }
    if (reciterShortName == 'Jibreel') {
      reciterFullName = 'Muhammad Jibreel';
      notifyListeners();
    }
    if (reciterShortName == 'Tunaiji') {
      reciterFullName = 'Khalifa Al Tunaiji';
      notifyListeners();
    }
    //***********************************************************
    if (reciterShortName == 'Ibrahim_Al-Dosary') {
      reciterFullName = 'Ibrahim Al-Dosary';
      notifyListeners();
    }
    if (reciterShortName == 'Yassin_Al-Jazaery') {
      reciterFullName = 'Yassin Al-Jazaery';
      notifyListeners();
    }
    if (reciterShortName == 'Abdullaah_3awwaad_Al-Juhaynee') {
      reciterFullName = 'Abdullaah 3awwaad Al-Juhaynee';
      notifyListeners();
    }
    if (reciterShortName == 'Abdullah_Matroud') {
      reciterFullName = 'Abdullah Matroud';
      notifyListeners();
    }
    if (reciterShortName == 'Ahmed_Ibn_Ali_Al_Ajamy') {
      reciterFullName = 'Ahmed Ibn Ali AlAjamy';
      notifyListeners();
    }
    if (reciterShortName == 'Ahmed_Neana') {
      reciterFullName = 'Ahmed Neana';
      notifyListeners();
    }
    if (reciterShortName == 'Akram_Al_Alaqimy') {
      reciterFullName = 'Akram Al Alaqimy';
      notifyListeners();
    }
    if (reciterShortName == 'Ali_Jaber') {
      reciterFullName = 'Ali Jaber';
      notifyListeners();
    }
    if (reciterShortName == 'Ali_Hajjaj_AlSuesy') {
      reciterFullName = 'Ali Hajjaj AlSuesy';
      notifyListeners();
    }
    if (reciterShortName == 'Ayman_Sowaid') {
      reciterFullName = 'Ayman Sowaid';
      notifyListeners();
    }
    if (reciterShortName == 'Fares_Abbad') {
      reciterFullName = 'Fares Abbad';
      notifyListeners();
    }
    if (reciterShortName == 'Hudhaify') {
      reciterFullName = 'Hudhaify';
      notifyListeners();
    }
    //***************************************************
    if (reciterShortName == 'Ibrahim_Akhdar') {
      reciterFullName = 'Ibrahim Akhdar';
      notifyListeners();
    }
    if (reciterShortName == 'Karim_Mansoori') {
      reciterFullName = 'Karim Mansoori';
      notifyListeners();
    }
    if (reciterShortName == 'Khalid_Abdullah_al-Qahtanee') {
      reciterFullName = 'Khalid Abdullah al-Qahtanee';
      notifyListeners();
    }
    if (reciterShortName == 'Maher_Al_Muaiqly') {
      reciterFullName = 'Maher Al Muaiqly';
      notifyListeners();
    }
    if (reciterShortName == 'Mahmoud_Ali_Al-Banna') {
      reciterFullName = 'Mahmoud Ali Al-Banna';
      notifyListeners();
    }
    if (reciterShortName == 'Menshawi') {
      reciterFullName = 'Menshawi';
      notifyListeners();
    }
    if (reciterShortName == 'Mohammad_al_Tablaway') {
      reciterFullName = 'Mohammad al Tablaway';
      notifyListeners();
    }
    if (reciterShortName == 'Muhammad_AbdulKareem') {
      reciterFullName = 'Muhammad AbdulKareem';
      notifyListeners();
    }
    //  *******************************************
    if (reciterShortName == 'Muhammad_Ayyoub') {
      reciterFullName = 'Muhammad Ayyoub';
      notifyListeners();
    }
    if (reciterShortName == 'Muhsin_Al_Qasim') {
      reciterFullName = 'Muhsin Al Qasim';
      notifyListeners();
    }
    if (reciterShortName == 'Nabil_Rifa3i') {
      reciterFullName = 'Nabil Rifa3i';
      notifyListeners();
    }
    if (reciterShortName == 'Nasser_Alqatami') {
      reciterFullName = 'Nasser Alqatami';
      notifyListeners();
    }
    if (reciterShortName == 'Parhizgar') {
      reciterFullName = 'Parhizgar';
      notifyListeners();
    }
    if (reciterShortName == 'Sahl_Yassin') {
      reciterFullName = 'Sahl Yassin';
      notifyListeners();
    }
    if (reciterShortName == 'Salaah_AbdulRahman_Bukhatir') {
      reciterFullName = 'Salaah AbdulRahman Bukhatir';
      notifyListeners();
    }
    if (reciterShortName == 'Salah_Al_Budair') {
      reciterFullName = 'Salah Al Budair';
      notifyListeners();
    }
    if (reciterShortName == 'Yaser_Salamah') {
      reciterFullName = 'Yaser Salamah';
      notifyListeners();
    }
    if (reciterShortName == 'Yasser_Ad-Dussary') {
      reciterFullName = 'Yasser Ad-Dussary';
      notifyListeners();
    }
    if (reciterShortName == 'Abdullah_Basfar') {
      reciterFullName = 'Abdullah Basfar';
      notifyListeners();
    }
    if (reciterShortName == 'Abu_Bakr_Ash-Shaatree') {
      reciterFullName = 'Abu Bakr Ash-Shaatree';
      notifyListeners();
    }
    if (reciterShortName == 'Aziz_Alili') {
      reciterFullName = 'Aziz Alili';
      notifyListeners();
    }
    if (reciterShortName == 'Ghamadi') {
      reciterFullName = 'Ghamadi';
      notifyListeners();
    }
    if (reciterShortName == 'Hani_Rifai') {
      reciterFullName = 'Hani Rifai';
      notifyListeners();
    }
    if (reciterShortName == 'Minshawy') {
      reciterFullName = 'Minshawy';
      notifyListeners();
    }
    if (reciterShortName == 'Fooladvand') {
      reciterFullName = 'Fooladvand';
      notifyListeners();
    }
    if (reciterShortName == 'Makarem') {
      reciterFullName = 'Naser Makarem Shirazi';
      notifyListeners();
    }
    if (reciterShortName == 'Shamshad_Ali_Khan') {
      reciterFullName = 'Shamshad Ali Khan';
      notifyListeners();
    }
    if (reciterShortName == 'Balayev') {
      reciterFullName = 'Balayev';
      notifyListeners();
    }
    if (reciterShortName == 'Besim_Korkut') {
      reciterFullName = 'Besim Korkut';
      notifyListeners();
    }
    if (reciterShortName == 'Farhat_Hashmi') {
      reciterFullName = 'Farhat Hashmi';
      notifyListeners();
    }
    if (reciterShortName == 'Sahih_International') {
      reciterFullName = 'Sahih International';
      notifyListeners();
    }
    if (reciterShortName == 'Sahih_International_with_recitation') {
      reciterFullName = 'Sahih International \n (Translation with recitation)';
      notifyListeners();
    }
  }

//fetchingAudio
//  this will return the name for the reciter for which the links will be generated
  fetchingAudio() {
    print(recitationStyle);
    print(reciterShortName);
    switch (reciterShortName) {
      case ('Alafasy'):
        return 'Alafasy';

      case ('Sudais'):
        return 'Sudais';

      case ('AbdulBaset'):
        return "AbdulBaset/$recitationStyle";

      case ('Husary'):
        return "Husary/$recitationStyle";

      case ('Shuraym'):
        return "Shuraym";

      case ('Jibreel'):
        return "Jibreel";

      case ('Tunaiji'):
        return 'Tunaiji';

      case ('Ibrahim_Al-Dosary'):
        return 'Ibrahim_Al-Dosary';

      case ('Yassin_Al-Jazaery'):
        return 'Yassin_Al-Jazaery';

      case ('Abdullaah_3awwaad_Al-Juhaynee'):
        return 'Abdullaah_3awwaad_Al-Juhaynee';

      case ('Abdullah_Matroud'):
        return 'Abdullah_Matroud';

      case ('Ahmed_Ibn_Ali_Al_Ajamy'):
        return 'Ahmed_Ibn_Ali_Al_Ajamy';

      case ('Ahmed_Neana'):
        return 'Ahmed_Neana';

      case ('Akram_Al_Alaqimy'):
        return 'Akram_Al_Alaqimy';

      case ('Ali_Jaber'):
        return 'Ali_Jaber';

      case ('Ali_Hajjaj_AlSuesy'):
        return 'Ali_Hajjaj_AlSuesy';

      case ('Ayman_Sowaid'):
        return 'Ayman_Sowaid';

      case ('Fares_Abbad'):
        return 'Fares_Abbad';

      case ('Hudhaify'):
        return 'Hudhaify';

      case ('Ibrahim_Akhdar'):
        return 'Ibrahim_Akhdar';

      case ('Karim_Mansoori'):
        return 'Karim_Mansoori';

      case ('Khalid_Abdullah_al-Qahtanee'):
        return 'Khalid_Abdullah_al-Qahtanee';

      case ('Maher_Al_Muaiqly'):
        return 'Maher_Al_Muaiqly';

      case ('Mahmoud_Ali_Al-Banna'):
        return 'Mahmoud_Ali_Al-Banna';

      case ('Menshawi'):
        return 'Menshawi';

      case ('Mohammad_al_Tablaway'):
        return 'Mohammad_al_Tablaway';

      case ('Muhammad_AbdulKareem'):
        return 'Muhammad_AbdulKareem';

      case ('Muhammad_Ayyoub'):
        return 'Muhammad_Ayyoub';

      case ('Muhsin_Al_Qasim'):
        return 'Muhsin_Al_Qasim';

      case ('Nabil_Rifa3i'):
        return 'Nabil_Rifa3i';

      case ('Nasser_Alqatami'):
        return 'Nasser_Alqatami';

      case ('Parhizgar'):
        return 'Parhizgar';

      case ('Sahl_Yassin'):
        return 'Sahl_Yassin';

      case ('Salaah_AbdulRahman_Bukhatir'):
        return 'Salaah_AbdulRahman_Bukhatir';

      case ('Salah_Al_Budair'):
        return 'Salah_Al_Budair';

      case ('Yaser_Salamah'):
        return 'Yaser_Salamah';

      case ('Yasser_Ad-Dussary'):
        return 'Yasser_Ad-Dussary';

      case ('Abdullah_Basfar'):
        return 'Abdullah_Basfar';

      case ('Abu_Bakr_Ash-Shaatree'):
        return 'Abu_Bakr_Ash-Shaatree';

      case ('Aziz_Alili'):
        return 'Aziz_Alili';

      case ('Ghamadi'):
        return 'Ghamadi';

      case ('Hani_Rifai'):
        return 'Hani_Rifai';

      case ('Minshawy'):
        return 'Minshawy/$recitationStyle';

      case ('Fooladvand'):
        return 'Fooladvand';

      case ('Makarem'):
        return 'Makarem';

      case ('Shamshad_Ali_Khan'):
        return 'Shamshad_Ali_Khan';

      case ('Balayev'):
        return 'Balayev';

      case ('Besim_Korkut'):
        return 'Besim_Korkut';

      case ('Farhat_Hashmi'):
        return 'Farhat_Hashmi';

      case ('Sahih_International'):
        return 'Sahih_International';

      case ('Sahih_International_with_recitation'):
        return 'Sahih_International_with_recitation';
    }
  }

  bool isJuzPlaying = false;
  bool isSurahPlaying = false;

  switchToSelectedRecitationStyle({required context, shortName}) async {
    print('the ayah index while switching =  $initialSurahAyahIndex');
    print('THE INITIAL INDEX DURING SWITCHING IS = $reciterSwitchedOnIndex');

    /// completely resetting preview
    // previewPlayingIndex = null;
    // previewPLayingId = null;

    ///
    if (player.playing) {
      player.stop();
      surahAudioComplete = false;
      displayBottomMusicBar(bool: true);
      if (reciterSwitchedOnIndex != null) {
        /// if the juz is playing
        if (isJuzPlaying) {
          juzAyahInitialIndex = reciterSwitchedOnIndex;
          await setupJuzPlaylist(context: context);
          notifyListeners();
        } else if (isSurahPlaying) {
          print("I RANNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN");
          print(
              'THE INITIAL INDEX DURING SWITCHING IS = $reciterSwitchedOnIndex');
          initialSurahAyahIndex = reciterSwitchedOnIndex;
          await setupSurahPlaylist(context: context);
          notifyListeners();
        }

        /// else if anything else is playing
        // else if (duaCurrentPlayingIndex != null) {
        //   // stop();
        //   // player.play();
        //   duaInitialIndex = duaCurrentPlayingIndex;
        // }

        notifyListeners();
      }

      play();
      notifyListeners();
    }
  }

  ///single audio Player////////////////////////////////////////////////
  ///
  /// dua doesn't support auto switch cause there is no listener available as in  playlist mode
  /// figure it out later
  int duaInitialIndex = 0;
  var duaCurrentPlayingIndex;

  singleDuaAudioPlayer(
      {context,
      required surahName,
      required surahNumber,
      required verseNumber,
      required ItemScrollController itemScrollController,
      required duaIndex}) async {
    /// cancelling rest of the players here
    cancelJuzPlaylist();
    cancelSurahPlaylist();

    ///
    isSurahPlaying = false;
    isJuzPlaying = false;

    displayBottomMusicBar(bool: true);

    ///im using [verseNumber-1] cause the index starts with 0

    var duaAudio =
        "${fetchGeneratableTemplateUrl()}/${surahNumber.toString().padLeft(3, "0")}${(verseNumber.toString().padLeft(3, "0"))}${reciterShortName == "Husary" ? ".ogg" : ".mp3"}";

    ///
    // print(duaAudio);
    try {
      duaInitialIndex = duaIndex;
      duaCurrentPlayingIndex = duaIndex;
      itemScrollController.scrollTo(
          index: duaIndex, duration: const Duration(milliseconds: 551));
      player.setUrl(duaAudio).onError((error, stackTrace) {
        // print('the error is = ' + error.toString());
        // print('hammad this was the culprit');
        showBottomMusicBar = false;
        showSpeaker = false;
        player.stop();
        notifyListeners();
        if (error.toString() == '(0) Source error') {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text('(Audio Player) Network Error'),
                    content: const Text(
                        'Please Check your INTERNET CONNECTION and try again.'),
                    actions: <Widget>[
                      TextButton(
                          child: const Text('Close'),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ));
        }

        return null;
      });
      play();
      notifyListeners();
    } catch (err) {
      print(err);
      // print('error 3 has happened hammad ');
    }
  }

  ///
  ///
  ///

  /// ////////////////////////////////////////////////////////////////
  /// ////////////////////////////////////////////////////////////////
  /// ////////////////////////////////////////////////////////////////
  /// check internet here=============================
  bool showAudioLoaderPopUp = false;
  bool showNetworkErrorPopUp = false;

  setShowAudioLoaderPopUp({required bool value}) {
    showAudioLoaderPopUp = value;
    notifyListeners();
  }

  setShowNetworkErrorPopUp({required bool value}) {
    showNetworkErrorPopUp = value;
    notifyListeners();
  }

  ///
  ///check internet connection function
  ///
  Future<bool> checkInternet() async {
    bool status = false;
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      print('Has Internet');
      status = true;
    } else {
      print('No internet :( ');
      status = false;
    }
    return status;
  }

  ///
  /// ===================================================== JUZ AUDIO FUNCTIONS ============================================================
  /// ===================================================== JUZ AUDIO FUNCTIONS ============================================================
  /// ===================================================== JUZ AUDIO FUNCTIONS ============================================================
  /// ===================================================== JUZ AUDIO FUNCTIONS ============================================================
  var openedJuzIndex;
  var currentPlayingJuzIndex;
  var juzTabController;
  var juzItemScrollController;
  int juzAyahInitialIndex = 0;

  var juzCurrentAyahAudioPlayingIndex;

  ///
  ///
  /// this variables hold the surah playlist canceler and cancels the listener when the juz is played
  var juzPlayListListenerCanceler;

  /// [cancelSurahPlaylist] removes the surah playlist it is called in the [setupJuzPlaylist] function so that there is no
  /// abnormal behaviour
  cancelSurahPlaylist() {
    try {
      surahPlayListListenerCanceler.cancel();
      _surah_playlist.clear();
      currentSurahAyaAudioPlayingIndex = null;
      currentPlayingSurahNumber = null;
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  /// [cancelJuzPlaylist] removes the surah playlist it is called in the [setupSurahPlaylist] function so that there is no
  /// abnormal behaviour
  cancelJuzPlaylist() {
    try {
      juzPlayListListenerCanceler.cancel();
      _juz_playlist.clear();
      juzCurrentAyahAudioPlayingIndex = null;
      currentPlayingJuzIndex = null;
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  ///
  ///*******************************************************************
  setupJuzPlaylist(
      {required context, bool isRequestFromAppbarPlayButton = false}) {
    ///
    /// cancelling surah playlist here before starting the juz playlist to avoid any abnormal behaviour
    cancelSurahPlaylist();
    isSurahPlaying = false;

    ///

    if (isRequestFromAppbarPlayButton) {
      print('current playing = ${currentPlayingJuzIndex}');
      print('opened juz index = ${openedJuzIndex}');
      currentPlayingJuzIndex = openedJuzIndex;
    }
    isJuzPlaying = true;
    // var uuid = const Uuid();

    print("Juz aya innitial  = ${juzAyahInitialIndex}");
    print('current playing = ${currentPlayingJuzIndex}');
    print('opened juz index = ${openedJuzIndex}');
    try {
      var linkTemplate = fetchGeneratableTemplateUrl();

      List links = [];

      /// getting juz data
      List juzData = Provider.of<JuzProvider>(context, listen: false).juzData;

      /// lopping through it to get verse and aya numbers
      for (var e in juzData) {
        print("surah number = ${e["sura"]}");
        print("verse number = ${e["aya"]}");

        /// populating lists links array with the generated link
        links.add(AudioSource.uri(Uri.parse(
            "$linkTemplate/${e["sura"].toString().padLeft(3, "0")}${(e["aya"]).toString().padLeft(3, "0")}${reciterShortName == "Husary" ? ".ogg" : ".mp3"}")));
      }

      /// settings up audio
      _juz_playlist = ConcatenatingAudioSource(
        // Start loading next item just before reaching it.
        useLazyPreparation: true, // default
        // Customise the shuffle algorithm.
        shuffleOrder: DefaultShuffleOrder(), // default
        // Specify the items in the playlist.
        children: [...links],
      );
      player.setAudioSource(
        _juz_playlist,

        // Playback will be prepared to start from track1.mp3
        initialIndex: juzAyahInitialIndex, // default
        // Playback will be prepared to start from position zero.

        initialPosition: Duration.zero, // default
      );
      // print('*' * 10);

      juzPlayListListenerCanceler = player.currentIndexStream.listen((index) {
        juzCurrentAyahAudioPlayingIndex = index;

        try {
          if (currentPlayingJuzIndex != openedJuzIndex) {
            juzTabController.animateTo(30 - currentPlayingJuzIndex);
          } else {
            reciterSwitchedOnIndex = index;
            print('reciterSwitchedOnIndex = = $reciterSwitchedOnIndex');
            juzItemScrollController.scrollTo(
                index: index,
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOutCubic);
            notifyListeners();
            // }

            ///
          }
        } catch (err) {
          print(err);
        }

        // print(index);
      });
    } catch (err) {
      print(err);
      print(
          'hellooo im error 2 ****************************************************************');
    }
  }
}
