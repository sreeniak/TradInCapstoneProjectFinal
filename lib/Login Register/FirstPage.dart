
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool _applyBlur = true;
  List<String> imagePaths = [
    'assets/tees.png',
    'assets/dress.png',
    'assets/jacket.png',
    'assets/speaker.png',
    'assets/matt.png',
    'assets/laptop.png',
    'assets/ipod.png',
    'assets/shoes.png',
    'assets/handbag.png',
    'assets/pot.png',
    'assets/ipad.png',
    'assets/camera.png',
    // set
    'assets/tees.png',
    'assets/dress.png',
    'assets/jacket.png',
    'assets/speaker.png',
    'assets/matt.png',
    'assets/laptop.png',
    'assets/ipod.png',
    'assets/shoes.png',
    'assets/handbag.png',
    'assets/pot.png',
    'assets/ipad.png',
    'assets/camera.png',
    // set
    'assets/tees.png',
    'assets/dress.png',
    'assets/jacket.png',
    'assets/speaker.png',
    'assets/matt.png',
    'assets/laptop.png',
    'assets/ipod.png',
    'assets/shoes.png',
    'assets/handbag.png',
    'assets/pot.png',
    'assets/ipad.png',
    'assets/camera.png',
    // set
    'assets/tees.png',
    'assets/dress.png',
    'assets/jacket.png',
    'assets/speaker.png',
    'assets/matt.png',
    'assets/laptop.png',
    'assets/ipod.png',
    'assets/shoes.png',
    'assets/handbag.png',
    'assets/pot.png',
    'assets/ipad.png',
    'assets/camera.png',
    // set
    'assets/tees.png',
    'assets/dress.png',
    'assets/jacket.png',
    'assets/speaker.png',
    'assets/matt.png',
    'assets/laptop.png',
    'assets/ipod.png',
    'assets/shoes.png',
    'assets/handbag.png',
    'assets/pot.png',
    'assets/ipad.png',
    'assets/camera.png',
    // set
    'assets/tees.png',
    'assets/dress.png',
    'assets/jacket.png',
    'assets/speaker.png',
    'assets/matt.png',
    'assets/laptop.png',
    'assets/ipod.png',
    'assets/shoes.png',
    'assets/handbag.png',
    'assets/pot.png',
    'assets/ipad.png',
    'assets/camera.png',
  ];

  ScrollController _gridScrollController = ScrollController();

  @override
  void dispose() {
    _gridScrollController.dispose(); // Dispose of the ScrollController.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _applyBlur = false;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_gridScrollController.hasClients) {
        double maxScrollExtent = _gridScrollController.position.maxScrollExtent;
        double minScrollExtent = _gridScrollController.position.minScrollExtent;
        animateToMaxMin(maxScrollExtent, minScrollExtent, maxScrollExtent, 70);
      }
    });
  }

  void animateToMaxMin(double max, double min, double direction, int seconds) {
    _gridScrollController
        .animateTo(direction, duration: Duration(seconds: seconds), curve: Curves.linear)
        .then((value) {
      if (mounted) {
        direction = direction == max ? min : max;
        animateToMaxMin(max, min, direction, seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        toolbarHeight: 100.0,
        automaticallyImplyLeading: false,
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            'assets/tradin.png',
            height: 80.0,
            width: 80.0,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          // Grid at the bottom
          GridView.builder(
            controller: _gridScrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return Image.asset(imagePaths[index]);
            },
          ),
          // Transition between blurred and unblurred state using AnimatedCrossFade
          AnimatedCrossFade(
            firstChild: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: _buildOverlayContent(),
              ),
            ),
            secondChild: _buildOverlayContent(),
            crossFadeState: _applyBlur ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: Duration(seconds: 4),
          ),
        ],
      ),
    );
  }



  Widget _buildOverlayContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.0),
              color: Colors.white.withOpacity(0.6),
              border: Border.all(
                color: Colors.grey[400]!,  // Set your desired border color here
                width: 2.0,  // Set your desired border width here
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 4),
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...TradIN.ca',
                prefixIcon: Icon(Icons.search, color: Colors.black54),
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.black38),
              ),
            ),
          ),

          SizedBox(height: 30.0),

          // Text
          Center(
            child: Text(
              "LOGIN or CREATE \n your TradIN account today!!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 0.2,
              ),
            ),
          ),

          SizedBox(height: 30.0),

          // Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('Login', () {
                Navigator.pushNamed(context, '/loginpage');
              }),
              _buildButton('Register', () {
                Navigator.pushNamed(context, '/registerpage');
              }),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildButton(String label, VoidCallback onPressed) {
    return Container(
      width: 120.0,
      height: 40.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              side: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}


