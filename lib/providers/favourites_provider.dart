import 'package:al_quran/components/make_values_permanet_class/make_arabic_type_permanent_class.dart';
import 'package:al_quran/components/quran_db_class/quran_db_class.dart';
import 'package:al_quran/components/quran_db_class/quran_indopak_script_class.dart';
import 'package:al_quran/hive_model/boxes.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FavouritesProvider extends ChangeNotifier {
  var selectedArabicType = 'Indo - Pak';

  fetchSelectedArabicType() async {
    selectedArabicType = await ArabicTypeStorage()
        .readArabicType(fileNameToReadFrom: 'arabic_type');
    notifyListeners();
  }

  ///
  ///
  ///quran fetch for the favourites section
  ///
  List favouritesQuranVerses = [];

  fetchFavouritesQuranVerse() async {
    List incomingQuranVerse = [];
    var selectedArabicType = await ArabicTypeStorage()
        .readArabicType(fileNameToReadFrom: 'arabic_type');
    if (selectedArabicType == 'Uthmani') {
      for (var e in Boxes().getFavourites().values.toList()) {
        for (var e2 in QuranDb().fullQuran) {
          if (e2['sura'] == int.parse(e.surahIndex.toString()) &&
              e2['aya'] == int.parse(e.verseNumber.toString())) {
            incomingQuranVerse.add(e2['text']);
          }
        }
      }
      favouritesQuranVerses = incomingQuranVerse;
    } else {
      for (var e in Boxes().getFavourites().values.toList()) {
        for (var e2 in Quran_indo_pak_script_DB().quran_indo_pak_script) {
          if (e2['sura'] == int.parse(e.surahIndex.toString()) &&
              e2['aya'] == int.parse(e.verseNumber.toString())) {
            incomingQuranVerse.add(e2['text']);
          }
        }
      }
      favouritesQuranVerses = incomingQuranVerse;
    }

    notifyListeners();
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///

  /// changing directionality account to the need . just see where its being used will clear all doubts
  changeDirectionalityAccordingToFavouriteVerseTranslationLanguage(
      {favouriteVerseTranslationLanguage}) {
    if (favouriteVerseTranslationLanguage == 'Urdu' ||
        favouriteVerseTranslationLanguage == 'Arabic' ||
        favouriteVerseTranslationLanguage == 'Divehi' ||
        favouriteVerseTranslationLanguage == 'Kurdish' ||
        favouriteVerseTranslationLanguage == 'Pashto' ||
        favouriteVerseTranslationLanguage == 'Persian' ||
        favouriteVerseTranslationLanguage == 'Sindhi' ||
        favouriteVerseTranslationLanguage == 'Uyghur') {
      return TextDirection.rtl;
    } else {
      return TextDirection.ltr;
    }
  }

  ///
  TextStyle changeFavouriteVerseTranslationTxtStyleAccordingToLanguage(
      {required cmh, context, translationFontSize, selectedLanguage}) {
    if (selectedLanguage == 'Urdu') {
      return TextStyle(
          // fontSize: changeFontSizeAccordingToLanguage(widget: widget),
          fontSize: translationFontSize - 1.5,
          height: 1.9,
          fontFamily: 'Noto',
          color: Provider.of<ThemeProvider>(context).translationFontColor);
    } else if (selectedLanguage == 'Arabic' ||
        selectedLanguage == 'Divehi' ||
        selectedLanguage == 'Kurdish' ||
        selectedLanguage == 'Pashto' ||
        selectedLanguage == 'Persian' ||
        selectedLanguage == 'Sindhi' ||
        selectedLanguage == 'Uyghur') {
      return GoogleFonts.roboto(
        fontSize: translationFontSize +2,
        height: 1.25,
        color: Provider.of<ThemeProvider>(context).translationFontColor,
      );
    } else {
      return GoogleFonts.roboto(
          fontSize: translationFontSize - 2.1,
          height: 1.25,
          color: Provider.of<ThemeProvider>(context).translationFontColor);
    }
  }

  ///this function is dealing with the deletion of the favourites verses
  deleteFavourite(index, context) {
    final box = Boxes().getFavourites();
    Navigator.pop(context);
    box.deleteAt(index).then((value) {
      getFavouriteVersesList();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.star,
                color: Colors.white,
                size: 21,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Deleted Successfully",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          duration: const Duration(milliseconds: 1500),
        ),
      );
    });
  }

  /// testing the selection of the favourite verses

  List favouriteVersesArray = [];

  getFavouriteVersesList() async {
    favouriteVersesArray = [];
    var box = Boxes().getFavourites().values.toList();
    box.forEach((e) {
      if (favouriteVersesArray.length != box.length) {
        favouriteVersesArray
            .add(e.surahNumber.toString() + ':' + e.verseNumber.toString());
      }
    });
    print(favouriteVersesArray);
    notifyListeners();
  }

  /// removeFromFavourites ayah on click menu
  removeFromFavourites(surahNumberAndVerseNumber) {
    final box = Boxes().getFavourites();
    box
        .deleteAt(favouriteVersesArray.indexOf(surahNumberAndVerseNumber))
        .then((value) => getFavouriteVersesList());
  }
}
