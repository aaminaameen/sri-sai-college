import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../constants.dart';
import '../../views/auth/services/repo.dart';
import 'news_details.dart';

class CollegeNews extends StatefulWidget {
  const CollegeNews({
    Key? key,
  }) : super(key: key);

  @override
  State<CollegeNews> createState() => _CollegeNewsState();
}

class _CollegeNewsState extends State<CollegeNews> {


  List<dynamic> newsData = [];
  bool isDataFetched = false;


  @override
  void initState() {
    super.initState();
    getData();
  }
  void getData() async{
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
        body: Padding(
          padding: const EdgeInsets.all(addPadding/1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: screenHeight*0.06,
                  child: Text('College News', style: Theme.of(context).textTheme.headline1?.copyWith(color: kHeadingText))),
            if (!isDataFetched)
        Center(
        child: CircularProgressIndicator(
        color: kTextfieldColor,
      ),
    )
    else if



            ( newsData.length==0)  Align(
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
              )else
              SizedBox(
              width: screenWidth,
                height: screenHeight*.8,
                child: ListView.builder(
                    itemCount: newsData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4,),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsDetails(newsData: newsData[index]),));
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
                                          child: Image.network(newsData[index]["news_img"], fit: BoxFit.fill,
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
                                            style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis,color: kMainText),
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
      ),
    );
  }
}
class ScreenArguments {
  List<dynamic> newsData;
  final int index;

  ScreenArguments(this.newsData, this.index);
}