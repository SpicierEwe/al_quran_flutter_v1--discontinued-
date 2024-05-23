import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/theme_provider.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final cmh = constraints.maxHeight;
        final cmw = constraints.maxWidth;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'PRIVACY POLICY',
              style: TextStyle(fontSize: 14.1.sp),
            ),
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              permissionsInfo(
                  cmh: cmh,
                  cmw: cmw,
                  title: 'Needed Access Microphone (OPTIONAL)',
                  description:
                      'The Microphone is NEEDED while searching Al quran in the MORE SECTION SEARCH . You only need to enable microphone if you want to search the al-quran with your voice , otherwise you can completely neglect the microphone and can TYPE TO SEARCH.'),
              permissionsInfo(
                  cmh: cmh,
                  cmw: cmw,
                  title: 'REQUIRES INTERNET TO PLAY AUDIO',
                  description:
                      'The App is Completely OFFLINE but the need of INTERNET is because of the audio files. Streaming audio files takes much less time and internet these days . I\'ve kept the audio PLAYABLE only by INTERNET because it was impossible to supply them offline cause of VAST MAJORITY of RECITER CHOICES.'),
              permissionsInfo(
                  cmh: cmh,
                  cmw: cmw,
                  title: 'REQUIRES Location Permissions',
                  description:
                      'Requires location permissions to fetch salah times and Qibla direction according tou you location.'),
              permissionsInfo(
                  cmh: cmh,
                  cmw: cmw,
                  title: 'Regarding your Private Information',
                  description:
                      'We do not Collect Any of Your Data either knowingly or unknowingly, and why would we ? I haven\'t created this app to ruin myself On the Day of Judgement but rather to be close to my Lord The Most High (Allahuakabar) , May Allah (The Almighty) Forgive us all and admit us all to Jannatul Firdausi al aala.'),
              const Text('*** * ***'),
              TextButton(
                child: Text(
                  'Privacy - Policy',
                  style: TextStyle(fontSize: 10.5.sp),
                ),
                onPressed: () async {
                  const url =
                      "https://spicierewe.vercel.app/al-Qur'an/privacy-policy";
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
        );
      },
    );
  }

  Padding permissionsInfo(
      {required title, required description, required cmh, required cmw}) {
    return Padding(
      padding: EdgeInsets.only(
        left: cmh * 0.03,
        right: cmh * 0.03,
        top: cmh * 0.015,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '$title',
            style: GoogleFonts.raleway(
                fontSize: 13.sp, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: cmh * 0.01,
          ),
          Text(
            '$description',
            style: GoogleFonts.raleway(fontSize: 11.sp),
            textAlign: TextAlign.left,
          ),
          Divider(),
        ],
      ),
    );
  }
}
