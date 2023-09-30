import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sri_sai_col/constants.dart';
import 'package:sri_sai_col/home/courseScreen.dart';
import '../views/auth/services/repo.dart';
import 'course/course_apply.dart';
import 'navBar.dart';
import 'news/college_news.dart';
import 'news/news_details.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<dynamic> coursesData = [];
  List<dynamic> newsData = [];
  List< dynamic> mainCourseList = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  late String uId;
  String? _name, _title;
  String photoString="";
  late DatabaseReference homeData;
  bool isDataFetched = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
    newData();
    homeData =
        FirebaseDatabase.instance.reference().child('Details');
    uId = FirebaseAuth.instance.currentUser!.uid;
    getAccountValues();
  }


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




  void getData() async{
    List data = await UserRepo.courseData();
    setState(() {
      coursesData = data;
      mainCourseList = data;
      isDataFetched = true;
    });
  }

  void newData() async{
    List data = await NewsRepo.newsData();
    setState(() {
      newsData = data;
      isDataFetched = true;
    });
  }

  @override
  String splitDate(str) {
    String date = str;
    List<String> dateParts = date.split("T");
    String wantedParts = dateParts.removeAt(0).toString();
    return wantedParts;
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
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BottomNav(initialIndex: 3,)));
                      },
                      child: CircleAvatar(
                        maxRadius: 40,
                        backgroundColor: kPrimaryColor,
                        child: photoString.isNotEmpty
                            ? ClipRRect(
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
                        )
                        :Image.asset(
                          'images/clip.png',
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth*0.02,),
                    RichText(
                      text: TextSpan(
                          text:'Hi, ${_name ?? ""}\n',
                          style: Theme.of(context).textTheme.headline2?.copyWith(height: 1.4),
                          children: [
                            TextSpan(
                              text: "${_title ?? ""}",
                              style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ]),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight*0.04,),

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

                SizedBox(height: screenHeight*0.03,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Featured Courses', style: Theme.of(context).textTheme.headline2),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CourseScreen()));
                      },
                        child: Text('See All', style: Theme.of(context).textTheme.caption))
                  ],
                ),
                SizedBox(height: screenHeight*0.02,),
                if (!isDataFetched)
                  Center(
                    child: CircularProgressIndicator(
                      color: kTextfieldColor,
                    ),
                  )
                else if
                ( coursesData.length==0) Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight*.2,
                          child: Lottie.asset('assets/no-data.json')),
                      Text('No Data Found',style: TextStyle(
                          color: kTextfieldColor,fontSize: 16,fontWeight: FontWeight.w600
                      ),),
                    ],
                  ),
                ) else SizedBox(
                  height: screenHeight*0.24,
                  child:ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: coursesData.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only( right: 15),
                      child: SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                          Container(
                          height: screenHeight * 0.18,
                          width: screenWidth * 0.6,
                          child: Stack(
                            children: [
                              SizedBox(width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    coursesData[index]["course_img"],
                                    fit: BoxFit.cover, // change here
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: screenHeight * 0.02,
                                right: screenWidth * 0.05,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => CourseApply(courseName: coursesData[index]['course_name'], id: coursesData[index]['course_id'],)));
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: kWhiteText,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Center(
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: 'Apply',
                                          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                          children: [
                                            TextSpan(
                                              text: ' ' + 'Now',
                                              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                                  color: kHeadingText,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
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

                          Padding(
                             padding: EdgeInsets.only(right: addPadding*5),
                             child: RichText(
                               text: TextSpan(
                                   text: coursesData[index]['course_name']+'\n',
                                   style: Theme.of(context).textTheme.caption,
                                   children: [
                                     TextSpan(
                                       text: coursesData[index]['course_duration'],
                                       style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w500, color: kMainText),

                                     ),
                                   ]),
                             ),
                           ),
                         ],
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.015,),
                SizedBox(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('College News', style: Theme.of(context).textTheme.headline2),
                          InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CollegeNews()));
                              },
                              child: Text('See All',style:  Theme.of(context).textTheme.caption)),
                        ],
                      ),

    if (!isDataFetched)
    Center(
    child: CircularProgressIndicator(
    color: kTextfieldColor,
    ),
    )
    else if
    (newsData.length==0 )  Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            SizedBox(height: screenHeight*.2,
                                child: Lottie.asset('assets/no-data.json')),
                            Text('No Data Found',style: TextStyle(
                                color: kTextfieldColor,fontSize: 16,fontWeight: FontWeight.w600
                            ),),
                          ],
                        ),
                      ) else SizedBox(
                        width: screenWidth,
                        height: screenHeight * .29,
                        child: ListView.builder(
                            itemCount: newsData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 4, bottom: 4),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsDetails(newsData: newsData[index],)));
                                  },
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0),
                                                  child: Image.network(newsData[index]["news_img"], fit: BoxFit.cover,
                                                    height: screenHeight*0.075,
                                                    width: screenWidth*0.16,
                                                  )
                                              ),
                                            ),
                                            SizedBox(height: 50,width: 220,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(newsData[index]['news_title'],style:  Theme.of(context).textTheme.caption),
                                                SizedBox(height: screenHeight*0.005,),
                                                Text(newsData[index]['news_description'],
                                                  maxLines: 2,
                                                  style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis, color: kMainText),
                                                ),
                                              ],
                                            ),)
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10, bottom: 8),
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: RichText(
                                              text: TextSpan(
                                                  text: 'posted on :',
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                  children: [
                                                    TextSpan(
                                                      text: splitDate(newsData[index]["created_at"]),
                                                      style: Theme.of(context).textTheme.bodyText1,

                                                    ),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
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
      values.forEach((key, values) {
        setState(() {
          _name = values["Name"];
          _title = values["Title"];
          photoString = values["image"];
        });
      });
    });
  }
}
