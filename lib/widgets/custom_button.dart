// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:projectapp/screens/homescree.dart';
// import 'package:projectapp/widgets/custom_button.dart';
// import 'package:projectapp/widgets/resources/authentication.dart';

// class CustomButton extends StatelessWidget {
//   final String text;
//   final void onpressed;
//   const CustomButton({super.key, required this.text,required this.onpressed});

//   @override
//   Widget build(BuildContext context) {
//      late bool res;
//     return ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           minimumSize: Size(double.infinity, 50),
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30))),
//         onPressed: () async{
//           bool res =await GoogleAuth().signinwithgoogle();
//           if (res=true) {
//              ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   'You have login sucessfully',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 backgroundColor: Color.fromARGB(255, 16, 199, 10), // Customize the background color
//                 elevation: 6.0, // Add shadow to the Snackbar
//                 behavior: SnackBarBehavior.floating, // Make the Snackbar float above the content
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0), // Round the corners
//                 ),
//               ));
//               Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) =>Homescreen()));
//           }
//           else
//           {
//              ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   'login fail',
//                   style: TextStyle(color: const Color.fromARGB(255, 159, 9, 9)),
//                 ),
//                 backgroundColor: Colors.blue, // Customize the background color
//                 elevation: 6.0, // Add shadow to the Snackbar
//                 behavior: SnackBarBehavior.floating, // Make the Snackbar float above the content
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0), // Round the corners
//                 ),
//               ));
//           }
//         },
//         child: Text(
//           text,
//           style: TextStyle(fontSize: 17),
//         )
//         );
//   }
// }
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 17,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          minimumSize: const Size(
            double.infinity,
            50,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            // side: const BorderSide(color: buttonColor),
          ),
        ),
      ),
    );
  }
}
