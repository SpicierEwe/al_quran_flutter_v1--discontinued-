import 'package:al_quran/Navigators/salah_times_navigators/salah_times_navigator.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:al_quran/screens/more_section/allah_names_display_screen.dart';
import 'package:al_quran/screens/more_section/rabbana_duas_display_screen.dart';
import 'package:al_quran/screens/more_section/rasool_allah_names_display_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../search_screens/search_screen.dart';
import '../updates_screen.dart';

class MoreDisplayScreen extends StatefulWidget {
  const MoreDisplayScreen({Key? key}) : super(key: key);

  @override
  _MoreDisplayScreenState createState() => _MoreDisplayScreenState();
}

class _MoreDisplayScreenState extends State<MoreDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var mq = MediaQuery.of(context).size;
    return SizedBox(
      height: mq.height -
          (AppBar().preferredSize.height + MediaQuery.of(context).padding.top),
      child: LayoutBuilder(
        builder: (context, constraints) {
          var cmh = constraints.maxHeight;
          var cmw = constraints.maxWidth;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(top: cmh * 0.1),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    itemContainer(
                        imageName: 'bg10',
                        title: '        ALLAH NAMES',
                        height: 0.2,
                        width: 0.4,
                        cmh: cmh,
                        cmw: cmw,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AllahNamesScreen(),
                            ),
                          );
                        }),
                    SizedBox(
                      height: cmh * 0.02,
                    ),
                    itemContainer(
                        imageName: 'bg2',
                        title: 'DUA\'S',
                        secondaryTitle: 'RABBANA DUAS IN \n THE QUR\'AN',
                        height: 0.35,
                        width: 0.4,
                        cmh: cmh,
                        cmw: cmw,
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RabbanaDuasDisplayScreen()));
                        }),
                    SizedBox(
                      height: cmh * 0.02,
                    ),
                    itemContainer(
                      imageName: 'bg29',
                      title: 'SEARCH',
                      height: 0.05,
                      width: 0.4,
                      cmh: cmh,
                      cmw: cmw,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
                            ));
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: cmw * 0.025,
              ),
              Padding(
                padding: EdgeInsets.only(top: cmh * 0.1),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    itemContainer(
                        imageName: 'bg4',
                        title: 'SALAH TIMES',
                        // secondaryTitle: 'The times of the\nsalah'.toUpperCase(),
                        // optionalSecondaryTitleColor: Colors.red,
                        height: 0.35,
                        width: 0.4,
                        cmh: cmh,
                        cmw: cmw,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SalahTimesNavigator(),
                              ));
                        }),
                    SizedBox(
                      height: cmh * 0.02,

                      ///todo
                    ),
                    itemContainer(
                        imageName: 'bg12',
                        title: 'RASOOL ALLAH \nNAMES',
                        height: 0.2,
                        width: 0.4,
                        cmh: cmh,
                        cmw: cmw,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RasoolAllahNamesScreen(),
                              ));
                        }),
                    SizedBox(
                      height: cmh * 0.02,
                    ),
                    itemContainer(
                        imageName: 'bg16',
                        title: 'UPDATES',
                        height: 0.05,
                        width: 0.4,
                        cmh: cmh,
                        cmw: cmw,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UpdatesScreen()));
                        }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget itemContainer(
      {onPressed,
      cmh,
      cmw,
      required String imageName,
      required double height,
      required double width,
      required String title,
      secondaryTitle,
      optionalSecondaryTitleColor}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cmh * 0.02),
          boxShadow: [
            BoxShadow(
              color: Provider.of<ThemeProvider>(context).darkTheme == false
                  ? Colors.grey
                  : Colors.transparent,
              // spreadRadius: .1,
              blurRadius: 5,
              // spreadRadius: -.5,
            )
          ],
          image: DecorationImage(
              image: AssetImage("images/backgrounds/$imageName.jpg"),
              fit: BoxFit.cover)),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cmh * 0.02)),
          padding: EdgeInsets.all(cmh * 0.01),
          foregroundColor: Color(0xff333333),
        ),
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(cmh * 0.02)),
        // padding: EdgeInsets.all(cmh * 0.01),
        // color: Colors.grey,
        onPressed: onPressed,
        child: SizedBox(
          height: cmh * height,
          width: cmw * width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///title here
              Center(
                child: Text(
                  title,
                  style: GoogleFonts.openSans(fontSize: 11.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: cmh * 0.01,
              ),
              if (secondaryTitle != null)
                Text(
                  secondaryTitle,
                  style: TextStyle(
                      fontSize: 8.5.sp, color: optionalSecondaryTitleColor),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
