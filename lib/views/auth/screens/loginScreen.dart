import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sri_sai_col/views/auth/screens/otpScreen.dart';
import '../../../constants.dart';
import '../widgets/customTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String verify = '';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController phoneController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  late String _phone;
  String code = '';
  User? user;
  bool _isLoading = false;
  late String uId;
  String? profileKey;
  late DatabaseReference homeData;
  final _formKey = GlobalKey<FormState>();


  bool validateMobileNumber(String mobileNumber) {
    String pattern = r'^\d{10}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(mobileNumber);
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;


    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Column(
          children: [
            SizedBox(height: screenHeight*.1,),
            Center(child: Text("Hi, Welcome !",  style: Theme.of(context).textTheme.headline1,)),
            SizedBox(
              height: screenHeight*.1,
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
                    padding: EdgeInsets.all(addPadding/1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight*.02,),
                        Image.asset('images/password.png', height: screenHeight*0.3,),
                        SizedBox(height: screenHeight*.05,),
                        Text('Please enter the phone number we will send the OTP in this phone number',
                          style: TextStyle(
                            fontSize: 18,
                            color: kMainText,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Plus Jakarta Sans'
                          )),
                        Form(
                          key: _formKey,
                          child: CustomTextField(heading: '', hintText: '  '+'Eg 8812345678',controller: phoneController,
                            keyBoard: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a mobile number';
                              } else if ( !validateMobileNumber(value)) {
                                return 'Please enter a valid mobile number';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _phone = value!;
                            },),
                        ),
                        SizedBox(height: screenHeight*0.02,),
                        GestureDetector(
                          onTap: () {
                           if (_formKey.currentState!.validate()){
                             _formKey.currentState?.save();
                             verifyNumber();
                           }
                            setState(() {
                              _isLoading = true;
                            });
                            Future.delayed(Duration(seconds: 9),(){
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          },
                          child: Container(
                            width: screenWidth *.7,
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
                                  "Continue",
                                    style: Theme.of(context)
                                        .textTheme
                                        .button!
                                        .copyWith(color: kWhiteText)
                                )),
                          ),
                        ),

                        SizedBox(height: screenHeight*.03,),
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
  void verifyNumber(){

    auth.verifyPhoneNumber(phoneNumber: "+91 ${phoneController.text}" ,
      verificationCompleted: (PhoneAuthCredential credential) async{
        await auth.signInWithCredential(credential).then((value) {
          print("logged in sucessfully");
        });
      },
      verificationFailed:(FirebaseAuthException exception){
        print(exception.message);
      },

      codeSent: (String verificationId, int? resendToken) {
     // print('verificationId       -----   $verificationId');
      // print('resendToken       -----   $resendToken');
        LoginScreen.verify = verificationId;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => OtpScreen(phoneNumber: phoneController.text.toString())),
        );
      },
      codeAutoRetrievalTimeout:
          (String verificationId) {},
    );

  }


}


