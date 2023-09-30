import 'package:flutter/material.dart';
import 'package:sri_sai_col/constants.dart';

import 'college_news.dart';

class NewsDetails extends StatefulWidget {

   NewsDetails({required this.newsData,});
  final Map newsData;

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {

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
          child: Column( crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight*0.25,
                width: double.infinity,
                child: Stack(
                  children: [
                    SizedBox( width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(widget.newsData["news_img"], fit: BoxFit.fill,
                          height: screenHeight*0.3,)),
                    ),
                    Positioned(
                      top: screenHeight*0.02,
                      left: screenWidth*0.05,
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: kTextGreyColor.withOpacity(0.3),
                            child: Icon(Icons.arrow_back_ios_new, color: kPrimaryColor,)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: screenHeight*0.03,),
              Text(
                  widget.newsData['news_title'],
                  style: Theme.of(context).textTheme.headline1?.copyWith(color: kHeadingText)),
              SizedBox(height: screenHeight*0.015,),
              Align(
                alignment: Alignment.bottomLeft,
                child: RichText(
                  text: TextSpan(
                      text: 'posted on :',
                      style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 16,fontWeight: FontWeight.w400,),
                      children: [
                        TextSpan(
                          text: splitDate(widget.newsData['created_at']),
                          style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 16,fontWeight: FontWeight.w400,),

                        ),
                      ]),
                ),
              ),
              SizedBox(height: screenHeight*0.03,),
              Text(widget.newsData['news_description'],
                style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w400, fontSize: 18, color: kMainText)),
            Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
