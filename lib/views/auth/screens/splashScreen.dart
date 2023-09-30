import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sri_sai_col/views/auth/screens/loginScreen.dart';
import '../../../constants.dart';
import '../../../home/navBar.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      }
    });
  }



  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(addPadding/1),
            child: Column(
              children: [
                SizedBox(height: screenHeight*0.2,),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children:[
                    Image.asset('images/sri.jpeg', ),

                ]),
                SizedBox(height: screenHeight*0.2,),
                Text(
                  "Sri Sai Nursing School &",
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Medical Technology",
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight*0.04,),
                GestureDetector(
                  onTap: (){

                    user = FirebaseAuth.instance.currentUser;
                    if(user == null){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNav()));
                    }
                  },
                  child: Container(
                    width: 240,
                    height: 50,
                    decoration: BoxDecoration(
                      color:kWhiteText  ,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: kWhiteText , width: 2
                      ),
                    ),

                    child: Center(
                      child:RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: 'Get'+" ",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Plus Jakarta Sans'

                            ),
                            children: [
                              TextSpan(
                                text: 'Started',
                                style: TextStyle(
                                    color: kHeadingText,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Plus Jakarta Sans'
                                ),

                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }
}
