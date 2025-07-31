import 'dart:math';

import 'package:flutter/material.dart';
import 'package:streamer/utils/app_config.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LivePage extends StatefulWidget {
  final bool isHost;

  const LivePage({super.key, required this.isHost});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  final String userId = Random().nextInt(1000).toString();

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltLiveStreaming(
      appID: AppConfig.appID,
      userID: userId,
      userName: "userName_$userId",
      liveID: "testliveID",
      config:
          widget.isHost
              ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
              : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      appSign: AppConfig.appSign,
    );
  }
}
