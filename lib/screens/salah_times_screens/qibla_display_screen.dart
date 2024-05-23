import 'package:al_quran/providers/salah_times_provider.dart';

import "package:flutter_compass/flutter_compass.dart";
import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../components/remove_listview_glow/remove_listview_glow.dart';
import '../../providers/theme_provider.dart';

class QiblaCompassDisplayScreen extends StatefulWidget {
  const QiblaCompassDisplayScreen({Key? key}) : super(key: key);

  @override
  State<QiblaCompassDisplayScreen> createState() =>
      _QiblaCompassDisplayScreenState();
}

class _QiblaCompassDisplayScreenState extends State<QiblaCompassDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    ///providers
    SalahTimesProvider salahTimesProvider =
        Provider.of<SalahTimesProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return LayoutBuilder(builder: (context, constraints) {
      final cmh = constraints.maxHeight;
      final cmw = constraints.maxWidth;
      return currentPrayerCard(
          salahTimesProvider: salahTimesProvider,
          themeProvider: themeProvider,
          cmh: cmh,
          cmw: cmw,
          context: context);
    });
  }
}

Widget _buildCompass({
  required cmh,
  required cmw,
  required SalahTimesProvider salahTimesProvider,
  required ThemeProvider themeProvider,
}) {
  return StreamBuilder<CompassEvent>(
    stream: FlutterCompass.events,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error reading heading: ${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // double? direction = snapshot.data!.heading;
      double? direction = (snapshot.data!.heading);

      // if direction is null, then device does not support this sensor
      // show error message
      if (direction == null) {
        return const Center(
          child: Text("Device does not have sensors !"),
        );
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: cmh * 0.45,
                  width: cmh * 0.45,
                  child: Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,

                    elevation: 4.0,
                    // color: Colors.red,
                    child: Center(
                      child: Container(
                        ///outer margin color
                        color: themeProvider.salahTimesCompassOuterMarginColor,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(cmh * 0.01),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  ///inner margin color
                                  color: themeProvider
                                      .salahTimesCompassInnerMarginColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),

                            ///this the compass background the margin colors
                            Padding(
                              padding: EdgeInsets.all(cmh * 0.03),
                              child: Container(
                                // padding: EdgeInsets.all(16.0),
                                alignment: Alignment.center,

                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),

                            ///this is the compass containing the directions
                            Transform.rotate(
                              angle: ((direction) * (math.pi / 180) * -1),
                              child: Container(
                                // padding: EdgeInsets.all(16.0),

                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'images/compass_images/compass.png'),
                                  ),
                                  // color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),

                            ///this is the needle of the compass
                            Container(
                              padding: EdgeInsets.all(cmh * 0.015),
                              decoration: const BoxDecoration(
                                // color: Colors.red,

                                // color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Transform.rotate(
                                angle: ((direction -
                                        salahTimesProvider.qiblaDirection) *
                                    (math.pi / 180) *
                                    -1),
                                child: Image.asset(
                                    'images/compass_images/compass_needle.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: cmh * 0.05,
                ),
                Text(
                  ("Qibla is  ${salahTimesProvider.qiblaDirection.toStringAsFixed(2)} ° from North ")
                      .toUpperCase(),
                  style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ],
      );
      // );
    },
  );
}

Widget currentPrayerCard({
  required SalahTimesProvider salahTimesProvider,
  required ThemeProvider themeProvider,
  required cmh,
  required cmw,
  required context,
}) {
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
                  color: themeProvider.salahTimesMainSalahCardBorderColor),
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
                              color: themeProvider.salahTimesMainSalahNameColor,
                              fontSize: 29.sp),
                        ),
                        SizedBox(height: cmh * 0.007),
                        //

                        smallTitles(
                          title: salahTimesProvider.upcoming
                              ? 'STARTS IN'
                              : 'ENDS IN',
                          fontWeight: FontWeight.bold,
                          fontColor: themeProvider.salahTimesLightGreyColor,
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          're-fetching Location',
                        textAlign: TextAlign.center,),
                      ));
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
            height: cmh * 0.03,
          ),

          ///here is the address displayed
          Padding(
            padding: EdgeInsets.only(
              left: cmw * 0.061,
              right: cmw * 0.05,
            ),
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
          Expanded(
              child: _buildCompass(
                  cmh: cmh,
                  cmw: cmw,
                  salahTimesProvider: salahTimesProvider,
                  themeProvider: themeProvider))

          /// here is the second part where all the salah times are displayed
          ///
        ],
      ),
    ),
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
