import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sri_sai_col/views/auth/screens/loginScreen.dart';
import 'package:sri_sai_col/views/auth/screens/registerScreen.dart';
import 'package:sri_sai_col/views/auth/widgets/customButton.dart';
import '../../../constants.dart';
import '../../../home/navBar.dart';



class OtpScreen extends StatefulWidget {
  OtpScreen({required this.phoneNumber,});
  late final phoneNumber;


  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {



  final FirebaseAuth auth = FirebaseAuth.instance;
  String code = '';
  User? user;
  late String verificationId;
  bool mobileverified = false;
  bool otpverified = false;
  late DatabaseReference homeData;
  TextEditingController otpController = TextEditingController();
  bool _isLoading = false;


    @override
    Widget build(BuildContext context) {
      final double screenHeight = MediaQuery
          .of(context)
          .size
          .height;
      final double screenWidth = MediaQuery
          .of(context)
          .size
          .width;
      var code = "";


      return SafeArea(
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Column(
            children: [
              SizedBox(height: screenHeight * .1,),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'OTP Verification\n',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline1,
                    children: [
                      TextSpan(
                        text: 'We will send you one time\n',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline1
                            ?.copyWith(fontSize: 18,fontWeight: FontWeight.w400 ),

                      ),
                      TextSpan(
                        text: 'password to this phone number.',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline1
                            ?.copyWith(fontSize: 18,fontWeight: FontWeight.w400),
                      ),
                    ]),
              ),

              SizedBox(
                height: screenHeight * .1,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: kWhiteText,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(addPadding / 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * .03,),
                          Image.asset('images/verified.png',
                            height: screenHeight * 0.3,),
                          SizedBox(height: screenHeight * .03,),
                          Container(
                            color: kWhiteText,
                            height: screenHeight * .1,
                            width: screenWidth * .8,
                            child: Form(
                              child: PinCodeTextField(
                                  controller: otpController,
                                  textStyle: TextStyle(color: kHeadingText),
                                  appContext: context,
                                  length: 6,
                                  onChanged: (value) {
                                    code = value;
                                    if (otpController.text.length == 6 &&
                                        mobileverified == true) {
                                      setState(() {
                                        otpverified = true;
                                      });
                                    } else {
                                      setState(() {
                                        otpverified = false;
                                      });
                                    }
                                  },
                                  pinTheme: PinTheme(
                                      activeColor: kHeadingText,
                                      activeFillColor: kWhiteText,
                                      inactiveColor: kPrimaryColor,
                                      inactiveFillColor: kWhiteText,
                                      selectedFillColor: kWhiteText,
                                      selectedColor: kPrimaryColor,
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 40,
                                      borderWidth: 0.5),
                                  cursorColor: Color.fromRGBO(49, 39, 79, 1),
                                  animationDuration: const Duration(
                                      milliseconds: 300),
                                  keyboardType: TextInputType.number,
                                  enableActiveFill: true,
                                  onCompleted: (pin) async {
                                    try {
                                      PhoneAuthCredential credential = PhoneAuthProvider
                                          .credential(
                                          verificationId: LoginScreen.verify,
                                          smsCode: pin);
                                      UserCredential userCredential =
                                      await FirebaseAuth.instance.signInWithCredential(credential);
                                      User? firebaseUser = userCredential.user;
                                      getAccountValues(firebaseUser!.uid);
                                    } catch (e) {
                                      print("wrong otp");
                                    }
                                  }
                              ),
                            ),),
                          Row( mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Edit Phone Number? ',
                                  style: TextStyle(
                                  fontSize: 18,
                                  color: kMainText,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Plus Jakarta Sans'
                              )),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LoginScreen())
                                  );
                                },
                                child: Text('Click here ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: kHeadingText,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Plus Jakarta Sans'
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.05,),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLoading = true;
                              });
                              Future.delayed(Duration(seconds: 3),(){
                                setState(() {
                                  _isLoading = false;
                                });
                              });
                            },
                            child: Container(
                              width: screenWidth *.63,
                              height: screenHeight * .06,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow:[
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4), //color of shadow
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 5),
                                  ),
                                ],),
                              child: Center(
                                  child: _isLoading?
                                  SizedBox(
                                    height: screenHeight*.0213,
                                    width: screenWidth*.0432,
                                    child: CircularProgressIndicator(
                                      color: kWhiteText,
                                    ),
                                  ):Text(
                                      "Submit",
                                      style: Theme.of(context)
                                          .textTheme
                                          .button!
                                          .copyWith(color: kWhiteText)
                                  )),
                            ),
                          ),
                          SizedBox(height: screenHeight * .03,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  Future getAccountValues(uId) async {
    print(uId);
    DatabaseReference homeData = FirebaseDatabase.instance.reference().child('Details');
    return await homeData
        .orderByChild('Uid')
        .equalTo(uId)
        .once()
        .then((dataSnapshot) {
      Map<dynamic, dynamic>? values = dataSnapshot.value as Map?;
      print(values);
      if (dataSnapshot == null || dataSnapshot.value == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen(phoneNumber: widget.phoneNumber,)),
        );
      } else {
        Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      }
    });
  }
  }

