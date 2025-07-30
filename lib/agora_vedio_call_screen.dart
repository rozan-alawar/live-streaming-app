import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:streamer/core/config/app_config.dart';

class VedioCallScreen extends StatefulWidget {
  const VedioCallScreen({super.key});

  @override
  State<VedioCallScreen> createState() => _VedioCallScreenState();
}

class _VedioCallScreenState extends State<VedioCallScreen> {
  AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: AppConfig.appID,
      channelName: 'test',
    ),
    enabledPermission: [Permission.camera, Permission.microphone],
  );

  @override
  void initState() {
    super.initState();
    client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vedio Call")),
      body: Stack(
        children: [
          AgoraVideoViewer(client: client),
          AgoraVideoButtons(client: client),
        ],
      ),
    );
  }
}
