import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sri_sai_col/constants.dart';
import 'package:sri_sai_col/home/homeScreen.dart';
import '../../views/auth/widgets/customButton.dart';
import '../../views/auth/widgets/customTextField.dart';
import '../navBar.dart';
import 'package:intl/intl.dart';


class CourseApply extends StatefulWidget {
  CourseApply({required this.courseName, required this.id, });
  final String courseName;
  final int id;


  @override
  State<CourseApply> createState() => _CourseApplyState();
}

class _CourseApplyState extends State<CourseApply> {
  final _formKey = GlobalKey<FormState>();
  final _list = ["Male", "Female", "Other"];
  late String? valueChoose;
  TextEditingController nameController = TextEditingController();
  TextEditingController programController = TextEditingController();
  TextEditingController fatherController = TextEditingController();
  TextEditingController motherController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController tenthController = TextEditingController();
  TextEditingController twelthController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  late String uId;
  late DatabaseReference homeData;
  User? user;



  @override
  void initState() {
    super.initState();
    homeData =
        FirebaseDatabase.instance.reference().child('Details');
    uId = FirebaseAuth.instance.currentUser!.uid;
    getAccountValues();
    valueChoose = null;
   // print("course ${widget.courseName}");
    programController.text = widget.courseName;
  }



  @override
  Widget build(BuildContext context) {


    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(addPadding/1),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: screenHeight*0.07,
                      child: Text('Application Details', style: Theme.of(context).textTheme.headline1?.copyWith(color: kHeadingText))),
                  CustomTextField(
                    heading: '  '+'Name of Program', hintText:'Eg Bsc Nursing',controller: programController ,validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                   ),
                  CustomTextField(heading: '  '+'Full Name', hintText:'Eg Arun Kumar' ,controller: nameController,validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                    ),
                  CustomTextField(heading: '  '+"Father's Name", hintText:'Eg Kumar' ,controller: fatherController ,validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                   ),

                  CustomTextField(heading: '  '+"Mother's Name", hintText:'Eg Shanthi',controller: motherController ,validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                     ),

                  CustomTextField(heading: '  '+'Date of Birth', hintText:'Eg 16/02/1995' ,
                    onChanged: (val)async {DateTime?pickeddate = await showDatePicker(
                        context: context,initialDate: DateTime.now(), firstDate: DateTime(1990), lastDate: DateTime(2100));
                    if(pickeddate!= null){
                    setState(() {
                      dobController.text = DateFormat('dd/MM/yyyy').format(pickeddate);
                    });}
                    },
                    controller: dobController, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                    ),

                  SizedBox(height: screenHeight*0.005,),
                  Text(
                    '  '+'Gender',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: screenHeight*0.007,),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: DropdownButtonFormField(
                      hint: Text('Select Gender', style: TextStyle(
                        fontSize: 16,
                        color: kHintText,
                      ),),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: kTextfieldColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      value: valueChoose,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      items: _list.map((e){
                        return DropdownMenuItem(
                            value: e,
                            child: Text(e));
                      }).toList(), onChanged: (value) {
                      setState(() {
                        valueChoose = value.toString();
                      });
                    },
                    ),
                  ),
                  SizedBox(height: screenHeight*0.01,),
                  CustomTextField(heading: '  '+'Permanent Address', hintText:'Eg 10/1321/villa poojapura po', controller: addressController ,
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                    ),
                  CustomTextField(heading:'  '+ 'Phone Number', hintText:'Eg 8812345678', controller: phoneController ,validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  ),
                  CustomTextField(heading:'  '+ 'Tenth Mark', hintText:'Eg 90%' ,controller: tenthController ,validator: (value) {
    if (value == null || (int.tryParse(value) ?? -1) > 100) {
    return 'Required';
    }
    final RegExp regex = RegExp(r'^\d{0,3}(\.\d{0,2})?%?$');
    if (!regex.hasMatch(value)) {
    return 'Enter a valid percentage value';
    }
    return null;
    }
                    ),

                  CustomTextField(heading:'  '+ 'Higher Secondary Mark', hintText:'88%' , controller: twelthController ,validator: (value) {
                    if (value == null || (int.tryParse(value) ?? -1) > 100) {
                      return 'Required';
                    }
                    final RegExp regex = RegExp(r'^\d{0,3}(\.\d{0,2})?%?$');
                    if (!regex.hasMatch(value)) {
                      return 'Enter a valid percentage value';
                    }
                    return null;
                  }

                  ),
                  CustomButton(text: 'Submit',
                    ontap: (){
                 if (_formKey.currentState!.validate()){
                 _formKey.currentState?.save();
              createUser();
                    }
                  }
                  ),

           ] ),
            )
          ),
        ),
      ),
    );
  }

  Future<http.Response> createUser() async {
    String gender = '';
    if(valueChoose == "Male"){
      gender = 'Male';
    }else if(valueChoose == "Female") {
      gender = 'Female';
    }else if(valueChoose == "Other"){
      gender = 'Other';
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var response = await http.post(
      Uri.parse('https://srisai.besocial.pro/api/v1/uploadForm'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': uid,
        'name': nameController.text,
        'name_of_program': widget.id.toString(),
        'name_of_father': fatherController.text,
        'name_of_mother': motherController.text,
        'dob': dobController.text,
        'address': addressController.text,
        'phone': phoneController.text,
        'tenth_mark': tenthController.text,
        'twelfth_mark': twelthController.text,
        'sex': gender,
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Your application form is successfully submitted"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => BottomNav()),
                          (Route<dynamic> route) => false
                  );
                },
                child: Text("OK",style: TextStyle(color: kPrimaryColor),),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting form'),
        ),
      );
    }
    return response;
  }



  Future getAccountValues() async {
    return await homeData
        .orderByChild('Uid')
        .equalTo(uId)
        .once()
        .then((dataSnapshot) {
      Map<dynamic, dynamic> values = dataSnapshot.value as Map;
      values.forEach((key, values) {
        setState(() {
          user = values["uId"];
        });
      });
    });
  }


}
