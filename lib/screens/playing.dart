import 'package:flutter/material.dart';

class PlayingScreen extends StatelessWidget {
  const PlayingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          '',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
