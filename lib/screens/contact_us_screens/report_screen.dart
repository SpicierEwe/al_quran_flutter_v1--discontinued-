import 'package:al_quran/components/custom_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../components/remove_listview_glow/remove_listview_glow.dart';
import '../../providers/theme_provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Report',
          style: GoogleFonts.josefinSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: mq.height * 0.029,
          ),
        ),
        backgroundColor: themeProvider.darkTheme
            ? themeProvider.scaffoldBackgroundColor
            : Colors.red,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: themeProvider.darkTheme ? themeProvider.scaffoldBackgroundColor: Colors.red,
      body: ScrollConfiguration(
        behavior: RemoveListViewGlow(),
        child: SingleChildScrollView(
          child: SizedBox(
              height: mq.height -
                  (AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top),
              width: mq.width,
              child: CustomForm(
                specificPortalColor: themeProvider.darkTheme
                    ? themeProvider.scaffoldBackgroundColor
                    : Colors.red,
                portalType: 'report',
              )),
        ),
      ),
    );
  }
}
