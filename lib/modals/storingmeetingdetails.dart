import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectapp/google_authentication/authentication.dart';
import 'package:projectapp/modals/storingmeetingdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class MeetingDetails {
  final String code;
  final DateTime date_time;


  MeetingDetails({
    required this.code,
    required this.date_time,
  });
  Map<String, dynamic> tojason() {
    return {
      'code': code,
      'day': date_time,
    };
  }
}
Future<void> uploadMeetingDetails(String code, DateTime date_time) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference meetingsCollection = firestore.collection('meetings');

    MeetingDetails meeting = MeetingDetails(code: code, date_time: date_time, );

    await meetingsCollection.doc(meeting.code).set(meeting.tojason());

    print('Meeting details uploaded successfully!');
  } catch (error) {
    print('Failed to upload meeting details: $error');
  }
}