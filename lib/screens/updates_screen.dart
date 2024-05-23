import 'package:al_quran/components/remove_listview_glow/remove_listview_glow.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({Key? key}) : super(key: key);

  @override
  _UpdatesScreenState createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  final _fireStore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM–yyyy kk:mm').format(now);
    var themeProvider = Provider.of<ThemeProvider>(context);
    var mq = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: themeProvider.settingsScaffoldBackgroundColor,
      appBar: AppBar(title: const Text('UPDATES'), centerTitle: true),
      body: SizedBox(
        height: mq.height -
            (AppBar().preferredSize.height +
                MediaQuery
                    .of(context)
                    .padding
                    .top),
        child: StreamBuilder(
          stream: _fireStore.collection('dev').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ScrollConfiguration(
                behavior: RemoveListViewGlow(),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        var cmh = constraints.maxHeight;
                        var cmw = constraints.maxWidth;

                        return SizedBox(
                          height: cmh,
                          child: ListView.builder(
                            itemCount:
                            snapshot.data.docs[index]['updates'].length,
                            itemBuilder: (context, index2) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: cmh * 0.02,
                                  left: cmh * 0.019,
                                  right: cmh * 0.019,
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(
                                    top: cmh * 0.02,
                                    bottom: cmh * 0.017,
                                    left: cmh * 0.03,
                                    right: cmh * 0.03,
                                  ),
                                  decoration: BoxDecoration(
                                    // color: Colors.white,
                                      color:
                                      themeProvider.updatesContainerColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: index2 != 0
                                            ? Radius.circular(cmw * 0)
                                            : Radius.circular(cmh * 0.03),
                                        topRight: index2 != 0
                                            ? Radius.circular(cmw * 0)
                                            : Radius.circular(cmh * 0.03),
                                        bottomRight: index2 ==
                                            snapshot
                                                .data
                                                .docs[index]['updates']
                                                .length -
                                                1
                                            ? Radius.circular(cmw * 0.05)
                                            : const Radius.circular(0),
                                        bottomLeft: index2 ==
                                            snapshot
                                                .data
                                                .docs[index]['updates']
                                                .length -
                                                1
                                            ? Radius.circular(cmw * 0.05)
                                            : const Radius.circular(0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color: themeProvider
                                                .updatesContainerShadowColor
                                                .withOpacity(.35),
                                            spreadRadius: 2,
                                            blurRadius: 7)
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [

                                          if (snapshot.data.docs[index]
                                          ['updates'][(snapshot
                                              .data
                                              .docs[index]
                                          ['updates']
                                              .length -
                                              1) -
                                              index2]['title'] !=
                                              null)
                                            Text(
                                              'Title : ',
                                              style: GoogleFonts.roboto(
                                                  fontSize: cmh * 0.017,
                                                  color: themeProvider
                                                      .updatesTitlesColor),
                                            ),

                                          ///title is here****************************************
                                          if (snapshot.data.docs[index]
                                          ['updates'][(snapshot
                                              .data
                                              .docs[index]
                                          ['updates']
                                              .length -
                                              1) -
                                              index2]['title'] !=
                                              null)
                                            Expanded(
                                              child: Text(
                                                snapshot
                                                    .data
                                                    .docs[index]['updates'][
                                                (snapshot
                                                    .data
                                                    .docs[index]
                                                [
                                                'updates']
                                                    .length -
                                                    1) -
                                                    index2]['title']
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                  fontSize: cmh * 0.019,
                                                  fontWeight: FontWeight.bold,
                                                  color: snapshot.data
                                                      .docs[index]
                                                  ['updates']
                                                  [
                                                  (snapshot.data
                                                      .docs[index]['updates']
                                                      .length -
                                                      1) -
                                                      index2]
                                                  ['color'] !=
                                                      null
                                                      ? Color(
                                                      snapshot.data.docs[index]
                                                      ['updates']
                                                      [(snapshot
                                                          .data
                                                          .docs[index]
                                                      [
                                                      'updates']
                                                          .length -
                                                          1) - index2]['color'])
                                                      : const Color(0xff159957),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: cmh * 0.0045,
                                      ),
                                      if (snapshot.data.docs[index]['updates']
                                      [(snapshot
                                          .data
                                          .docs[index]
                                      [
                                      'updates']
                                          .length -
                                          1) - index2]['description'] !=
                                          null)
                                        Text(
                                          'Description :',
                                          style: GoogleFonts.roboto(
                                              color: themeProvider
                                                  .updatesTitlesColor,
                                              fontSize: cmh * 0.017),
                                        ),
                                      SizedBox(
                                        height: cmh * 0.002,
                                      ),

                                      ///description is here
                                      if (snapshot.data.docs[index]['updates']
                                      [(snapshot
                                          .data
                                          .docs[index]
                                      [
                                      'updates']
                                          .length -
                                          1) - index2]['description'] !=
                                          null)
                                        Text(
                                          snapshot
                                              .data
                                              .docs[index]['updates'][(snapshot
                                              .data
                                              .docs[index]
                                          [
                                          'updates']
                                              .length -
                                              1) - index2]
                                          ['description']
                                              .toString(),
                                          style: GoogleFonts.roboto(
                                            fontSize: cmh * 0.01905,
                                            fontWeight: FontWeight.bold,
                                            color: snapshot.data.docs[index]
                                            ['updates'][(snapshot
                                                .data
                                                .docs[index]
                                            [
                                            'updates']
                                                .length -
                                                1) - index2]
                                            ['color'] !=
                                                null
                                                ? Color(snapshot.data
                                                .docs[index]['updates']
                                            [(snapshot
                                                .data
                                                .docs[index]
                                            [
                                            'updates']
                                                .length -
                                                1) - index2]['color'])
                                                : const Color(0xff159957),
                                          ),
                                        ),

                                      ///message is here
                                      if (snapshot.data.docs[index]['updates']
                                      [(snapshot
                                          .data
                                          .docs[index]
                                      [
                                      'updates']
                                          .length -
                                          1) - index2]['message'] !=
                                          null)
                                        Text(
                                          snapshot
                                              .data
                                              .docs[index]['updates'][(snapshot
                                              .data
                                              .docs[index]
                                          [
                                          'updates']
                                              .length -
                                              1) - index2]
                                          ['message']
                                              .toString(),
                                          style: GoogleFonts.roboto(
                                            fontSize: cmh * 0.027,
                                            fontWeight: FontWeight.bold,
                                            color: snapshot.data.docs[index]
                                            ['updates'][(snapshot
                                                .data
                                                .docs[index]
                                            [
                                            'updates']
                                                .length -
                                                1) - index2]
                                            ['color'] !=
                                                null
                                                ? Color(snapshot.data
                                                .docs[index]['updates']
                                            [(snapshot
                                                .data
                                                .docs[index]
                                            [
                                            'updates']
                                                .length -
                                                1) - index2]['color'])
                                                : const Color(0xff159957),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),

                                      ///showing time here
                                      if(snapshot.data
                                          .docs[index]['updates']
                                      [(snapshot
                                          .data
                                          .docs[index]
                                      [
                                      'updates']
                                          .length -
                                          1) - index2]['time'] != null)

                                        Column(
                                          children: [
                                            SizedBox(height: cmh * 0.007,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .end,
                                              children: [
                                                Text(
                                                  snapshot.data
                                                      .docs[index]['updates']
                                                  [(snapshot
                                                      .data
                                                      .docs[index]
                                                  [
                                                  'updates']
                                                      .length -
                                                      1) - index2]['time'],
                                                  // formattedDate,
                                                  style: TextStyle(
                                                      fontSize: cmh * 0.0135,
                                                      color: themeProvider
                                                          .updatesTitlesColor),
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              print('err');
            }
            return Center(
                child: CircularProgressIndicator(
                    color: themeProvider.circularProgressIndicatorColor));
          },
        )
        ,
      )
      ,
    );
  }
}