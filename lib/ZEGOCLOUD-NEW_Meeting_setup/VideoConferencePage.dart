import 'package:flutter/material.dart';
import 'package:projectapp/ZEGOCLOUD-NEW_Meeting_setup/VideoConferencePage.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

import 'dart:math' as math;

import '../utils/colors.dart';
// Project imports:

class VideoConferencePage extends StatelessWidget {
  final String conferenceID;
  final TextEditingController controller;

  const VideoConferencePage({
    Key? key,
    required this.conferenceID,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String localUserID = math.Random().nextInt(10000).toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 110,
        title: const Text('Authentication'),
        centerTitle: true,
      ),
      body: SafeArea(
        
        child: ZegoUIKitPrebuiltVideoConference(
          appID: 918905515/*input your AppID*/,
          appSign: "67395a06f495381dab9101e7d6581a7b146af026880d5f6ac470e0349bd64c72"/*input your AppSign*/,
          userID:  localUserID,
          userName: controller.text,
          conferenceID: conferenceID,
          config: ZegoUIKitPrebuiltVideoConferenceConfig()
            // ..avatarBuilder = customAvatarBuilder,
        ),
      ),
    );
  }
}