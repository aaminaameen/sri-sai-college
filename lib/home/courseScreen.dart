import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/cupertino.dart';
import '../constants.dart';
import '../views/auth/services/repo.dart';
import 'course/course_details.dart';




class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {

  List<dynamic> coursesData = [];
  List< dynamic> mainCourseList = [];
  bool isDataFetched = false;
  TextEditingController searchController = TextEditingController();



  void _handleSearch(String searchText) {
    if(searchText.isEmpty) {
      setState(() {
        coursesData = mainCourseList;
      });
      return;
    }
    List<dynamic> filteredList = mainCourseList.where((course) {
      String courseName = course['course_name'].toLowerCase();
      return courseName.contains(searchText.toLowerCase());
    }).toList();
    setState(() {
      coursesData = filteredList;
    });
  }



  @override
  void initState() {
    super.initState();
    getData();
  }



  void getData() async{
    List data = await UserRepo.courseData();
    setState(() {
      coursesData = data;
      mainCourseList = data;
      isDataFetched = true;
    });
  }



  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: addPadding/1, right: addPadding/1, top: addPadding/1),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: searchController,
                    onChanged: _handleSearch,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                          color: kTextfieldColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                          color: kPrimaryColor,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                          color: kSecondaryColor,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                          color: kSecondaryColor,
                        ),
                      ),
                      prefixIcon: Icon(Icons.search_rounded, color: kHintText,),
                      hintText: 'Search Courses',
                      hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 16, color: kHintText),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.02,),

              if (!isDataFetched)
          Center(
          child: CircularProgressIndicator(
          color: kTextfieldColor,
        ),
      )
      else if
              (coursesData.length==0)  Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight*.2,
                          child: Lottie.asset('assets/no-data.json')),
                      Text('No Data Found',style: TextStyle(
                          color: kTextfieldColor,fontSize: 22,fontWeight: FontWeight.w600
                      ),),
                    ],
                  ),
                ) else
                  SizedBox(
                  width: screenWidth,
                  height: screenHeight*.7,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                      itemCount:  coursesData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4,),
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                   CourseDetails(coursesData: coursesData[index],)));
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(addPadding/3),
                                child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Image.network(coursesData[index]["course_img"], fit: BoxFit.fill,
                                              height: screenHeight*0.075,
                                              width: screenWidth*0.16,)),
                                        SizedBox(height: screenHeight*0.08,width: screenWidth*0.5,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(coursesData[index]['course_name'],style:  Theme.of(context).textTheme.headline2),
                                              Text(coursesData[index]["course_description"],maxLines: 1,
                                                  style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w400, fontSize: 12, overflow: TextOverflow.ellipsis, color: kMainText)),

                                              Text(coursesData[index]['course_duration'],
                                                style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),),
                                        Icon(Icons.logout)
                                      ],
                                    ),
                                    SizedBox(height: screenHeight*0.01,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );

                      }),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
