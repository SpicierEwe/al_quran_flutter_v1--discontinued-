import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/providers/salah_times_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../screens/salah_times_screens/hijri_calendar_display_screen.dart';
import '../../screens/salah_times_screens/qibla_display_screen.dart';
import '../../screens/salah_times_screens/salah_times_display_screen.dart';

class SalahTimesNavigator extends StatefulWidget {
  const SalahTimesNavigator({Key? key}) : super(key: key);

  @override
  State<SalahTimesNavigator> createState() => _SalahTimesNavigatorState();
}

class _SalahTimesNavigatorState extends State<SalahTimesNavigator> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  _onItemTapped(index) {
    setState(() {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
      // _selectedIndex = index;
    });
  }

  ///init state is here
  @override
  void initState() {
    print('init  ran');

    // Provider.of<SalahTimesProvider>(context, listen: false).checkInternet();
    Provider.of<SalahTimesProvider>(context, listen: false).fetchSavedData();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    SalahTimesProvider salahTimesProvider =
    Provider.of<SalahTimesProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final cmh = constraints.maxHeight;
        final cmw = constraints.maxWidth;

        ///if no internet this is returned
        if (salahTimesProvider.noInternet) {
          return Scaffold(
            backgroundColor: themeProvider.scaffoldBackgroundColor,
            body: Padding(
              padding: EdgeInsets.all(cmh * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.signal_cellular_connected_no_internet_4_bar),
                  SizedBox(
                    height: cmh * 0.015,
                  ),
                  Center(
                      child: Text(
                        'No Internet',
                        style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                      )),
                  Center(
                      child: Text(
                        '\n It seems you don\'t have a working Internet',
                        style: TextStyle(fontSize: 11.sp),
                      )),
                  TextButton(
                    onPressed: () {
                      salahTimesProvider.checkInternet();
                    },
                    child: Text(
                      'Try Again',
                      style: TextStyle(fontSize: 11.5.sp),
                    ),
                    // style: ButtonStyle(backgroundColor: MaterialStateProperty.all(red)),
                  )
                ],
              ),
            ),
          );
        }

        if (!salahTimesProvider.noInternet &&
            salahTimesProvider.salahTimesTwelveHourFormatArray.isNotEmpty &&
            salahTimesProvider.currentSalahName.isNotEmpty) {
          return Scaffold(
            // backgroundColor: themeProvider.scaffoldBackgroundColor,
              backgroundColor: themeProvider.scaffoldBackgroundColor,
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: themeProvider.scaffoldBackgroundColor,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.access_time,
                      size: cmh * 0.0283,
                    ),
                    label: 'Salah Times',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.compass_calibration,
                      size: cmh * 0.027,
                    ),
                    label: 'Qibla',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.calendar_today,
                      size: cmh * 0.027,
                    ),
                    label: 'Calendar',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor:
                themeProvider.salahTimesBottomAppBarIconColor,
                unselectedItemColor: themeProvider
                    .salahTimesBottomAppBarIconColor
                    .withOpacity(.3),
                // backgroundColor: themeProvider.navBarColor,
                showUnselectedLabels: false,
                showSelectedLabels: false,
                // selectedItemColor: themeProvider.primary,
                onTap: _onItemTapped,
              ),
              body: ScrollConfiguration(
                behavior: RemoveListViewGlow(),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  children: const [
                    SalahTimesDisplayScreen(),
                    QiblaCompassDisplayScreen(),
                    HijriCalendarDisplayScreen(),
                  ],
                ),
              ));
        }

        return Scaffold(
          backgroundColor: themeProvider.scaffoldBackgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(
                  color: themeProvider.circularProgressIndicatorColor,
                ),
              ),
              SizedBox(
                height: cmh * 0.035,
              ),
            ],
          ),
        );
      },
    );
  }
}
