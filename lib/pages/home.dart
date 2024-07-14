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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Song Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      getBtnWIdGet,
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        '00:00 / 2:30',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // IconButton(icon: assetsAudioPlayer.builderIsPlaying(
              //     builder: (context, isPlaying) {
              //   return Icon(isPlaying ? Icons.pause : Icons.play_arrow);
              // }), onPressed: () async {
              //   await assetsAudioPlayer.open(
              //     Audio("assets/1.mp3"),
              //   );
              //   setState(() {});
              // }),
            ],
          ),
        ));
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
