import 'package:al_quran/providers/settings_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:al_quran/screens/contact_us_screens/contact_us_screen.dart';
import 'package:al_quran/screens/contact_us_screens/report_screen.dart';
import 'package:al_quran/screens/contact_us_screens/suggest_feature_screen.dart';
import 'package:al_quran/screens/favourites_display_screen/favourites_display_screen.dart';
import 'package:al_quran/screens/settings/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

///
Widget menuItems({required mq, required cmh, required cmw, required context}) {
  SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
  var themeProvider = Provider.of<ThemeProvider>(context);
  return PopupMenuButton<String>(
      color: themeProvider.menuBackgroundColor,
      tooltip: "More Options",
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cmh * 0.01)),
      onSelected: (selected) {
        print(selected);
        switch (selected) {

          /// if ascending
          case 'Sort : ascending':
            {
              settingsProvider.updateIsDescendingBool(true);
              print("this is ascending");
              return;
            }
          case 'Sort : descending':
            {
              settingsProvider.updateIsDescendingBool(false);
              print("this is descending");
              return;
            }
          case "Suggest Feature":
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SuggestAFeatureScreen()));
              return;
            }
          case "Contact Us":
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactUsScreen()));
              return;
            }
          case "Report":
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReportScreen()));
              return;
            }
          case 'Settings':
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
              return;
            }
        }
      },
      itemBuilder: (BuildContext context) {
        List icons = [
          const Icon(Icons.sort, color: Color(0xff333333)),
          const Icon(Icons.lightbulb_outlined, color: Colors.deepOrange),
          const Icon(Icons.person, color: Colors.orange),
          const Icon(
            Icons.warning,
            color: Colors.red,
          ),
          const Icon(Icons.settings, color: Color(0xff333333)),
        ];

        return {
          'Sort : ${settingsProvider.isDescending ? "descending" : "ascending"}',
          "Suggest Feature",
          "Contact Us",
          "Report",
          'Settings'
        }.map((String choice) {
          return PopupMenuItem<String>(
            padding: EdgeInsets.symmetric(horizontal: cmw * 0.015),
            value: choice,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: cmw * 0.035),
                  child: (choice ==
                          "Sort : ${settingsProvider.isDescending ? "descending" : "ascending"}"
                      ? icons[0]
                      : choice == "Suggest Feature"
                          ? icons[1]
                          : choice == "Contact Us"
                              ? icons[2]
                              : choice == "Report"
                                  ? icons[3]
                                  : choice == 'Settings'
                                      ? icons[4]
                                      : ""),
                ),
                Container(
                    margin: EdgeInsets.only(
                      // right: cmw * 0.025,
                      left: cmw * 0.035,
                    ),
                    child: Text(
                      choice,
                      style: TextStyle(fontSize: 11.5.sp),
                    ))
              ],
            ),
          );
        }).toList();
      });
}

/// custom Text Widget widget
Widget customTextButton(
    {required onPressed,
    required Widget child,
    required double cmh,
    required double cmw}) {
  return TextButton(
    style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(
            horizontal: cmw * 0.05, vertical: cmh * 0.045)),
    onPressed: onPressed,
    child: child,
  );
}
//Padding(
//         padding: EdgeInsets.only(
//           top: mq.height * 0.035,
//           // left: cmw*0.03,
//           // right: cmw*0.03
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             customTextButton(
//               cmh: cmh,
//               cmw: cmw,
//
//               /// oppressed #1
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => const ReportScreen(),
//                 ));
//               },
//               child: Row(
//                 children: [
//                   const Icon(
//                     Icons.warning,
//                     color: Colors.red,
//                   ),
//                   SizedBox(
//                     width: mq.width * 0.05,
//                   ),
//                   Text(
//                     'Report',
//                     style: TextStyle(fontSize: 14.1.sp),
//                   ),
//                 ],
//               ),
//             ),
//             customTextButton(
//               cmh: cmh,
//               cmw: cmw,
//
//               /// oppressed #2
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const FavouritesDisplayScreen(),
//                     ));
//               },
//               child: Row(
//                 children: [
//                   const Icon(Icons.star),
//                   SizedBox(
//                     width: mq.width * 0.05,
//                   ),
//                   Text(
//                     'Favourite Verses',
//                     style: TextStyle(fontSize: 14.1.sp),
//                   ),
//                 ],
//               ),
//             ),
//             customTextButton(
//               cmh: cmh,
//               cmw: cmw,
//
//               /// oppressed #3
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => const SuggestAFeatureScreen(),
//                 ));
//               },
//               child: Row(
//                 children: [
//                   const Icon(Icons.lightbulb_outlined,
//                       color: Colors.deepOrange),
//                   SizedBox(
//                     width: mq.width * 0.05,
//                   ),
//                   Text(
//                     'Suggest a Feature',
//                     style: TextStyle(fontSize: 14.1.sp),
//                   ),
//                 ],
//               ),
//             ),
//             customTextButton(
//               cmh: cmh,
//               cmw: cmw,
//
//               /// oppressed #4
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => const ContactUsScreen(),
//                 ));
//               },
//               child: Row(
//                 children: [
//                   const Icon(Icons.person, color: Colors.orange),
//                   SizedBox(
//                     width: mq.width * 0.05,
//                   ),
//                   Text(
//                     'Contact_us',
//                     style: TextStyle(fontSize: 14.1.sp),
//                   ),
//                 ],
//               ),
//             ),
//             ///settings
//             customTextButton(
//                 cmh: cmh,
//                 cmw: cmw,
//
//                 /// oppressed #5
//                 onPressed: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const SettingsScreen()),
//                   );
//                 },
//                 child: Row(
//                   children: [
//                     const Icon(Icons.settings),
//                     SizedBox(
//                       width: mq.width * 0.05,
//                     ),
//                     Text(
//                       'Settings',
//                       style: TextStyle(fontSize: 14.1.sp),
//                     ),
//                   ],
//                 ),
//               ),
//
//           ],
//         ),
//       );
