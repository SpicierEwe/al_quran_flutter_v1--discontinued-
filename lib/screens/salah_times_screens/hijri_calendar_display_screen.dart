import 'dart:ffi';

import 'package:al_quran/providers/salah_times_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:al_quran/screens/settings/settings_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

class HijriCalendarDisplayScreen extends StatefulWidget {
  const HijriCalendarDisplayScreen({Key? key}) : super(key: key);

  @override
  State<HijriCalendarDisplayScreen> createState() =>
      _HijriCalendarDisplayScreenState();
}

class _HijriCalendarDisplayScreenState
    extends State<HijriCalendarDisplayScreen> {
  List weekdayNames = ['Sun', 'Mon', "Tue", "Wed", 'Thu', "Fri", "Sat"];
  List colorsList = [];

  aa() {
    List tt = [];
    for (int x = 0; x < 51; x++) {
      var color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0);
      tt.add(color);
    }
    return tt;
  }

  @override
  void initState() {
    colorsList = aa();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SalahTimesProvider salahTimesProvider =
        Provider.of<SalahTimesProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    ///custom box shadow
    BoxShadow customBoxShadow = BoxShadow(
        offset: const Offset(0, 3),
        // spreadRadius: 1,
        blurRadius: 8,
        color: themeProvider.salahTimesHijriCalendarShadowColor);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cmh = constraints.maxHeight;
        final cmw = constraints.maxWidth;

        return Scaffold(
          backgroundColor: themeProvider.salahTimesHijriCalendarScaffoldColor,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: cmh * 0.009,
                ),

                ///top en and ar months display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: cmw * 0.037,
                        right: cmw * 0.037,
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: salahTimesProvider
                                    .hijriCalendarMonthYear['hijri']['year']
                                    .toString(),
                                style: TextStyle(fontSize: 11.7.sp)),
                            WidgetSpan(child: SizedBox(height: cmh * 0.035)),
                            TextSpan(
                              text: '\n' +
                                  salahTimesProvider
                                      .hijriCalendarMonthYear['hijri']['month']
                                      .toString(),
                            ),
                          ],
                        ),
                        style: TextStyle(
                            color: themeProvider
                                .salahTimesHijriCalendarTopMonthFontColor,
                            fontSize: 16.5.sp),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: cmw * 0.037,
                        right: cmw * 0.037,
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: salahTimesProvider
                                    .hijriCalendarMonthYear['gregorian']['year']
                                    .toString(),
                                style: TextStyle(fontSize: 11.7.sp)),
                            WidgetSpan(child: SizedBox(height: cmh * 0.035)),
                            TextSpan(
                              text: '\n' +
                                  salahTimesProvider
                                      .hijriCalendarMonthYear['gregorian']
                                          ['month']
                                      .toString(),
                            ),
                          ],
                        ),
                        style: TextStyle(
                            color: themeProvider
                                .salahTimesHijriCalendarTopMonthFontColor,
                            fontSize: 16.5.sp),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                Divider(
                    thickness: cmh * 0.003,
                    color: themeProvider.salahTimesHijriCalendarDividerColor),
                SizedBox(
                  height: cmh * 0.021,
                ),
                SizedBox(
                    height: cmh * 0.05,
                    child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 0.5,
                        ),
                        children: [
                          for (var name in weekdayNames)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  name.toString(),
                                  style: TextStyle(
                                    fontSize: 10.5.sp,
                                    color: themeProvider
                                        .salahTimesHijriCalendarWeekdayTitlesFontColor,
                                  ),
                                ),
                              ],
                            )
                        ])),

                ///this grid view is responsible to display the calendar
                Expanded(
                  child: GridView.builder(
                    itemCount: salahTimesProvider.hijriCalendarData.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final currentDay =
                          DateTime.now().day.toString().padLeft(2, '0');

                      ///im checking if index is > and = elementsToSkip cause elements are 3 and as index is always length -1 so
                      ///in order to reach to 3 length index has to be of length 4
                      if (salahTimesProvider.elementsToSkip != null &&
                          (index >= salahTimesProvider.elementsToSkip)) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              shape: const CircleBorder(),
                              clipBehavior: Clip.antiAlias,

                              ///hijri day background color
                              color: currentDay ==
                                      salahTimesProvider
                                              .hijriCalendarData[index]
                                          ['gregorian']['day']
                                  ? const Color(0xffaaa375)
                                  : themeProvider
                                      .salahTimesHijriCalendarPastDatesBackgroundColor,
                              child: Container(
                                padding: EdgeInsets.all(cmh * 0.015),
                                child: Text(
                                  ///
                                  ///display hijri day text color here
                                  ///
                                  (salahTimesProvider.hijriCalendarData[index]
                                          ['gregorian']['day'])
                                      .toString(),
                                  style: TextStyle(
                                      color: currentDay ==
                                              salahTimesProvider
                                                      .hijriCalendarData[index]
                                                  ['gregorian']['day']
                                          ? Colors.white
                                          : null),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      ///this is displayed when elementsToSkip ==null (meaning no elements to SKIP)
                      if (salahTimesProvider.elementsToSkip == null) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              shape: const CircleBorder(),
                              clipBehavior: Clip.antiAlias,

                              ///hijri day background color
                              color: currentDay ==
                                      salahTimesProvider
                                              .hijriCalendarData[index]
                                          ['gregorian']['day']
                                  ? const Color(0xffaaa375)
                                  : themeProvider
                                      .salahTimesHijriCalendarPastDatesBackgroundColor,

                              child: Container(
                                padding: EdgeInsets.all(cmh * 0.015),
                                child: Text(
                                  ///
                                  ///display hijri day text color here
                                  ///
                                  (salahTimesProvider.hijriCalendarData[index]
                                          ['gregorian']['day'])
                                      .toString(),
                                  style: TextStyle(
                                      color: currentDay ==
                                              salahTimesProvider
                                                      .hijriCalendarData[index]
                                                  ['gregorian']['day']
                                          ? Colors.white
                                          : null),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const Text("");
                    },
                  ),
                ),

                ///*********************************************
                ///this is the 2 nd section of the screen where the today dates en and hijri are
                ///displayed and also the event ie the holidays are displayed
                ///**********************************************
                Expanded(
                    child: Column(
                  children: [
                    Container(
                      height: cmh * 0.003,
                      color: themeProvider.salahTimesHijriCalendarDividerColor,
                    ),
                    // Divider(
                    //   color: themeProvider.salahTimesHijriCalendarDividerColor,
                    //   thickness: cmh * 0.003,
                    // ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: salahTimesProvider.eventsData.length,
                        itemBuilder: (context, index) {
                          final eventsData = salahTimesProvider.eventsData;
                          // print(eventsData);
                          return Container(
                            // padding: EdgeInsets.all(cmh * 0.025),
                            padding: EdgeInsets.only(
                              left: cmw * 0.025,
                              right: cmw * 0.025,
                              top: cmh*0.015
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ///
                                ///title
                                ///
                                Text(
                                  index == 0 ? 'Today' : 'Upcoming',
                                  style: TextStyle(
                                    color: index == 0
                                        ? themeProvider
                                            .salahTimesHijriCalendarTodayTitlesFontColor
                                        : themeProvider
                                            .salahTimesHijriCalendarFontColor,
                                    fontSize: index == 0 ? 15.sp : 13.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: cmh * 0.03,
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                      // color: Colors.blue.shade100,
                                      ),
                                  child: Row(
                                    children: [
                                      /// left side

                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            // top:cmh*0.01,
                                            left: cmw * 0.159,
                                            // right: cmw * 0.05,
                                          ),
                                          child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: cmh * 0.007),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: themeProvider
                                                        .salahTimesHijriCalendarBorderColor),
                                                boxShadow: [customBoxShadow],
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        cmh * 0.015),
                                                    bottomLeft: Radius.circular(
                                                        cmh * 0.015)),
                                              ),
                                              child: Column(
                                                children: [
                                                  ///english weekday name here
                                                  Container(
                                                    width: cmw,
                                                    padding: EdgeInsets.only(
                                                      top: cmh * 0.003,
                                                      bottom: cmh * 0.003,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            spreadRadius: -1,
                                                            color: themeProvider
                                                                .salahTimesHijriCalendarShadowColor,
                                                            offset:
                                                                const Offset(
                                                                    0, 3),
                                                            blurRadius: 6)
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                cmh * 0.013),
                                                      ),
                                                      // color: const Color(
                                                      //     0xffaaa375),
                                                      ///here are the colors of the 2nd part weekdays
                                                      color: index == 0
                                                          ? const Color(
                                                              0xffaaa375)
                                                          : colorsList[index],
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        eventsData[index][
                                                                    'gregorian']
                                                                [
                                                                'weekday']['en']
                                                            .toString()
                                                            .substring(0, 3),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                            fontSize: 8.1.sp),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),

                                                  Center(
                                                    ///display current english  dates on right side
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: cmh * 0.005),
                                                      child: Text(
                                                          eventsData[index]
                                                                  ['gregorian']
                                                              ['day'],
                                                          style: TextStyle(
                                                              color: themeProvider
                                                                  .salahTimesHijriCalendarFontColor,
                                                              fontSize:
                                                                  11.5.sp)),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: cmw * 0.041,
                                      ),

                                      ///right side
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            right: cmw * 0.15,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: cmw * 0.019,
                                                top: cmh * 0.0075,
                                                bottom: cmh * 0.0075),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: themeProvider
                                                      .salahTimesHijriCalendarBorderColor),
                                              boxShadow: [customBoxShadow],
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(
                                                      cmh * 0.025),
                                                  bottomRight: Radius.circular(
                                                      cmh * 0.025)),
                                            ),
                                            child: Row(children: [
                                              Container(
                                                decoration:
                                                    BoxDecoration(boxShadow: [
                                                  BoxShadow(
                                                      spreadRadius: -3,
                                                      color: themeProvider
                                                          .salahTimesHijriCalendarShadowColor,
                                                      offset:
                                                          const Offset(0, 3),
                                                      blurRadius: 6)
                                                ]),
                                                child: Material(
                                                  ///here are the colors of the 2nd part hijri dates in a circle
                                                  color: index == 0
                                                      ? const Color(0xffaaa375)
                                                      : colorsList[index],

                                                  shape: const CircleBorder(),
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        cmh * 0.01),

                                                    ///hijri date in circle on the right shown here
                                                    child: Text(
                                                      eventsData[index]['hijri']
                                                          ['day'],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10.5.sp),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: cmw * 0.045),

                                              ///
                                              ///hijri week day displayed here
                                              ///
                                              Expanded(
                                                child: Text(
                                                  eventsData[index]['hijri']
                                                      ['weekday']['en'],
                                                  style: TextStyle(
                                                      color: themeProvider
                                                          .salahTimesHijriCalendarFontColor,
                                                      fontSize: 12.1.sp),
                                                  // maxLines: 1,
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: cmh * 0.03,
                                ),

                                /// here are displayed the event (holidays)
                                Text(
                                  'Events',
                                  style: TextStyle(
                                    color: index == 0
                                        ? themeProvider
                                            .salahTimesHijriCalendarTodayTitlesFontColor
                                        : themeProvider
                                            .salahTimesHijriCalendarFontColor,
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                for (var holiday in eventsData[index]['hijri']
                                    ['holidays'])
                                  displayHolidays(
                                      cmh: cmh,
                                      cmw: cmw,
                                      themeProvider: themeProvider,
                                      holiday: holiday),

                                if (eventsData[index]['hijri']['holidays']
                                    .isEmpty)
                                  displayHolidays(
                                      cmh: cmh,
                                      cmw: cmw,
                                      themeProvider: themeProvider,
                                      holiday: 'no events'),

                                SizedBox(
                                  height: cmh * 0.021,
                                ),

                                const Divider()
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  Column displayHolidays(
      {required double cmh,
      required double cmw,
      required ThemeProvider themeProvider,
      holiday}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: cmh * 0.021,
        ),
        Container(
            padding: EdgeInsets.all(cmh * 0.01),
            margin: EdgeInsets.only(
              left: cmw * 0.15,
              right: cmw * 0.15,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: themeProvider.salahTimesHijriCalendarShadowColor,
                      offset: const Offset(0, 3),
                      blurRadius: 8,
                      spreadRadius: -3)
                ],
                border: Border.all(
                    color: themeProvider.salahTimesHijriCalendarBorderColor
                        .withOpacity(.45)),
                borderRadius: BorderRadius.circular(cmh * 0.017)),
            child: Center(
                child: Text(
              holiday.toString(),
              style: TextStyle(
                  fontSize: 11.sp,
                  color: themeProvider.salahTimesHijriCalendarFontColor),
            ))),
      ],
    );
  }
}

// gridDelegate:
//                          const SliverGridDelegateWithFixedCrossAxisCount(
//                        crossAxisCount: 7,
//                        childAspectRatio: 1,
//                      ),
