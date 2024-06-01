import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectapp/widgets/googlbutton.dart';
class GoogleBtn2 extends StatelessWidget {
final Function() onPressed;
final String text;
  const GoogleBtn2({
    required this.text,
required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 54,
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/crypto%2Fsearch%20(2).png?alt=media&token=24a918f7-3564-4290-b7e4-08ff54b3c94c",
                    width: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("Google",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Text("Log Out",
                  style: TextStyle(color: Colors.black, fontSize: 10,fontStyle: FontStyle.italic)),
            ],
          ),
          onPressed: onPressed,
        ));
  }
}