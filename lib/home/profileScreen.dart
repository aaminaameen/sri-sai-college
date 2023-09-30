import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sri_sai_col/home/profile/education_details.dart';
import 'package:sri_sai_col/home/profile/profile_edit.dart';
import 'package:sri_sai_col/views/auth/screens/loginScreen.dart';
import 'package:sri_sai_col/views/auth/widgets/customButton.dart';
import '../../constants.dart';
import '../views/auth/screens/alert_logout.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String title = 'AlertDialog';
  bool tappedYes = false;
  late String uId;
  String? _name, _title;
  String photoString="";
  late DatabaseReference homeData;


  @override
  void initState() {
    super.initState();
    homeData =
        FirebaseDatabase.instance.reference().child('Details');
    uId = FirebaseAuth.instance.currentUser!.uid;
    getAccountValues();
  }



  final FirebaseAuth auth = FirebaseAuth.instance;

  signOut() async {
    await auth.signOut();


    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
            (Route<dynamic> route) => false
    );

    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
      body:  Padding(
        padding: const EdgeInsets.all(addPadding/1),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: screenHeight*0.06,
                  child: Text('Profile', style: Theme.of(context).textTheme.headline1?.copyWith(color: kHeadingText))),
             SizedBox(height: screenHeight*0.04,),
              Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 40,
                          child: photoString.isNotEmpty? ClipRRect(
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
                          ):Image.asset('images/clip.png')),
                    ),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: 'Hi, ${_name ?? ""}\n',
                            style: Theme.of(context).textTheme.headline2?.copyWith(fontSize: 20),
                            children: [
                              TextSpan(
                                text: "${_title ?? ""}",
                                style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),

                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight*0.07,),

              Text('Personal Info', style: Theme.of(context).textTheme.bodyText2),
              SizedBox(height: screenHeight*0.02,),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileEdit()));
                },
                child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.person_add_alt,),
                        SizedBox(width: screenWidth*0.03,),
                        Text('Profile', style: Theme.of(context).textTheme.headline2?.copyWith( fontWeight: FontWeight.w600),),

                      ],
                    ),
                     Icon(Icons.arrow_forward_ios_outlined, color: kMainText,),
                  ],
                ),
              ),
              SizedBox(height: screenHeight*0.03,),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EducationDetails()));
                },
                child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.feed_outlined),
                        SizedBox(width: screenWidth*0.03,),
                        Text('Education Details', style: Theme.of(context).textTheme.headline2?.copyWith( fontWeight: FontWeight.w600),),
                      ],
                    ),
                   Icon(Icons.arrow_forward_ios_outlined, color: kMainText,),
                  ],
                ),
              ),
              SizedBox(height: screenHeight*0.2,),
              InkWell(
                  onTap: () async {
                    final action = await AlertDialogs.yesCancelDialog(context, 'Logout', 'Are you sure?');
                    if (action == DialogsAction.cancel) {
                      setState(() => tappedYes = true);
                    } else {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return LoginScreen();
                        }));
                      });
                    }
                  },
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {

                  final action = await AlertDialogs.yesCancelDialog(context, 'Log Out', 'Are you sure?');
                  if (action == DialogsAction.yes){
                  setState(() => signOut());
                  }else setState(() => tappedYes = false);
                  },
                      child: Container(
                        width: 280,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: kSecondaryColor, width: 2
                          ),
                        ),

                        child: Center(
                          child: Text(
                              'Log Out',
                            style: Theme.of(context)
                                .textTheme
                                .button!
                                .copyWith(color: kSecondaryColor),
                          ),
                        ),
                      ),
                    ),
                  )
              )


                    ]),
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
      values.forEach((key, values) {
        setState(() {
          _name = values["Name"];
          _title = values["Title"];
          photoString = values["image"];
          // imgUrl = []
        });
      });
    });
  }
}
