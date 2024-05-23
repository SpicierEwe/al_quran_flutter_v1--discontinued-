import 'dart:convert';
import 'package:al_quran/providers/juz_provider.dart';
import 'package:flutter/services.dart' as services;

import 'package:al_quran/Navigators/change_reciter_navigator.dart';
import 'package:al_quran/components/make_values_permanet_class/make_arabic_type_permanent_class.dart';
import 'package:al_quran/components/make_values_permanet_class/make_font_sizes_permanent_class.dart';
import 'package:al_quran/components/make_values_permanet_class/make_reciter_permanent.dart';
import 'package:al_quran/components/quran_db_class/quran_indopak_script_class.dart';
import 'package:al_quran/providers/audio_provider.dart';
import 'package:al_quran/providers/data_provider.dart';
import 'package:al_quran/providers/favourites_provider.dart';
import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../quran_db_class/quran_db_class.dart';

class MushafSettings extends StatefulWidget {
  final cmh;
  final cmw;

  const MushafSettings({Key? key, required this.cmw, required this.cmh})
      : super(key: key);

  @override
  _MushafSettingsState createState() => _MushafSettingsState();
}

class _MushafSettingsState extends State<MushafSettings> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _value = int.parse(Provider.of<AudioProvider>(context, listen: false)
      //     .recitationStyleValue);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var audioProvider = Provider.of<AudioProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    var favouritesProvider = Provider.of<FavouritesProvider>(context);
    var dataProvider = Provider.of<Data>(context);
    JuzProvider juzProvider = Provider.of<JuzProvider>(context);

    return Padding(
        padding: EdgeInsets.all(widget.cmh * 0.021),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ///settings arabic
          Text(
            'Mushaf Style ( Beta )',
            style: GoogleFonts.roboto(
                // color: const Color(0xff223C63),
                color: themeProvider.settingsItemTitleFontColor,
                fontWeight: FontWeight.bold,
                fontSize: widget.cmh * 0.020),
          ),
          SizedBox(
            height: widget.cmh * 0.025,
          ),

          ///show arabic switch
          Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: themeProvider.settingsBoxShadowColor,
                    blurRadius: 10,
                    spreadRadius: -3)
              ]),
              child: customTextButton(
                  cmw: widget.cmw,
                  cmh: widget.cmh,
                  themeProvider: themeProvider,
                  onPressed: () {},
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: widget.cmw * 0.02),
                          child: Text(
                            'Enable Mushaf Style',
                            style: GoogleFonts.roboto(
                                color: themeProvider.settingsItemFontColor,
                                fontSize: widget.cmh * 0.022,
                                textBaseline: TextBaseline.alphabetic),
                          ),
                        ),
                        SizedBox(
                          height: widget.cmh * 0.003,
                        ),

                        ///switch is here
                        Switch(
                          inactiveTrackColor:
                              themeProvider.settingsSwitchInactiveTrackColor,
                          activeColor: const Color(0xff223C63),
                          value: settingsProvider.displayMushafStyle,
                          onChanged: (value) {
                            setState(() async {
                              /// saving the selected value permanently here start **this func is dynamic applicable for arabic /translation/transliteration
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              await prefs.setBool("mushafStyle", value);
                              settingsProvider.showMushafStyleFunc(
                                  value: value);

                              ///func ended****************************
                            });
                          },
                        ),
                      ])))
        ]));
  }

  /// custom Text Widget widget
  Widget customTextButton(
      {required onPressed,
      required Widget child,
      required double cmh,
      required double cmw,
      required ThemeProvider themeProvider}) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.cmh * 0.019),
        ),
        backgroundColor: themeProvider.settingsItemContainerColor,
        padding: EdgeInsets.all(widget.cmh * 0.009),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
