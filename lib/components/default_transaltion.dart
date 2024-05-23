import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:provider/provider.dart';

///
///
///this class contains default translations which are assigned when the user open app for the first time
///
///
defaultTranslation({required languageName, required context}) {
  var dataProvider = Provider.of<Data>(context, listen: false);
  var settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
  switch (languageName) {
    case 'English':
      {
        dataProvider.translationName = 'en.sahih';
        settingsProvider.selectedTranslatorName = 'Saheeh International';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'en.sahih',
          translatorName: 'Saheeh International',
        );
      }
      break;
    case 'Urdu':
      {
        dataProvider.translationName = 'ur.junagarhi';
        settingsProvider.selectedTranslatorName = '	محمد جوناگڑھی';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'ur.junagarhi',
          translatorName: '	محمد جوناگڑھی',
        );
      }
      break;
    case 'Arabic':
      {
        dataProvider.translationName = 'ar.jalalayn';
        settingsProvider.selectedTranslatorName = '	تفسير الجلالين';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'ar.jalalayn',
          translatorName: '	تفسير الجلالين',
        );
      }
      break;
    case 'Albanian':
      {
        dataProvider.translationName = 'sq.ahmeti';
        settingsProvider.selectedTranslatorName = 'Sherif Ahmeti';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'sq.ahmeti',
          translatorName: 'Sherif Ahmeti',
        );
      }
      break;
    case 'Amazigh':
      {
        dataProvider.translationName = 'ber.mensur';
        settingsProvider.selectedTranslatorName = 'At Mensur';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'ber.mensur',
          translatorName: 'At Mensur',
        );
      }
      break;
    case 'Amharic':
      {
        dataProvider.translationName = 'am.sadiq';
        settingsProvider.selectedTranslatorName = 'ሳዲቅ & ሳኒ ሐቢብ';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'am.sadiq',
          translatorName: 'ሳዲቅ & ሳኒ ሐቢብ',
        );
      }
      break;
    case 'Azerbaijani':
      {
        dataProvider.translationName = 'az.mammadaliyev';
        settingsProvider.selectedTranslatorName = 'Məmmədəliyev & Bünyadov';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'az.mammadaliyev',
          translatorName: 'Məmmədəliyev & Bünyadov',
        );
      }
      break;
    case 'Bengali':
      {
        dataProvider.translationName = 'bn.bengali';
        settingsProvider.selectedTranslatorName = 'মুহিউদ্দীন খান';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'bn.bengali',
          translatorName: 'মুহিউদ্দীন খান',
        );
      }
      break;
    case 'Bosnian':
      {
        dataProvider.translationName = 'bs.mlivo';
        settingsProvider.selectedTranslatorName = 'Mlivo';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'bs.mlivo',
          translatorName: 'Mlivo',
        );
      }
      break;
    case 'Bulgarian':
      {
        dataProvider.translationName = 'bg.theophanov';
        settingsProvider.selectedTranslatorName = 'Теофанов';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'bg.theophanov',
          translatorName: 'Теофанов',
        );
      }
      break;
    case 'Chinese':
      {
        dataProvider.translationName = 'zh.majian';
        settingsProvider.selectedTranslatorName = 'Ma Jian (Traditional)';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'zh.majian',
          translatorName: 'Ma Jian (Traditional)',
        );
      }
      break;
    case 'Czech':
      {
        dataProvider.translationName = 'cs.nykl';
        settingsProvider.selectedTranslatorName = 'Nykl';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'cs.nykl',
          translatorName: 'Nykl',
        );
      }
      break;
    case 'Divehi':
      {
        dataProvider.translationName = 'dv.divehi';
        settingsProvider.selectedTranslatorName = '	ދިވެހި';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'dv.divehi',
          translatorName: '	ދިވެހި',
        );
      }
      break;
    case 'Dutch':
      {
        dataProvider.translationName = 'nl.siregar';
        settingsProvider.selectedTranslatorName = 'Siregar';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'nl.siregar',
          translatorName: 'Siregar',
        );
      }
      break;
    case 'French':
      {
        dataProvider.translationName = 'fr.hamidullah';
        settingsProvider.selectedTranslatorName = 'Hamidullah';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'fr.hamidullah',
          translatorName: 'Hamidullah',
        );
      }
      break;
    case 'German':
      {
        dataProvider.translationName = 'de.zaidan';
        settingsProvider.selectedTranslatorName = 'Zaidan';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'de.zaidan',
          translatorName: 'Zaidan',
        );
      }
      break;
    case 'Hausa':
      {
        dataProvider.translationName = 'ha.gumi';
        settingsProvider.selectedTranslatorName = 'Gumi';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'ha.gumi',
          translatorName: 'Gumi',
        );
      }
      break;
    case 'Hindi':
      {
        dataProvider.translationName = 'hi.hindi';
        settingsProvider.selectedTranslatorName = 'फ़ारूक़ ख़ान & नदवी';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'hi.farooq',
          translatorName: 'फ़ारूक़ ख़ान & अहमद',
        );
      }
      break;
    case 'Indonesian':
      {
        dataProvider.translationName = 'id.jalalayn';
        settingsProvider.selectedTranslatorName = 'Tafsir Jalalayn';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'id.jalalayn',
          translatorName: 'Tafsir Jalalayn',
        );
      }
      break;
    case 'Italian':
      {
        dataProvider.translationName = 'it.piccardo';
        settingsProvider.selectedTranslatorName = 'Piccardo';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'it.piccardo',
          translatorName: 'Piccardo',
        );
      }
      break;
    case 'Japanese':
      {
        dataProvider.translationName = 'ja.japanese';
        settingsProvider.selectedTranslatorName = 'Japanese';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'ja.japanese',
          translatorName: 'Japanese',
        );
      }
      break;
    case 'Korean':
      {
        dataProvider.translationName = 'ko.korean';
        settingsProvider.selectedTranslatorName = 'Korean';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'ko.korean',
          translatorName: 'Korean',
        );
      }
      break;
    case 'Kurdish':
      {
        dataProvider.translationName = 'ku.asan';
        settingsProvider.selectedTranslatorName = 'ته‌فسیری ئاسان';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'ku.asan',
          translatorName: 'ته‌فسیری ئاسان',
        );
      }
      break;
    case 'Malay':
      {
        dataProvider.translationName = 'ms.basmeih';
        settingsProvider.selectedTranslatorName = 'Basmeih';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'ms.basmeih',
          translatorName: 'Basmeih',
        );
      }
      break;
    case 'Malayalam':
      {
        dataProvider.translationName = 'ml.karakunnu';
        settingsProvider.selectedTranslatorName = 'കാരകുന്ന് & എളയാവൂര്h';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'ml.karakunnu',
          translatorName: 'കാരകുന്ന് & എളയാവൂര്h',
        );
      }
      break;
    case 'Norwegian':
      {
        dataProvider.translationName = 'no.berg';
        settingsProvider.selectedTranslatorName = 'Einar Berg';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'no.berg',
          translatorName: 'Einar Berg',
        );
      }
      break;
    case 'Pashto':
      {
        dataProvider.translationName = 'ps.abdulwali';
        settingsProvider.selectedTranslatorName = '	عبدالولي';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'ps.abdulwali',
          translatorName: '	عبدالولي',
        );
      }
      break;
    case 'Persian':
      {
        dataProvider.translationName = 'fa.ansarian';
        settingsProvider.selectedTranslatorName = '	انصاریان';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'fa.ansarian',
          translatorName: '	انصاریان',
        );
      }
      break;
    case 'Polish':
      {
        dataProvider.translationName = 'pl.bielawskiego';
        settingsProvider.selectedTranslatorName = 'Bielawskiego';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'pl.bielawskiego',
          translatorName: 'Bielawskiego',
        );
      }
      break;
    case 'Portuguese':
      {
        dataProvider.translationName = 'pt.elhayek';
        settingsProvider.selectedTranslatorName = 'El-Hayek';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'pt.elhayek',
          translatorName: 'El-Hayek',
        );
      }
      break;
    case 'Romanian':
      {
        dataProvider.translationName = 'ro.grigore';
        settingsProvider.selectedTranslatorName = 'Grigore';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'ro.grigore',
          translatorName: 'Grigore',
        );
      }
      break;
    case 'Russian':
      {
        dataProvider.translationName = 'ru.abuadel';
        settingsProvider.selectedTranslatorName = 'Абу Адель';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'ru.abuadel',
          translatorName: 'Абу Адель',
        );
      }
      break;
    case 'Sindhi':
      {
        dataProvider.translationName = 'sd.amroti';
        settingsProvider.selectedTranslatorName = '	امروٽي';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'sd.amroti',
          translatorName: '	امروٽي',
        );
      }
      break;
    case 'Somali':
      {
        dataProvider.translationName = 'so.abduh';
        settingsProvider.selectedTranslatorName = 'Abduh';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'so.abduh',
          translatorName: 'Abduh',
        );
      }
      break;
    case 'Spanish':
      {
        dataProvider.translationName = 'es.bornez';
        settingsProvider.selectedTranslatorName = 'Bornez';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'es.bornez',
          translatorName: 'Bornez',
        );
      }
      break;
    case 'Swahili':
      {
        dataProvider.translationName = 'sw.barwani';
        settingsProvider.selectedTranslatorName = 'Al-Barwani';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'sw.barwani',
          translatorName: 'Al-Barwani',
        );
      }
      break;
    case 'Swedish':
      {
        dataProvider.translationName = 'sv.bernstrom';
        settingsProvider.selectedTranslatorName = 'Bernström';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'sv.bernstrom',
          translatorName: 'Bernström',
        );
      }
      break;
    case 'Tajik':
      {
        dataProvider.translationName = 'tg.ayati';
        settingsProvider.selectedTranslatorName = 'Оятӣ';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'tg.ayati',
          translatorName: 'Оятӣ',
        );
      }
      break;
    case 'Tamil':
      {
        dataProvider.translationName = 'ta.tamil';
        settingsProvider.selectedTranslatorName = 'ஜான் டிரஸ்ட்';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'ta.tamil',
          translatorName: 'ஜான் டிரஸ்ட்',
        );
      }
      break;
    case 'Tatar':
      {
        dataProvider.translationName = 'tt.nugman';
        settingsProvider.selectedTranslatorName = 'Yakub Ibn Nugman';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'tt.nugman',
          translatorName: 'Yakub Ibn Nugman',
        );
      }
      break;
    case 'Thai':
      {
        dataProvider.translationName = 'th.thai';
        settingsProvider.selectedTranslatorName = 'ภาษาไทย';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'th.thai',
          translatorName: 'ภาษาไทย',
        );
      }
      break;
    case 'Turkish':
      {
        dataProvider.translationName = 'tr.golpinarli';
        settingsProvider.selectedTranslatorName = 'Abdulbakî Gölpınarlı';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'tr.golpinarli',
          translatorName: 'Abdulbakî Gölpınarlı',
        );
      }
      break;
    case 'Uyghur':
      {
        dataProvider.translationName = 'ug.saleh';
        settingsProvider.selectedTranslatorName = 'محمد صالح';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'ug.saleh',
          translatorName: 'محمد صالح',
        );
      }
      break;
    case 'Uzbek':
      {
        dataProvider.translationName = 'uz.sodik';
        settingsProvider.selectedTranslatorName = 'Мухаммад Содик';

        ///writing translatorName and translation name ot permanent file*******
        settingsProvider.writeTranslatorNameAndTranslationName(
          translationName: 'uz.sodik',
          translatorName: 'Мухаммад Содик',
        );
      }
      return;
  }
}
