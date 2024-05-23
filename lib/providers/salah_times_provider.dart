import 'dart:async';
import 'dart:convert';

import 'package:al_quran/providers/theme_provider.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:permission_handler/permission_handler.dart'
    hide PermissionStatus;
import 'package:shared_preferences/shared_preferences.dart';

class SalahTimesProvider extends ChangeNotifier {
  // var decorationImageLink;
  var timeData;
  var salahTimesTwelveHourFormatArray = [];
  var salahTimesTwentyFourHourFormatArray = [];

  ///
  var userLatitude;
  var userLongitude;

  ///

  ///
  ///check internet connection function
  bool noInternet = false;

  Future<bool> checkInternet() async {
    salahTimesTwelveHourFormatArray = [];
    print('this is the internet checker');
    bool status = false;
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      print('Has Internet');
      noInternet = false;
      status = true;

      print('now fetching the location');

      getLocation()
          .then((e) => print('the location function was completely finished'));
      fetchHijriCalendar();
    } else {
      print('No internet :( ');
      status = false;
      noInternet = true;
    }
    return status;
  }

  /// get Location

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  getLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted == PermissionStatus.deniedForever) {
          return await openAppSettings();
        }
      }
    }

    _locationData = await location.getLocation();

    ///
    ///here im assigning the latitudes and the longitudes to variables to use in the Qibla direction provider
    ///
    userLatitude = _locationData.latitude;
    userLongitude = _locationData.longitude;

    ///
    /// here im getting the Qibla directions according to the  user latitudes and longitudes
    /// ************************************************************

    getQiblaDirections(
        latitudes: _locationData.latitude.toString(),
        longitudes: _locationData.longitude.toString());

    /// ************************************************************
    ///

    ///getting salah times data here
    getSalahTimesData(
        latitude: _locationData.latitude, longitude: _locationData.longitude);

    ///get location names from the fetched latitudes and longitudes
    fetchUserLocationNames(
        latitude: _locationData.latitude, longitude: _locationData.longitude);
  }

  ///fetching location names form the latitudes and the longitudes
  var locality = '';
  var subLocality = '';
  var postalCode = '';

  fetchUserLocationNames({required latitude, required longitude}) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      // print(placemarks);

      locality = placemarks[0].locality.toString();
      subLocality = placemarks[0].subLocality.toString();
      postalCode = placemarks[0].postalCode.toString();

      ///saving the location names here
      saveSalahData(locationNamesMap: {
        "locality": locality,
        "sub_locality": subLocality,
        "postal_code": postalCode,
      });

      ///

      notifyListeners();
    } catch (err) {
      print('error while getting location names' + err.toString());
    }
  }

  /// fetching location data function
  getSalahTimesData({required latitude, required longitude}) {
    ///getting today date to compare with the dates coming with the salah times data to find and fetch the salah times for the current day
    // final currentMonth = DateTime.now().month.toString();
    // final currentYear = DateTime.now().year.toString();
    DateTime today = DateTime.now();
    String todayDate =
        "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year.toString()}";
    // print(dateSlug);

    var url = Uri.parse(
        'https://api.aladhan.com/v1/calendar/${today.year}/${today.month}?latitude=$latitude&longitude=$longitude');
    // print(url);
    try {
      http.get(url).then((response) async {
        print(url);
        var salahTimesData = await jsonDecode(response.body)['data'];

        print(salahTimesData);

        await salahTimesData.forEach((e) async {
          {
            if (e['date']["gregorian"]['date'] == todayDate) {
              ///
              ///sending the date data to be extracted from the api itself
              ///
              extractDate(dateData: e['date']);

              timeData = await e['timings'];

              ///here im converting the 24hr to 12 hr format then collecting them ans sending them to be displayed on the screen
              var timingsData = e['timings'];
              var fajrTime = convertTimeToTwelveHourFormat(
                  time: timingsData['Fajr'], salahName: 'Fajr');
              var sunriseTime = convertTimeToTwelveHourFormat(
                  time: timingsData['Sunrise'], salahName: 'Sunrise');
              var dhuhrTime = convertTimeToTwelveHourFormat(
                  time: timingsData['Dhuhr'], salahName: 'Dhuhr');
              var asrTime = convertTimeToTwelveHourFormat(
                  time: timingsData['Asr'], salahName: 'Asr');

              var maghribTime = convertTimeToTwelveHourFormat(
                  time: timingsData['Maghrib'], salahName: 'Maghrib');
              var ishaTime = convertTimeToTwelveHourFormat(
                  time: timingsData['Isha'], salahName: 'Isha');
              var midnightTime = convertTimeToTwelveHourFormat(
                  time: timingsData['Midnight'], salahName: 'Midnight');
              // var imsakTime = convertTimeToTwelveHourFormat(
              //     time: timingsData['Imsak'], salahName: 'Imsak');

              // print("test" +
              //     convertTimeToTwelveHourFormat(
              //         time: '12:01', salahName: 'test').toString());
              ///
              ///
              ///
              ///not doing it yet ill do it in future inshallah (assigning notifications all salah times notifications here)
              ///
              ///
              /// see notifications class if you forget something in the future alhamdulillah
              // NotificationApi()
              //     .setAllSalahNotifications(salahTimesData: salahTimesData);

              ///
              ///
              /// Updating main Salah Times array here which is responsible to update the ui
              ///
              ///
              ///here ist he twenty four hour format
              salahTimesTwentyFourHourFormatArray = [
                refactorTwentyFourHourFormat(
                    time: timingsData['Fajr'], salahName: 'Fajr'),
                refactorTwentyFourHourFormat(
                    time: timingsData['Sunrise'], salahName: 'Sunrise'),
                refactorTwentyFourHourFormat(
                    time: timingsData['Dhuhr'], salahName: 'Dhuhr'),
                refactorTwentyFourHourFormat(
                    time: timingsData['Asr'], salahName: 'Asr'),
                refactorTwentyFourHourFormat(
                    time: timingsData['Maghrib'], salahName: 'Maghrib'),
                refactorTwentyFourHourFormat(
                    time: timingsData['Isha'], salahName: 'Isha'),
                refactorTwentyFourHourFormat(
                    time: timingsData['Midnight'], salahName: 'Midnight'),
                // refactorTwentyFourHourFormat(
                //     time: timingsData['Imsak'], salahName: 'Imsak'),
              ];

              ///here is the twelve hour format
              salahTimesTwelveHourFormatArray = [
                fajrTime,
                sunriseTime,
                dhuhrTime,
                asrTime,
                maghribTime,
                ishaTime,
                midnightTime,
                // imsakTime,
              ];

              /// highlightSalah() function runs every second insode the update current time function
              /// to update the ui continuously;
              updateCurrentTime();

              ///im saving all the information here cause till here everything required for app to run from permanently saved data has been fetched properly
              saveSalahData(salahTimes: timingsData);

              notifyListeners();
            }
          }
        });
      });
    } catch (err) {
      print('errr im the getSalahTimesData function');
    }
  }

  ///
  ///this function converts the 24 hr format to 12 hr format
  ///
  convertTimeToTwelveHourFormat({required time, required salahName}) {
    if (time.toString().substring(0, time.toString().indexOf(':')) != '12') {
      DateTime tempDate = DateFormat("hh:mm")
          .parse(time.toString().replaceAll('(IST)', "").trim());
      var dateFormat2 = DateFormat("hh:mm a"); // you can change the format here

      // print(salahName + ' = ' + dateFormat2.format(tempDate));
      var unit =
          dateFormat2.format(tempDate).trim().toLowerCase().contains('am')
              ? 'am'
              : "pm";

      var convertedTime = dateFormat2
          .format(tempDate)
          .toString()
          .toLowerCase()
          .replaceAll("am", '')
          .replaceAll('pm', '')
          .padLeft(2, '0');

      return {
        'salah_name': salahName,
        'salah_time': convertedTime,
        'unit': unit,
      };
    } else {
      return {
        'salah_name': salahName,
        'salah_time': time.toString().replaceAll('(IST)', "").trim(),
        'unit': 'pm',
      };
    }
  }

  ///this function shows when the user has selected the time should be shown in 24 hr format
  ///this function takes the 24hr format and the salahName and simply refactors them in a map so that it
  ///can be displayed on the screen
  refactorTwentyFourHourFormat({required time, required salahName}) async {
    return {
      'salah_name': salahName,
      'salah_time': time.toString().replaceAll('(IST)', "").trim(),
      //this is 24 hr format so there is no am or pm
      'unit': '',
    };
  }

  ///
  ///extracting the current DATES from the api itself
  ///
  var fullTodayDate = {};

  extractDate({required dateData}) async {
    var englishDate =
        "${dateData['gregorian']['weekday']['en']}, ${dateData['readable']}";

    var hijriDate =
        "${dateData['hijri']['weekday']['en']}, ${dateData['hijri']['day']} ${dateData['hijri']['month']['en']} ${dateData['hijri']['year']}";

    // print(hijriDate);

    fullTodayDate = {
      'english_date': englishDate,
      'hijri_date': hijriDate,
    };

    saveSalahData(todayDateFromApi: fullTodayDate);
    notifyListeners();
  }

  /// this function handles the displaying of the current salah and the counting of the time left for the current salah
  var highLightSalahTimeIndex;

  var currentSalahName = '';

  var remainingTime;

  bool upcoming = false;

  highlightSalah() async {
    // print('im runing');
    // print(userLatitude.toString() + " " + userLongitude.toString());

    ///current time
    var now = DateTime.now();
    var currentTime = DateFormat('HH:mm:ss').format(now);

    ///
    var format2 = DateFormat('HH:mm');
    var format = DateFormat('HH:mm:ss');

    ///

    var fajrTime = format.format(format2.parse(timeData['Fajr']));
    var sunriseTime = format.format(format2.parse(timeData['Sunrise']));
    var dhuhrTime = format.format(format2.parse(timeData['Dhuhr']));
    var asrTime = format.format(format2.parse(timeData['Asr']));
    var maghribTime = format.format(format2.parse(timeData['Maghrib']));
    var ishaTime = format.format(format2.parse(timeData['Isha']));
    var midnightTime = format.format(format2.parse(timeData['Midnight']));
    // var imsakTime = format.format(format2.parse(timeData['Imsak']));

    //

    ///fajr time 0
    if (currentTime.compareTo(fajrTime) == 0 ||
        currentTime.compareTo(fajrTime) == 1 &&
            currentTime.compareTo(sunriseTime) == -1) {
      highLightSalahTimeIndex = 0;
      currentSalahName = 'Fajr';
      upcoming = false;

      // updateCurrentTime(salahTime: sunriseTime);
      // print('im fajr time');
      // decorationImageLink =
      //     const AssetImage('images/salah_backgrounds/fajr.jpg');

      remainingTime = format
          .parse(currentTime)
          .difference(format.parse(sunriseTime))
          .toString()
          .replaceAll('.000000', '')
          .replaceAll('-', '');
    }

    ///dhuhr time 2
    else if (currentTime.compareTo(dhuhrTime) == 0 ||
        currentTime.compareTo(dhuhrTime) == 1 &&
            currentTime.compareTo(asrTime) == -1) {
      // print('im dhuhr time');

      highLightSalahTimeIndex = 2;
      currentSalahName = 'Dhuhr';
      upcoming = false;
      // decorationImageLink =
      //     const AssetImage('images/salah_backgrounds/dhuhr.jpg');

      remainingTime = format
          .parse(currentTime)
          .difference(format.parse(asrTime))
          .toString()
          .replaceAll('.000000', '')
          .replaceAll('-', '');
      // updateCurrentTime(salahTime: asrTime);
      // notifyListeners();
    }

    /// asr time 3
    else if (currentTime.compareTo(asrTime) == 0 ||
        currentTime.compareTo(asrTime) == 1 &&
            currentTime.compareTo(maghribTime) == -1) {
      highLightSalahTimeIndex = 3;
      // print('asr Time is going on = ');
      currentSalahName = 'Asr';
      upcoming = false;
      // print('im Asr time');
      // decorationImageLink =
      //     const AssetImage('images/salah_backgrounds/asr.jpg');
      remainingTime = format
          .parse(currentTime)
          .difference(format.parse(maghribTime))
          .toString()
          .replaceAll('.000000', '')
          .replaceAll('-', '');

      // notifyListeners();
    }

    ///maghrib time 4
    else if (currentTime.compareTo(maghribTime) == 0 ||
        currentTime.compareTo(maghribTime) == 1 &&
            currentTime.compareTo(ishaTime) == -1) {
      highLightSalahTimeIndex = 4;
      // print('maghrib Time is going on = ');
      currentSalahName = 'Maghrib';
      upcoming = false;
      // decorationImageLink =
      //     const AssetImage('images/salah_backgrounds/maghrib.jpg');
      remainingTime = format
          .parse(currentTime)
          .difference(format.parse(ishaTime))
          .toString()
          .replaceAll('.000000', '')
          .replaceAll('-', '');
    }

    ///isha time 5
    else if (currentTime.compareTo(ishaTime) == 0 ||
        currentTime.compareTo(ishaTime) == 1 &&
            midnightTime.compareTo("00:00:00") == 1) {
      highLightSalahTimeIndex = 5;
      // print('isha Time is going on = ');
      currentSalahName = 'Isha';
      remainingTime = 'till midnight';
      // decorationImageLink =
      //     const AssetImage('images/salah_backgrounds/isha.jpg');
    }

    ///this is for upcoming dhuhr Salah
    else if (currentTime.compareTo(sunriseTime) == 1 &&
        currentTime.compareTo(dhuhrTime) == -1) {
      currentSalahName = 'Dhur';
      highLightSalahTimeIndex = null;
      upcoming = true;
      // decorationImageLink =
      //     const AssetImage('images/salah_backgrounds/sunrise.jpg');
      remainingTime = format
          .parse(currentTime)
          .difference(format.parse(dhuhrTime))
          .toString()
          .replaceAll('.000000', '')
          .replaceAll('-', '');

      // print('upcoming dhuhr salah counting');

      ///this is for upcoming fajr prayer
    } else if (currentTime.compareTo(midnightTime) == 1 &&
        currentTime.compareTo(fajrTime) == -1) {
      currentSalahName = 'Fajr';
      highLightSalahTimeIndex = null;
      upcoming = true;
      // decorationImageLink =
      //     const AssetImage('images/salah_backgrounds/midnight.jpg');
      remainingTime = format
          .parse(currentTime)
          .difference(format.parse(fajrTime))
          .toString()
          .replaceAll('.000000', '')
          .replaceAll('-', '');
    } else {
      highLightSalahTimeIndex = null;
      // currentSalahName  =null;
      // print('this is null');

      // print(formattedMidnightTime);
    }
    // notifyListeners();
  }

  ///
  ///this function updates the ui and the  remaining time continuously every second
  updateCurrentTime() async {
    final prefs = await SharedPreferences.getInstance();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      // print('this is the timer');

      ///im also calling this function here cause [updateCurrentTime] function is called  every second to update the time
      ///so calling the [ compareSavedAndCurrentDates] will compare every second the saved and the current dates
      ///and this will help when suppose the user is using the app at 12 am well then initSate will not run to check everything
      ///so this here will update the fetch the salah  times automatically .

      compareSavedAndCurrentDates(prefs: prefs, timer: timer);

      // print('im timer');
      highlightSalah();
      notifyListeners();
    });
  }

  ///fetch qibla directions function
  ///
  var qiblaDirection;

  getQiblaDirections({required String latitudes, required String longitudes}) {
    final url =
        Uri.parse('http://api.aladhan.com/v1/qibla/$latitudes/$longitudes');

    http.get(url).then((response) async {
      qiblaDirection = await jsonDecode(response.body)['data']['direction'];

      ///saving the qibla Direction here
      saveSalahData(qiblaDirection: qiblaDirection);

      // print(jsonDecode(response.body));
      //
      // print(latitudes + " " + longitudes);
      // print(qiblaDirection);
      notifyListeners();
    });
  }

  ///this function save the salah times data into permanent memoru

  saveSalahData(
      {salahTimes,
      qiblaDirection,
      locationNamesMap,
      todayDateFromApi,
      hijriCalendarData}) async {
    final prefs = await SharedPreferences.getInstance();

    if (salahTimes != null) {
      print('saving salah Times');
      await prefs.setString('salah_times_data', jsonEncode(salahTimes));
    }
    if (qiblaDirection != null) {
      print('saving qibla direction');
      await prefs.setDouble('qibla_direction', qiblaDirection);
    }
    if (locationNamesMap != null) {
      print('saving  location names map');
      await prefs.setString('location_names', jsonEncode(locationNamesMap));
    }
    if (todayDateFromApi != null) {
      print('saving today\'s date extracted from the api');
      await prefs.setString('todays_date', jsonEncode(todayDateFromApi));
    }
    if (hijriCalendarData != null) {
      // print(hijriCalendarData);
      // print('saving HIJRI CALENDAR DATA');
      await prefs.setString('calendar_data', jsonEncode(hijriCalendarData));
    }

    // print('everthing save successfully');
  }

  fetchSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    var salahTimes = await jsonDecode(prefs.get('salah_times_data').toString());
    var qiblaDirectionData = prefs.get('qibla_direction');
    var locationNames =
        await jsonDecode(prefs.get('location_names').toString());
    var todaysDate = await jsonDecode(prefs.get('todays_date').toString());
    var calendarData = await jsonDecode(prefs.get('calendar_data').toString());

    if ((salahTimes != null &&
        qiblaDirectionData != null &&
        locationNames != null &&
        todaysDate != null &&
        calendarData != null)) {
      // print('formatted current date = ' + currentDate);
      // print('saved date ' + todaysDate['english_date']);

      /// here im checking if the saved date in smaller than the current date
      /// if the current date is smaller than the today date( current date) then the
      /// checkInternet function runs and fetches  the new time of salah from the api
      compareSavedAndCurrentDates(prefs: prefs);

      ///assigning qibla direction
      qiblaDirection = qiblaDirectionData;

      timeData = salahTimes;

      ///assigning the salah times fetched from the saved data to salahTimes array which displays the salah times on the screen
      ///
      /// these are the 12 hrs format
      salahTimesTwelveHourFormatArray = [
        await convertTimeToTwelveHourFormat(
            time: salahTimes['Fajr'], salahName: 'Fajr'),
        await convertTimeToTwelveHourFormat(
            time: salahTimes['Sunrise'], salahName: 'Sunrise'),
        await convertTimeToTwelveHourFormat(
            time: salahTimes['Dhuhr'], salahName: 'Dhuhr'),
        await convertTimeToTwelveHourFormat(
            time: salahTimes['Asr'], salahName: 'Asr'),
        await convertTimeToTwelveHourFormat(
            time: salahTimes['Maghrib'], salahName: 'Maghrib'),
        await convertTimeToTwelveHourFormat(
            time: salahTimes['Isha'], salahName: 'Isha'),
        await convertTimeToTwelveHourFormat(
            time: salahTimes['Midnight'], salahName: 'Midnight'),
        // await convertTimeToTwelveHourFormat(
        //     time: salahTimes['Imsak'], salahName: 'Imsak'),
      ];

      ///this is the 24hr format assigning
      salahTimesTwentyFourHourFormatArray = [
        refactorTwentyFourHourFormat(
            time: salahTimes['Fajr'], salahName: 'Fajr'),
        refactorTwentyFourHourFormat(
            time: salahTimes['Sunrise'], salahName: 'Sunrise'),
        refactorTwentyFourHourFormat(
            time: salahTimes['Dhuhr'], salahName: 'Dhuhr'),
        refactorTwentyFourHourFormat(time: salahTimes['Asr'], salahName: 'Asr'),
        refactorTwentyFourHourFormat(
            time: salahTimes['Maghrib'], salahName: 'Maghrib'),
        refactorTwentyFourHourFormat(
            time: salahTimes['Isha'], salahName: 'Isha'),
        refactorTwentyFourHourFormat(
            time: salahTimes['Midnight'], salahName: 'Midnight'),
        // refactorTwentyFourHourFormat(
        //     time: salahTimes['Imsak'], salahName: 'Imsak'),
      ];

      ///this is the running the highlight function after fetching the saved data

      ///assigning the location names here
      locality = locationNames['locality'];
      subLocality = locationNames['sub_locality'];
      postalCode = locationNames['postal_code'];

      ///assigning today dates
      fullTodayDate = todaysDate;

      ///assigning calendar data
      checkCalendarFirstWeekday(data: calendarData);
      extractEvents(data: calendarData);

      updateCurrentTime();
      notifyListeners();
    } else {
      print(
          'no saved data was found so firing the function to fetch the data from the api');

      checkInternet();
    }
  }

  ///this function compares the current and the saved dates
  ///if the saved date is smaller than the current date then
  ///it simply fetches the new salah times from the api
  ///compare the saved and the current dates
  compareSavedAndCurrentDates({required SharedPreferences prefs, timer}) async {
    // print('comparing dates');
    final todaysDate = jsonDecode(prefs.get('todays_date').toString());
    var currentDate = DateFormat('EEEE, dd MMM yyyy').format(DateTime.now());
    var savedDate = todaysDate['english_date'];

    // print('current date = $currentDate  |  saved Date = $savedDate');
    if (savedDate.compareTo(currentDate) == 0) {
      // print('the day is same ! not doing anything');
    } else if (savedDate.compareTo(currentDate) == -1) {
      // print('the saved date is behind the current date');

      // print('the timer was null means the function was ran in the init state');
      // print('current date = $currentDate  |  saved Date = $savedDate');
      checkInternet();
      notifyListeners();
    } else if (savedDate.compareTo(currentDate) == 1) {
      // print('the saved date is bigger than the current date');

      // print('the timer was null means the function was ran in the init state');
      checkInternet();
    }
    // else {
    //   checkInternet();
    // }
  }

  ///****************************************************************************
  ///****************************************************************************
  ///****************************************************************************
  ///****************************************************************************
  ///****************************************************************************
  ///****************************************************************************
  ///
  ///
  /// here starts the Hijri Calendar  function
  ///
  ///
  ///****************************************************************************
  ///****************************************************************************
  ///****************************************************************************
  ///****************************************************************************
  ///****************************************************************************
  ///****************************************************************************
  List hijriCalendarData = [];

  var elementsToSkip;

  fetchHijriCalendar() async {
    final year = DateTime.now().year;
    final month = DateTime.now().month;

    try {
      final url = Uri.parse(
          'https://api.aladhan.com/v1/gToHCalendar/${month.toString()}/${year.toString()}');

      final data = await http
          .get(url)
          .then((response) => jsonDecode(response.body)['data']);

      ///saving calender data
      saveSalahData(hijriCalendarData: data);

      checkCalendarFirstWeekday(data: data);

      // print(hijriCalendarData);
      extractEvents(data: data);
      notifyListeners();
    } catch (err) {
      print('error while fetching hijri calendar');
    }
  }

  var hijriCalendarMonthYear;

  checkCalendarFirstWeekday({required data}) async {
    final currentDay = DateTime.now().day.toString().padLeft(2, '0');

    // print('imm the assigner');

    var x =
        await data.where((e) => currentDay == e['gregorian']['day']).toList();
    // print(x);

    hijriCalendarMonthYear = {
      "hijri": {
        'month': x[0]['hijri']['month']['en'].toString(),
        'year': x[0]['hijri']['year'].toString(),
      },
      "gregorian": {
        'month': x[0]['gregorian']['month']['en'].toString(),
        'year': x[0]['gregorian']['year'].toString(),
      },
    };
    notifyListeners();

    // notifyListeners();
    switch (data[0]['gregorian']['weekday']['en']) {
      case 'Sunday':
        {
          print('1st day is Sunday ');
          hijriCalendarData = data;
          elementsToSkip = null;

          notifyListeners();
        }
        break;
      case 'Monday':
        {
          print('1st day is Monday ');
          hijriCalendarData = ["", ...data];
          elementsToSkip = 1;

          notifyListeners();
        }
        break;
      case 'Tuesday':
        {
          print('1st day is Tuesday ');
          hijriCalendarData = ["", "", ...data];
          elementsToSkip = 2;

          notifyListeners();
        }
        break;
      case 'Wednesday':
        {
          print('1st day is Wednesday ');
          hijriCalendarData = ["", "", "", ...data];
          elementsToSkip = 3;

          notifyListeners();
        }
        break;
      case 'Thursday':
        {
          print('1st day is Thursday ');
          hijriCalendarData = ["", "", "", "", ...data];
          elementsToSkip = 4;

          notifyListeners();
        }
        break;
      case 'Friday':
        {
          print('1st day is Friday ');
          hijriCalendarData = ["", "", "", "", "", ...data];
          elementsToSkip = 5;

          notifyListeners();
        }
        break;
      case 'Saturday':
        {
          print('1st day is Saturday ');
          hijriCalendarData = ["", "", "", "", "", "", ...data];
          elementsToSkip = 6;

          notifyListeners();
        }
        break;
    }
    notifyListeners();
  }

  List eventsData = [];

  extractEvents({required List data}) async {
    String currentDay = DateTime.now().day.toString().padLeft(2, "0");
    // String currentDay = '01';
    //
    List currentDayEventDate =
        data.where((e) => e['gregorian']['day'] == currentDay).toList();

    List futureEvents = data
        .where((e) => int.parse(e['gregorian']['day']) > int.parse(currentDay))
        .toList();
    eventsData = [...currentDayEventDate, ...futureEvents];
    // print(currentDayEventDate);
    // print(futureEvents);
    // List events = [];
  }
}
