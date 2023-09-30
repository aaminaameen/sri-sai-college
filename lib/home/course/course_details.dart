import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sri_sai_col/constants.dart';
import 'package:sri_sai_col/views/auth/widgets/customButton.dart';

import '../../views/auth/services/repo.dart';
import 'course_apply.dart';

class CourseDetails extends StatefulWidget {

    CourseDetails({required this.coursesData,});
  final Map coursesData;


  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {

  List<dynamic> coursesData = [];


  @override
  void initState() {
    super.initState();
    getData();
  }
  void getData() async{
    List data = await UserRepo.courseData();
    setState(() {
      coursesData = data;
    });
  }


  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                    width: screenWidth,
                    child:  Image.network(widget.coursesData["course_img"], fit: BoxFit.fill,),
                )],
            ),
            Positioned(
              top: screenHeight*0.04,
              left: screenWidth*0.08,
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.arrow_back_ios_new, color: kWhiteText,),
                    SizedBox(width: screenWidth*0.05,),
                    Text('Course Details', style: Theme.of(context).textTheme.headline1,)
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: screenHeight*.75,
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: kWhiteText,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(addPadding/1),
                  child: SingleChildScrollView(
                    child: Container(
                      
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(height: screenHeight*0.02,),
                          Text(widget.coursesData['course_name'],style: Theme.of(context).textTheme.headline1?.copyWith(color: kHeadingText)),
                         SizedBox(height: screenHeight*0.02,),
                      Text(widget.coursesData["course_description"],
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w400, fontSize: 18, color: kMainText)),

                          SizedBox(height: screenHeight*0.03,),



                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight*.05,left: screenWidth*.2,
              child: CustomButton(text: 'Apply',ontap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CourseApply(courseName: widget.coursesData['course_name'], id: widget.coursesData['course_id'],)));
              }),
            ),

          ],
        ),
      ),
    );
  }
}
