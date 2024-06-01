import 'package:flutter/material.dart';
import 'package:projectapp/widgets/appbar.dart';
// import 'package:projectapp/setupscreem.dart';;
import '../utils/colors.dart';

class Authentication2 extends StatefulWidget {
  const Authentication2({super.key});

  @override
  State<Authentication2> createState() => _Authentication2State();
}

class _Authentication2State extends State<Authentication2> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: backgroundColor,
      //   elevation: 110,
      //   title: const Text('Meet & Chat'),
      //   centerTitle: true,
      // ),
      appBar: GradientAppBarFb1(),
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 19),
              child: Center(
                child: CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRphr9bobOMRVBnpGqzJzwsmBAlgav5MjFwg4iXdtCo8ZjbyZj7-BsDppI6gUdIbJH-xW0&usqp=CAU"),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 350,
            height: 60,
            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  // labelText: 'Enter your text',
                  hintText: 'Enter The Channel Name'),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 102, 190, 34),
              primary: buttonColor,
              minimumSize: const Size(
                19,
                50,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
            },
            child: Text(
              'Join',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
