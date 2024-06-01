import 'package:projectapp/modals/deSerialization_class.dart';
class MeetingDetails {
  final String code;
  final DateTime date_time;

  MeetingDetails({
    required this.code,
    required this.date_time,
  });

  factory MeetingDetails.fromMap(Map<String, dynamic> map) {
    return MeetingDetails(
      code: map['code'],
      date_time: map['day'].toDate(),
    );
  }
}
