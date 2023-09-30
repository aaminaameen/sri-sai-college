import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sri_sai_col/views/auth/screens/splashScreen.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sri Sai Nursing College',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          colorScheme: ColorScheme.light(primary: kPrimaryColor),
          textTheme: const  TextTheme(
            headline1: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: kWhiteText,
            ),

            //card headings
            headline2: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kHeadingText,
            ),

            //buton text
            button: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: kWhiteText,
            ),

            //card captions
            caption: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: kYellowColor,
            ),

            // bodytext
            bodyText1: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: kTextGreyColor,
            ),

            //forms
            bodyText2: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: kTextfieldColor,
            ),


          )
      ),
      home: SplashScreen(),
    );
  }
}

