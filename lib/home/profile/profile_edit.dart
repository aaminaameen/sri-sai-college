import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../views/auth/widgets/customButton.dart';
import '../../views/auth/widgets/customTextField.dart';



class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {

  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final titleController = TextEditingController();
  final nameController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  late String uId;
  bool isLoading = false;
  late DatabaseReference homeData;
  String? profileKey;
  String imageUrl = "";
  String photoString = "";
  File? image ;
  final _picker = ImagePicker();
  Reference ref = FirebaseStorage.instance.ref().child("profile");


  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    nameController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    homeData =
        FirebaseDatabase.instance.reference().child('Details');
    uId = FirebaseAuth.instance.currentUser!.uid;
    getAccountValues();
    imageUrl = '';
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

  Future getImage()async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery , imageQuality: 80);
     print(pickedFile);

     if (pickedFile == null) return;

    setState(() {
      image = File(pickedFile.path);
    });

     String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImage.child(uniqueFileName);

    try{
     await referenceImageToUpload.putFile(File(pickedFile.path));
     imageUrl= await referenceImageToUpload.getDownloadURL();
     print(imageUrl);

    }catch (error){

    }
  }


  @override
  Widget build(BuildContext context) {


    final double screenHeight = MediaQuery.of(context).size.height;


    return SafeArea(
      child: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          body:  Padding(
            padding: const EdgeInsets.all(addPadding/1),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          height: screenHeight*0.07,
                          child: Text('Profile', style: Theme.of(context).textTheme.headline1?.copyWith(color: kHeadingText))),
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 40,
                          child: Stack(
                            children: [
                              photoString.isNotEmpty? ClipRRect(
                                borderRadius:
                                new BorderRadius.all(Radius.circular(40)),
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                    border: Border.all(width: 0.3),
                                    color: Colors.white,
                                  ),
                                  child: Image.network(
                                    photoString,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ):Image.asset('images/clip.png'),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color:kPrimaryColor,
                                        shape: BoxShape.circle
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        getImage().then((value) {
                                          accountData();
                                        });
                                      },
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),

                      ),
                   SizedBox(height: screenHeight*0.02,),
                   Center(child: Text('Change Picture', style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 16))),
                      SizedBox(height: screenHeight*0.03,),
                      CustomTextField(heading: 'Full Name', hintText:'Jessie Pink Man', controller: nameController, ),

                      CustomTextField(heading: 'Email Id', hintText:'jessie@email.com', controller: emailController, ),

                      CustomTextField(heading: 'Title', hintText:'Nursing Student' ,controller: titleController,),

                      CustomTextField(heading: 'Phone Number', hintText:'+91-8825634523', controller: phoneController, ),
                      SizedBox(height: screenHeight*.03,),
                      CustomButton(
                          text: 'Update',
                          ontap: (){
                            if (_formKey.currentState!.validate()) {
                              accountData().then((value){
                               showSnack("Updated Successfully");
                              });
                            }
                            }
                          ),
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

      Map<dynamic, dynamic> values = dataSnapshot.value as Map;
      values.forEach((key, value) {

        setState(() {
          nameController.text = value["Name"];
          emailController.text = value["Email"];
          titleController.text = value["Title"];
          phoneController.text = value["Phone_Number"];
          photoString = value["image"];
          profileKey = key;
        });
        print(photoString);
      });
    });
  }

  dynamic accountData() async {
    try {
      String datetime = DateTime.now().toString();
      Map<String, dynamic> accountData = {
        "Email":  emailController.text,
        "Phone_Number": phoneController.text,
        "Name": nameController.text,
        "created_datetime": datetime,
        "image":  imageUrl,
        "Title": titleController.text,
      };
      await homeData.child(profileKey!).update(accountData);
      print('Account data updated successfully.');
      photoString = imageUrl;
    } catch (error) {
      print('Error updating account data: $error');
    }
 }
}