import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ContactPortalProvider extends ChangeNotifier {
  bool loadingScreen = false;

  toggleLoadingScreen({loadingScreenBool}) {
    loadingScreen = loadingScreenBool;
    notifyListeners();
  }

  successfulMessageSnackBar(context, formKey) {
    toggleLoadingScreen(loadingScreenBool: false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Submitted Successfully',
            textAlign: TextAlign.center,
          )),
    );
    formKey.currentState?.reset();
  }

  failedMessageSnackBar(context) {
    toggleLoadingScreen(loadingScreenBool: false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Submission Failed! Please try again later',
            textAlign: TextAlign.center,
          )),
    );
  }

  ///[portalType] is only to identify and  send data to specific categories in data base
  gatherInformation(
      {incomingName,
      incomingEmail,
      incomingTitle,
      incomingExplainedInDetail,
      portalType,
      context,
      formKey}) async {
    var sentTime =
        DateFormat('d MMM yyyy hh:mm:ss a').format(DateTime.now());

    Map gatheredData = {
      'name': incomingName,
      'email': incomingEmail,
      'title': incomingTitle,
      'explained_in_detail': incomingExplainedInDetail,
      'sent_time': sentTime.toString(),
    };
    if (portalType == 'report') {
      print('its a report ');

      final url = Uri.parse(
          'https://al-qur-aan-default-rtdb.firebaseio.com/portals/report_portal.json');

      http.post(url, body: jsonEncode(gatheredData)).catchError((err) {
        failedMessageSnackBar(context);
      }).then((value) => successfulMessageSnackBar(context, formKey));
    }
    if (portalType == 'feature_suggestion') {
      print('its a feature_suggestion ');

      final url = Uri.parse(
          'https://al-qur-aan-default-rtdb.firebaseio.com/portals/feature_suggestion_portal.json');

      http.post(url, body: jsonEncode(gatheredData)).catchError((err) {
        failedMessageSnackBar(context);
      }).then((value) => successfulMessageSnackBar(context, formKey));
    }

    if (portalType == 'contact_us') {
      print('its a contact us ');

      final url = Uri.parse(
          'https://al-qur-aan-default-rtdb.firebaseio.com/portals/contact_us_portal.json');

      http.post(url, body: jsonEncode(gatheredData)).catchError((err) {
        failedMessageSnackBar(context);
      }).then((value) => successfulMessageSnackBar(context, formKey));
    }
    // print(gatheredData);
  }
}
