// - - - - - - - - - - - - Instructions - - - - - - - - - - - - - -
// Place AppBarFb1 inside the app bar property of a Scaffold
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectapp/widgets/appbar.dart';
class GradientAppBarFb1 extends PreferredSize {
  GradientAppBarFb1({Key? key})
      : super(
          key: key,
          preferredSize: const Size.fromHeight(56.0),
          child: AppBar(
            title: Center(
              child: Center(
                child: const Text(
                  "Meet & Chat",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            backgroundColor: Color.fromARGB(255, 52, 48, 46), // Amber color
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 219, 157, 14), Color.fromARGB(255, 15, 13, 5)], // Amber gradient
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),
        );
}

