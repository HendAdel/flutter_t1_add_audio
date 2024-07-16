import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    await assetsAudioPlayer.open(
        autoStart: false,
        loopMode: LoopMode.playlist,
        (Playlist(audios: [
          Audio(
            "assets/1.mp3",
            metas: Metas(title: 'Song 1'),
          ),
          Audio(
            "assets/2.mp3",
            metas: Metas(title: 'Song 2'),
          ),
          Audio(
            "assets/3.mp3",
            metas: Metas(title: 'Song 3'),
          ),
          Audio(
            "assets/4.mp3",
            metas: Metas(title: 'Song 4'),
          ),
        ])));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 400,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightBlue,
                ),
                child: Center(
                  child: StreamBuilder(
                      stream: assetsAudioPlayer.realtimePlayingInfos,
                      builder: (context, snapShots) {
                        if (snapShots.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                assetsAudioPlayer.getCurrentAudioTitle == ''
                                    ? 'Please play your song!'
                                    : assetsAudioPlayer.getCurrentAudioTitle,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed:
                                          snapShots.data?.current?.index == 0
                                              ? null
                                              : () {
                                                  assetsAudioPlayer.previous();
                                                },
                                      icon: Icon(Icons.skip_previous)),
                                  getBtnWIdGet,
                                  IconButton(
                                      onPressed:
                                          snapShots.data?.current?.index ==
                                                  (assetsAudioPlayer.playlist
                                                              ?.audios.length ??
                                                          0) -
                                                      1
                                              ? null
                                              : () {
                                                  assetsAudioPlayer.next();
                                                },
                                      icon: Icon(Icons.skip_next)),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Slider(
                                  value: snapShots
                                          .data?.currentPosition.inSeconds
                                          .toDouble() ??
                                      0.0,
                                  min: 0,
                                  max: snapShots.data?.duration.inSeconds
                                          .toDouble() ??
                                      0.0,
                                  onChanged: (value) {
                                    assetsAudioPlayer
                                        .seek(Duration(seconds: 1));
                                  }),
                              Text(
                                '${secondsToMinutes(snapShots.data?.currentPosition.inSeconds ?? 0)} / ${secondsToMinutes(snapShots.data?.duration.inSeconds ?? 0)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ));
  }

  String secondsToMinutes(int seconds) {
    String minutes = (seconds ~/ 60).toString();
    String secondsString = (seconds % 60).toString();
    return '${minutes.padLeft(2, '0')}:${secondsString.padLeft(2, '0')}';
  }

  Widget get getBtnWIdGet =>
      assetsAudioPlayer.builderIsPlaying(builder: (ctx, isPlaying) {
        return FloatingActionButton.large(
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 70,
          ),
          onPressed: () {
            if (isPlaying) {
              assetsAudioPlayer.pause();
            } else {
              assetsAudioPlayer.play();
            }
            setState(() {});
          },
          shape: CircleBorder(),
        );
      });
}
