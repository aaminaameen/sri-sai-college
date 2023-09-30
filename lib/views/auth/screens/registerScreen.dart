import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../home/navBar.dart';
import '../widgets/customButton.dart';
import '../widgets/customTextField.dart';
import 'loginScreen.dart';


class RegisterScreen extends StatefulWidget {
  RegisterScreen({required this.phoneNumber,});
  late final phoneNumber;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  late String _email, _password, _phone;
  late DatabaseReference accountDetails = FirebaseDatabase.instance.reference().child("Details");
    var uidd = FirebaseAuth.instance.currentUser!.uid;

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    nameController.dispose();
    passController.dispose();
    super.dispose();
  }



  bool validateEmail(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool validateMobileNumber(String mobileNumber) {
    String pattern = r'^\d{10}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(mobileNumber);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneController.text = widget.phoneNumber;
  }


  @override
  Widget build(BuildContext context) {
    print(uidd);
    final double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Column(
          children: [
            SizedBox(height: screenHeight*.1,),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Create An Account\n',
                style: Theme.of(context).textTheme.headline1,
                  children: [
                    TextSpan(
                      text: 'Start your journey',
                      style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 18,fontWeight: FontWeight.w400 ),

                    ),
                  ]),
            ),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight*.01,),
                          CustomTextField(heading: '  '+'Email', hintText:'Eg abc@gmail.com' ,controller:emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              } else if (!validateEmail(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value!;
                            },),
                          SizedBox(height: screenHeight*.009,),


                          CustomTextField(heading: '  '+"Phone", hintText:'Eg 8812345678', controller:phoneController,
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
                            }, ),
                          SizedBox(height: screenHeight*.009,),


                          CustomTextField(heading:'  '+ 'Name', hintText:'Eg Arun Kumar',controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },),
                          SizedBox(height: screenHeight*.06,),



                          Center(
                            child: CustomButton(
                                text: 'Register',
                                ontap: (){
                                   if (_formKey.currentState!.validate()) {
                                     _formKey.currentState?.save();
                                     accountData();
                                   }
                                }),
                          ),
                        ],
                      ),
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

  dynamic accountData() async {


    String datetime = DateTime.now().toString();
    Map<dynamic, dynamic> accountData = {
      "Uid": uidd,
      "Email":  emailController.text.toString(),
      "Phone_Number": phoneController.text,
      "Name": nameController.text.toString(),
      "created_datetime": datetime,
      "image": "",
      "Title": "",
      "School Name": "",
      "Tenth Mark":"",
      "Higher Secondary":  "",
      "Plus Two Stream":"",
      "Plus Two Mark": "",
    };
    await accountDetails.push().set(accountData);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNav()),
    );
  }


}
