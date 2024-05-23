import 'package:al_quran/screens/legal/credits.dart';
import 'package:al_quran/screens/legal/privacy_policy.dart';
import 'package:al_quran/screens/legal/terms_of_use.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';

class AboutUS extends StatefulWidget {
  final cmh;
  final cmw;

  const AboutUS({Key? key, required this.cmw, required this.cmh})
      : super(key: key);

  @override
  State<AboutUS> createState() => _AboutUSState();
}

class _AboutUSState extends State<AboutUS> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return Padding(
      padding: EdgeInsets.all(widget.cmh * 0.021),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Text(
              'About US',
              style: GoogleFonts.roboto(
                  color: themeProvider.settingsItemTitleFontColor,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.cmh * 0.020),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: widget.cmh * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              legalItems(
                themeProvider,
                context,
                itemTitle: 'Privacy Policy',
                onPressedFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              legalItems(
                themeProvider,
                context,
                itemTitle: 'CREDITS',
                onPressedFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreditsScreen(),
                    ),
                  );
                },
              ),
              legalItems(
                themeProvider,
                context,
                itemTitle: 'TERMS OF USE',
                onPressedFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsOfUseScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          legalItems(themeProvider, context,
              itemTitle: 'App Version  ${settingsProvider.appVersion}',
              onPressedFunction: null),

          ///**********************************
          ///**********************************
          /// here is the Rate app / more apps button and developer website link
          ///*******************************************
          ///*******************************************
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // legalItems(
              //   themeProvider,
              //   context,
              //   itemTitle: 'Rate App',
              //   onPressedFunction: () async {},
              // ),
              legalItems(
                themeProvider,
                context,
                itemTitle: 'More Apps',
                onPressedFunction: () async {
                  const url =
                      "https://play.google.com/store/apps/developer?id=SpicierEwe";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    // can't launch url, there is some error
                    throw "Could not launch $url";
                  }
                },
              ),
              legalItems(
                themeProvider,
                context,
                itemTitle: 'Resources',
                onPressedFunction: () async {
                  const url = "https://islamic-dev-repo.vercel.app/";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    // can't launch url, there is some error
                    throw "Could not launch $url";
                  }
                },
              ),
              legalItems(
                themeProvider,
                context,
                itemTitle: 'Developer\'s Website',
                onPressedFunction: () async {
                  const url = "https://spicierewe.vercel.app/";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    // can't launch url, there is some error
                    throw "Could not launch $url";
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget legalItems(ThemeProvider themeProvider, BuildContext context,
      {required itemTitle, required onPressedFunction}) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: widget.cmw * 0.03),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.cmh * 0.019),
            side: BorderSide(color: Colors.blueGrey.withOpacity(.5), width: 1)),
        backgroundColor: themeProvider.settingsItemContainerColor,
      ),
      onPressed: onPressedFunction,
      child: Text(
        '$itemTitle',
        style: TextStyle(color: Colors.blueGrey, fontSize: 10.5.sp),
      ),
    );
  }
}
