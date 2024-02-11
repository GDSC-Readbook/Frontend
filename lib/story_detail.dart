import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'story.dart';

class StoryDetailScreen extends StatefulWidget {
  final Story story;

  StoryDetailScreen({required this.story});

  @override
  _StoryDetailScreenState createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    flutterTts.setStartHandler(() {
      // Playback started
      setState(() {
        isPlaying = true;
      });
    });
    flutterTts.setCompletionHandler(() {
      // Playback completed
      setState(() {
        isPlaying = false;
      });
    });
    flutterTts.setErrorHandler((msg) {
      // Error
      setState(() {
        isPlaying = false;
      });
    });
    flutterTts.setVolume(1.0); 
  }

  void _togglePlay() async {
    if (isPlaying) {
      await flutterTts.stop();
    } else {
      await flutterTts.speak(widget.story.content);
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now playing', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 480,
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                    child: Text(
                      widget.story.content,
                      style: const TextStyle(
                          fontSize: 25.0,
                          height: 1.5,
                          color: Color.fromARGB(255, 128, 128, 128)),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.story.name,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30.0), // 타이틀과 재생 버튼 사이의 간격 조절
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.green,
                        child: IconButton(
                          icon:
                              Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                          color: Colors.white,
                          iconSize: 36.0,
                          onPressed: _togglePlay,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
