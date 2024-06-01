import 'package:flutter/material.dart';
import 'package:projectapp/widgets/home_meetingbutton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class HomeMeetingbutton extends StatefulWidget {
  final String text;
  final  IconData icons;
  final VoidCallback onpressed;
  const HomeMeetingbutton({super.key,required this.onpressed,required this.text,required this.icons});

  @override
  State<HomeMeetingbutton> createState() => _HomeMeetingbuttonState();
}

class _HomeMeetingbuttonState extends State<HomeMeetingbutton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap:() {
                    //  Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => AgoraScreen()),
                    // );
                  },
                  child: Container(
                    
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.amber,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Icon(widget.icons),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
