import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/providers/salah_times_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../providers/theme_provider.dart';

class SalahTimesDisplayScreen extends StatefulWidget {
  const SalahTimesDisplayScreen({Key? key}) : super(key: key);

  @override
  State<SalahTimesDisplayScreen> createState() =>
      _SalahTimesDisplayScreenState();
}

class _SalahTimesDisplayScreenState extends State<SalahTimesDisplayScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SalahTimesProvider salahTimesProvider =
        Provider.of<SalahTimesProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    ///

    Color highlightedFontColor = Colors.white;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cmh = constraints.maxHeight;
        final cmw = constraints.maxWidth;

        return Scaffold(
          backgroundColor: themeProvider.scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: cmw * .05,
                    right: cmw * .05,
                    top: cmh * .025,
                    bottom: cmh * .007,
                  ),
                  padding: EdgeInsets.only(
                    left: cmw * .05,
                    right: cmw * .05,
                    top: cmh * .017,
                    bottom: cmh * .011,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(cmh * 0.05),
                    ),
                    border: Border.all(
                        color:
                            themeProvider.salahTimesMainSalahCardBorderColor),
                    // color: themeProvider.scaffoldBackgroundColor,
                    ///decoration image is here
                    // image: DecorationImage(
                    //     image: salahTimesProvider.decorationImageLink,
                    //     fit: BoxFit.cover,
                    //     alignment: Alignment.center),

                    color: themeProvider.salahTimesMainSalahCardContainerColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.35),
                        offset: const Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  left: cmw * .05,
                                  right: cmw * .05,
                                  top: cmh * .003,
                                  bottom: cmh * .0073,
                                ),
                                decoration: BoxDecoration(
                                  //todo change current background color
                                  color: const Color(0xff223C63),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(cmh * 0.025),
                                    topRight: Radius.circular(cmh * 0.025),
                                  ),
                                ),
                                //
                                // todo current
                                child: smallTitles(
                                    title: salahTimesProvider.upcoming
                                        ? 'upcoming'
                                        : 'current',
                                    fontWeight: FontWeight.bold,
                                    fontColor: Color(0xffFFFFFF)),
                              ),
                              SizedBox(height: cmh * 0.0125),
                              //
                              // todo current Salah Name

                              Text(
                                salahTimesProvider.currentSalahName.toString(),
                                style: TextStyle(
                                    fontFamily: "Segoe_UI",
                                    color: themeProvider
                                        .salahTimesMainSalahNameColor,
                                    fontSize: 29.sp),
                              ),
                              SizedBox(height: cmh * 0.007),
                              //

                              smallTitles(
                                title: salahTimesProvider.upcoming
                                    ? 'STARTS IN'
                                    : 'ENDS IN',
                                fontWeight: FontWeight.bold,
                                fontColor:
                                    themeProvider.salahTimesLightGreyColor,
                              ),
                              SizedBox(height: cmh * 0.007),
                              Text(
                                "- ${salahTimesProvider.remainingTime}",
                                // '-03:32:00',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  color: Color(0xff707070),
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ],
                      ),

                      ///get location button
                      Container(
                        // color: Colors.pink,
                        margin: EdgeInsets.only(left: cmw * 0.749),
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  're-Fetching',
                                  style: TextStyle(fontSize: 11.sp),
                                  textAlign: TextAlign.center,
                                )));
                            salahTimesProvider.checkInternet();
                          },
                          child: Icon(Icons.my_location,
                              // color: Color(0xff707070),
                              color: themeProvider.salahTimeMetaInfoColor),
                        ),
                      ),
                    ],
                  ),
                ),

                /// here is the second part where address and data and arabic date is shown
                SizedBox(
                  height: cmh * 0.05,
                ),

                ///here is the address displayed
                Padding(
                  padding: EdgeInsets.only(
                      left: cmw * 0.061,
                      right: cmw * 0.05,
                      bottom: cmh * 0.007),
                  child: Text(
                    'o ${'${salahTimesProvider.subLocality}, ${salahTimesProvider.locality}, ${salahTimesProvider.postalCode}'}',
                    style: TextStyle(
                      color: themeProvider.salahTimeMetaInfoColor,
                      fontSize: 9.5.sp,
                    ),
                  ),
                ),
                // SizedBox(height: cmh * 0.0015),
                Divider(
                  // color: themeProvider.salahTimesLightGreyColor.withOpacity(.35)  ,
                  color: themeProvider.translatorDividerColor,
                ),
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      salahTimesProvider.fullTodayDate['english_date']
                          .toString(),
                      style: TextStyle(
                          color: themeProvider.salahTimesEnglishDateColor,
                          fontSize: 13.5.sp,
                          fontFamily: "Segoe_UI",
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: cmh * 0.01),
                    Text(
                      salahTimesProvider.fullTodayDate['hijri_date'].toString(),
                      style:
                          TextStyle(fontSize: 11.sp, color: Color(0xff707070)),
                    ),
                  ],
                ),
                Divider(
                  color: themeProvider.translatorDividerColor,
                ),

                /// here is the second part where all the salah times are displayed
                ///
                SizedBox(
                  height: cmh * 0.015,
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: RemoveListViewGlow(),
                    child: ListView.builder(
                        itemCount: salahTimesProvider
                            .salahTimesTwelveHourFormatArray.length,
                        itemBuilder: (context, index) {
                          final salahTimesArray = salahTimesProvider
                              .salahTimesTwelveHourFormatArray;
                          return Container(
                            padding: EdgeInsets.only(
                              left: cmw * 0.07,
                              right: cmw * 0.07,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    top: cmh * 0.015,
                                    bottom: cmh * 0.015,
                                    left: cmw * 0.03,
                                    right: cmw * 0.03,
                                  ),
                                  color: index ==
                                          salahTimesProvider
                                              .highLightSalahTimeIndex
                                      ? themeProvider
                                          .salahTimesHighlightSalahContainerColor
                                      : null,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          salahTimesArray[index]['salah_name']
                                              .toString(),
                                          style: TextStyle(
                                              //
                                              // todo white 1st font color

                                              color: index ==
                                                      salahTimesProvider
                                                          .highLightSalahTimeIndex
                                                  ? highlightedFontColor
                                                  : themeProvider
                                                      .salahTimesBlackColor,
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          salahTimesArray[index]['salah_time']
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,

                                            //
                                            // todo white 2rd time  font color

                                            color: index ==
                                                    salahTimesProvider
                                                        .highLightSalahTimeIndex
                                                ? highlightedFontColor
                                                : themeProvider
                                                    .salahTimesBlackColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          salahTimesArray[index]['unit']
                                              .toString(),
                                          style: TextStyle(
                                            //
                                            // todo white 3rd unit  font color

                                            color: index ==
                                                    salahTimesProvider
                                                        .highLightSalahTimeIndex
                                                ? highlightedFontColor
                                                : themeProvider
                                                    .salahTimesBlackColor,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),
          ),
        );

        // return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget smallTitles(
      {required String title,
      required Color fontColor,
      required FontWeight fontWeight}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11.5.sp,
        fontWeight: fontWeight,
        color: fontColor,
        fontFamily: 'Segoe_UI',
      ),
    );
  }
}
