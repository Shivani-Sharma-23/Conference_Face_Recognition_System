import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../ZEGOCLOUD-NEW_Meeting_setup/providerpage.dart';
import 'deSerialization_class.dart';
import 'package:intl/intl.dart';
import 'package:projectapp/widgets/circularindicator.dart';
class MeetingDetailsScreen extends StatelessWidget {
  final RandomNumberProvider randomNumberProvider = RandomNumberProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: getMeetingDetails(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: DottedCircularProgressIndicatorFb(currentDotColor:Colors.amber , defaultDotColor: Colors.deepPurple, numDots: 10, size: 75, dotSize: 6, secondsPerRotation: 1,)
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No meeting details available.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot document = snapshot.data!.docs[index];
              final MeetingDetails meetingDetails = MeetingDetails.fromMap(
                document.data() as Map<String, dynamic>,
              );

              // Format the date and time to 12-hour format
              final formattedDateTime = DateFormat('MMM d, y hh:mm a').format(meetingDetails.date_time);

              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meeting Code',
                      style: TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${meetingDetails.code}',
                      style: TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  formattedDateTime,
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    // fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<QuerySnapshot> getMeetingDetails() async {
    await Future.delayed(Duration(seconds: 1));
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference meetingsCollection = firestore.collection('meetings');
    QuerySnapshot snapshot = await meetingsCollection.get();
    return snapshot;
  }
}
