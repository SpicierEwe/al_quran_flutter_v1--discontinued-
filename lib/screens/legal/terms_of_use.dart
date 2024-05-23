import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cmh = constraints.maxHeight;
      final cmw = constraints.maxWidth;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: const Text('TERMS OF USE'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: cmh * 0.03,
                right: cmh * 0.05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: cmh * 0.05,
                      bottom: cmh * 0.05,
                    ),
                    child: Text(
                      'AL-QURAN : TERMS OF USE',
                      style: GoogleFonts.raleway(fontSize: 15.sp),
                    ),
                  ),
                  Text(
                    'All Thanks to Allah (alahamdulillah). Welcome to al-Qur\'an app . We have indeed created this app out of love of ALLAH SUBAHANAHU-WATAALA.\n\nThis al-Quran app thereby completely FREE The DEVELOPER does\'nt charge anything, our reward is only with ALLAH and also please Remember us in your Dua\'s.',
                    style: GoogleFonts.raleway(fontSize: 11.sp),
                  ),
                  SizedBox(height: cmh * 0.05),
                  Text(
                    'Some Important conditions for the OTHER DEVELOPERS.',
                    style: GoogleFonts.raleway(fontSize: 13.sp),
                  ),
                  SizedBox(
                    height: cmh * 0.01,
                  ),
                  conditionalPoints(
                      condition:
                          'We would Discourage Cloning of the APP rather we would invite you to contribute in this app to make it BETTER.',
                      cmh: cmh,
                      cmw: cmw),
                  conditionalPoints(
                      condition:
                          'The Data in this app is Free to use but Any MISUSE of the data by anyone is Not Our responsibility. HE/She is alone responsible for this grave sin.',
                      cmh: cmh,
                      cmw: cmw),
                  conditionalPoints(
                      condition:
                          'Any SELLING of the APP or Cloning of the the app and embedding it with Ads and then distributing is COMPLETELY PROHIBITED . You will be faced with LEGAL CHARGES if caught doing the following.',
                      cmh: cmh,
                      cmw: cmw),
                  SizedBox(
                    height: cmh * 0.035,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        cmh * 0.05, cmh * 0.03, cmh * 0.05, cmh * 0.05),
                    child: Text(
                      'Lastly , FEAR ALLAH MY FRIEND , Please DO not RUIN Yourself on just a Small worldly Gain and seek Forgiveness from ALLAh for you and for me and for every other BELIEVER.',
                      style: GoogleFonts.raleway(fontSize: 11.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Padding conditionalPoints({required condition, required cmh, required cmw}) {
    return Padding(
      padding: EdgeInsets.only(
        top: cmh * 0.015,
        // bottom: cmh * 0.01,
        right: cmh * 0.05,
        left: cmh * 0.05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              const Text(
                '(*)',
                // style: TextStyle(fontSize: 19.sp),
              ),
              SizedBox(
                width: cmw * 0.05,
              ),
              Expanded(
                child: Text(
                  '$condition',
                  style: GoogleFonts.raleway(fontSize: 11.sp),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
