import 'package:al_quran/Navigators/main_screen_navigator.dart';
import 'package:al_quran/providers/audio_provider.dart';
import 'package:al_quran/providers/bookmarks_provider.dart';
import 'package:al_quran/providers/contact_portal_provider.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/favourites_provider.dart';
import 'package:al_quran/providers/global_search_provider.dart';
import 'package:al_quran/providers/juz_provider.dart';
import 'package:al_quran/providers/miscellaneous.dart';
import 'package:al_quran/providers/more_section_provider.dart';
import 'package:al_quran/providers/salah_times_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/speech_to_text_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'hive_model/bookmarks_hive_model.dart';

///

///

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );
  ///timezone initializing here
  await Hive.initFlutter();

  Hive.registerAdapter(BookmarksHiveModelAdapter());
  Hive.openBox<BookmarksHiveModel>('bookmarksStorage');

  // await Firebase.initializeApp();
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    // enabled: false,
    builder: (context) => MultiProvider(providers: [
      ChangeNotifierProvider<Data>(
        create: (context) => Data(),
      ),
      ChangeNotifierProvider<FavouritesProvider>(
        create: (context) => FavouritesProvider(),
      ),
      ChangeNotifierProvider<AudioProvider>(
        create: (context) => AudioProvider(),
      ),
      ChangeNotifierProvider<SettingsProvider>(
        create: (context) => SettingsProvider(),
      ),
      ChangeNotifierProvider<JuzProvider>(
        create: (context) => JuzProvider(),
      ),
      ChangeNotifierProvider<ThemeProvider>(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider<GlobalSearchProvider>(
        create: (context) => GlobalSearchProvider(),
      ),
      ChangeNotifierProvider<BookmarksProvider>(
        create: (context) => BookmarksProvider(),
      ),
      ChangeNotifierProvider<MoreSectionProvider>(
        create: (context) => MoreSectionProvider(),
      ),
      ChangeNotifierProvider<ContactPortalProvider>(
        create: (context) => ContactPortalProvider(),
      ),
      ChangeNotifierProvider<SpeechToTextProvider>(
        create: (context) => SpeechToTextProvider(),
      ),
      ChangeNotifierProvider<MiscellaneousProvider>(
        create: (context) => MiscellaneousProvider(),
      ),
      ChangeNotifierProvider<SalahTimesProvider>(
        create: (context) => SalahTimesProvider(),
      ),
    ], child: const MyApp()),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///these lines disable the landscapeMode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        // debugShowCheckedModeBanner: false,
        title: 'al - Qur\'an',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Provider.of<ThemeProvider>(context).appBarColor,

            // color: Colors.red,
          ),
          scaffoldBackgroundColor: Colors.transparent,
        ),
        home: const MainScreenNavigator(),
      );
    });
  }
}
