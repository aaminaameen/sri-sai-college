import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../views/auth/widgets/customButton.dart';
import '../../views/auth/widgets/customTextField.dart';


class EducationDetails extends StatefulWidget {
  const EducationDetails({Key? key}) : super(key: key);

  @override
  State<EducationDetails> createState() => _EducationDetailsState();
}

class _EducationDetailsState extends State<EducationDetails> {

  final _formKey = GlobalKey<FormState>();
  final schoolController = TextEditingController();
  final tenController = TextEditingController();
  final plustwoController = TextEditingController();
  final streamController = TextEditingController();
  final markController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  late String uId;
  late String _school, _ten, _plustwo, _stream, _mark;
  late DatabaseReference homeData;
  String? profileKey;


  @override
  void dispose() {
    schoolController.dispose();
    tenController.dispose();
    plustwoController.dispose();
    streamController.dispose();
    markController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    homeData =
        FirebaseDatabase.instance.reference().child('Details');
    uId = FirebaseAuth.instance.currentUser!.uid;
    getAccountValues();
  }
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();
  void showSnack(String title) {
    final snackbar = SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15,
              color: Colors.white
          ),
        ));
    scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
  }


  @override
  Widget build(BuildContext context) {


    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          body:  SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(addPadding/1),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          height: screenHeight*0.07,
                          child: Text('Education Details', style: Theme.of(context).textTheme.headline1?.copyWith(color: kHeadingText))),

                      CustomTextField(heading: 'School Name', hintText:'Enter text here' , controller:schoolController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                       ),

                      CustomTextField(heading: 'Tenth Mark', hintText:'Enter text here' , controller:tenController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                       ),

                      CustomTextField(heading: 'Higher Secondary School Name', hintText:'Enter text here',controller:plustwoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                         ),

                      CustomTextField(heading: 'Plus Two Stream', hintText:'Enter text here',controller:streamController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
    ),
                      CustomTextField(heading: 'Plus Two Mark', hintText:'Enter text here' ,controller:markController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        ),
                      SizedBox(height: screenHeight*.01,),
                      CustomButton(
                          text: 'Update',
                          ontap: (){
    if (_formKey.currentState!.validate()) {
        accountData().then((value){
          if (_formKey.currentState!.validate()) {
            accountData().then((value){
              showSnack("Updated Successfully");
            });
          }
        });
    }
                             }),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future getAccountValues() async {
    return await homeData
        .orderByChild('Uid')
        .equalTo(uId)
        .once()
        .then((dataSnapshot) {

      Map<dynamic, dynamic> values = dataSnapshot.value as Map; print(values);
      values.forEach((key, value) {
        setState(() {
          schoolController.text = value["School Name"];
          plustwoController.text = value["Tenth Mark"];
          tenController.text = value["Higher Secondary"];
          streamController.text = value["Plus Two Stream"];
          markController.text = value["Plus Two Mark"];
          profileKey = key;
          // imgUrl = []
        });
      });
    });
  }


  dynamic accountData() async {
    try {
      print(profileKey);
      if (profileKey != null) {
        String datetime = DateTime.now().toString();
        Map<String, dynamic> accountData = {
          "School Name":  schoolController.text,
          "Tenth Mark": tenController.text,
          "Higher Secondary": plustwoController.text,
          "Plus Two Stream": streamController.text,
          "Plus Two Mark": markController.text,
          "Title": "",
          "created_datetime": datetime,
        };
        await homeData.child(profileKey!).update(accountData);
        print('Account data updated successfully.');
      } else {
        print('Error updating account data: profileKey is null.');
      }
    } catch (error) {
      print('Error updating account data: $error');
    }
  }

}
