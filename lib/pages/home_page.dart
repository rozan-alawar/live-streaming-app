import 'package:flutter/material.dart';
import 'package:streamer/pages/live_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _channelName = TextEditingController();
  final _userName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/streamer.png"),
            const SizedBox(height: 10),

            const Text("Multi Streaming with Friends"),
            const SizedBox(height: 30),

            TextButton(
              onPressed: () => jumpToLivePage(context: context, isHost: false),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('watch a live '), Icon(Icons.live_tv)],
              ),
            ),
            TextButton(
              onPressed: () => jumpToLivePage(context: context, isHost: true),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [Text('Start a live  '), Icon(Icons.cut)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  jumpToLivePage({required BuildContext context, required bool isHost}) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => LivePage(isHost: isHost)));
  }
}
