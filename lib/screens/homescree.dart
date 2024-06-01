import 'package:flutter/material.dart';
import 'package:projectapp/modals/Fetchingmeetingdetailsclass.dart';
import 'package:projectapp/screens/meetingScreen.dart';
import 'package:projectapp/utils/colors.dart';
import 'package:projectapp/widgets/googlebutton2.dart';
import 'package:projectapp/widgets/home_meetingbutton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectapp/google_authentication/authentication.dart';
import 'package:projectapp/widgets/custom_button.dart';

import '../widgets/appbar.dart';
class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}
 
class _HomescreenState extends State<Homescreen> {
   List<Widget> pages = [
    MeetingScreen(),
    MeetingDetailsScreen(),
    // const Text('Contacts',style: TextStyle(color: Colors.white),),
    GoogleBtn2(text:'Log Out', onPressed: () => GoogleAuth().signOut()),
  ];
  int currentIndex = 0;
  void onNavItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: backgroundColor,
      //   // backgroundColor: Colors.black,
      //   elevation: 110,
      //   title: const Text('Meet & Chat'),
      //   centerTitle: true,
      // ),
      appBar: GradientAppBarFb1(),
      body:pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Color.fromARGB(255, 197, 162, 10),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        items: [
          BottomNavigationBarItem(
            
            // backgroundColor: const Color.fromARGB(255, 255, 252, 252),
            icon: InkWell(
              child: Icon(
                Icons.comment_bank,
              ),
            ),
            label: 'Meet & Char',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.lock_clock,
            ),
            label: 'Meetings',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.person_outline,
          //   ),
          //   label: 'Contacts',
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.logout,
            ),
            label: 'Log out',
          ),
        ],
        currentIndex: currentIndex,
        onTap: onNavItemTapped,
      ),
    );
  }
}
 