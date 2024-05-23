import 'dart:ui';

import 'package:al_quran/providers/audio_provider.dart';
import 'package:al_quran/providers/theme_provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomMusicBar extends StatefulWidget {
  final mq;

  const BottomMusicBar({Key? key, this.mq}) : super(key: key);

  @override
  _BottomMusicBarState createState() => _BottomMusicBarState();
}

class _BottomMusicBarState extends State<BottomMusicBar> {
  bool showBottomMusicBar = false;
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  bool isPlaying = false;

  customSize({cmh, cmw}) {
    return cmh * 0.55;
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ClipRect(
      child: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaY: 10, sigmaX: 10, tileMode: TileMode.mirror),
        child: Container(
          color: Colors.blue.shade200.withOpacity(.1),
          child: Container(
            // color: Colors.white.withOpacity(.2),
            decoration: BoxDecoration(
                // color: Colors.grey.shade200.withOpacity(0.5),
                color: Colors.transparent,
                border: Border(
                    top: BorderSide(
                        color: Colors.blueGrey.withOpacity(.5),
                        width: widget.mq.width * 0.007))),
            height: MediaQuery.of(context).size.height * 0.061,
            child: LayoutBuilder(
              builder: (context, constraints) {
                var cmh = constraints.maxHeight;
                var cmw = constraints.maxWidth;
                // if(showBottomMusicBar ==true)
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (audioProvider.repeatValue == 0) {
                          audioProvider.changeRepeatValue(setRepeatValue: 1);
                          // print(audioProvider.repeatValue);
                          return;
                        }
                        if (audioProvider.repeatValue == 1) {
                          audioProvider.changeRepeatValue(setRepeatValue: 2);
                          // print(audioProvider.repeatValue);
                          return;
                        }
                        if (audioProvider.repeatValue == 2) {
                          audioProvider.changeRepeatValue(setRepeatValue: 0);
                          // print(audioProvider.repeatValue);
                          return;
                        }
                      },
                      icon: Icon(
                        audioProvider.repeatValue == 1
                            ? Icons.repeat_one
                            : audioProvider.repeatValue == 2
                                ? Icons.repeat_on_outlined
                                : Icons.repeat,
                        size: cmh * 0.45,
                        color: themeProvider.musicPlayerButtonsColor,

                        // : Colors.white,
                      ),
                    ),

                    ///previous
                    IconButton(
                        onPressed: () {
                          audioProvider.previous();
                        },
                        icon: Icon(
                          Icons.skip_previous_rounded,
                          size: cmh * 0.49,
                          color: themeProvider.musicPlayerButtonsColor,
                        )),

                    /// play pause button
                    IconButton(
                        onPressed: () {
                          setState(() {
                            audioProvider.checkPlayer() == true
                                ? audioProvider.pause()
                                : audioProvider.play();
                          });
                        },
                        icon: Icon(
                          !audioProvider.checkPlayer() ||
                                  audioProvider.surahAudioComplete == true
                              ? Icons.play_arrow_rounded
                              : Icons.pause_rounded,
                          size: cmh * 0.61,
                          color: themeProvider.musicPlayerButtonsColor,
                        )),

                    /// next
                    IconButton(
                        onPressed: () {
                          audioProvider.next();
                        },
                        icon: Icon(
                          Icons.skip_next_rounded,
                          color: themeProvider.musicPlayerButtonsColor,
                          size: cmh * 0.49,
                        )),

                    ///stop and hide bottom music bar
                    IconButton(
                        onPressed: () async {
                          await audioProvider.stop();
                        },
                        icon: Icon(
                          Icons.crop_square_rounded,
                          size: cmh * 0.45,
                          color: themeProvider.musicPlayerButtonsColor,
                        )),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
