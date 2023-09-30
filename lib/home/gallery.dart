import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Gallery/certificates.dart';
import 'Gallery/college_photos.dart';
import 'Gallery/forms.dart';


class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {

   List<dynamic> galleryData = [];
   bool isDataFetched = false;


   Future fetchData() async {
     final response = await http.get(Uri.parse('https://srisai.besocial.pro/api/v1/getPortfolio'));
     if (response.statusCode == 200) {
       setState(() {
         galleryData = json.decode(response.body)['data'];
         isDataFetched = true;
       });
     } else {
       throw Exception('Failed to load data');
     }
   }

   @override
   void initState() {
     super.initState();
     fetchData();
   }

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    List<dynamic> certificates = galleryData.where((data) => data['portfolio_category'] == 'Certificates').toList();
    List<dynamic> forms = galleryData.where((data) => data['portfolio_category'] == 'Forms').toList();
    List<dynamic> collegePhotos = galleryData.where((data) => data['portfolio_category'] == 'College photos').toList();

    return SafeArea(
       child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(addPadding/1),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                 height: screenHeight*0.07,
                  child: Text('Gallery', style: Theme.of(context).textTheme.headline1?.copyWith(color: kHeadingText))),

            SingleChildScrollView(
                 child: SizedBox(
                 width: screenWidth,
                 height: screenHeight*.25,
                 child:  Card(
                   elevation: 3,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                   child: Column(
                       children: [
                       if (!isDataFetched)
                   Column(
                     children: [
                       SizedBox(height: screenHeight*0.05,),
                       CircularProgressIndicator(
                       color: kTextfieldColor,
                 ),
                     ],
                   )
              else if(certificates.length==0)
                         Column(
                           children: [
                             SizedBox(height: screenHeight*.03,),
                             SizedBox(
                                 height: screenHeight*.1,
                                 child: Lottie.asset('assets/image.json')),
                             Text('No Image Found',style: TextStyle(
                                 color: kTextfieldColor,fontSize: 16,fontWeight: FontWeight.w600
                             ),),
                             SizedBox(height: screenHeight*0.03,)
                           ],
                         ) else   Row(
                             children: [
                               ClipRRect(
                                   borderRadius: BorderRadius.only(
                                     topLeft: Radius.circular(15.0),
                                    ),
                                   child:Image.network(
                                     certificates.length > 2 ? certificates[2]['portfolio_file'] : certificates[0]['portfolio_file'],
                                     fit: BoxFit.fill,
                                     height: screenHeight*0.18,
                                     width: screenWidth/2.35,
                                   )),
                               Column(
                                   children: [
                                     ClipRRect(
                                       borderRadius: BorderRadius.only(
                                         topRight: Radius.circular(15.0),
                                       ),
                                       child: Image.network(
                                         certificates.length > 1 ? certificates[1]['portfolio_file'] : certificates[0]['portfolio_file'],
                                         fit: BoxFit.fill,
                                         height: screenHeight * 0.09,
                                         width: screenWidth / 2.3,
                                       ),
                                     ),
                                     ClipRRect(
                                       child: Image.network(
                                         certificates[0]['portfolio_file'],
                                         fit: BoxFit.fill,
                                         height: screenHeight * 0.09,
                                         width: screenWidth / 2.3,
                                       ),
                                      ),
                                    ])
                             ]),
                         SizedBox(
                           height: screenHeight*0.05,
                           width: screenWidth*0.8,
                           child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text('Certificates',style: Theme.of(context).textTheme.headline1?.copyWith(color: kHeadingText, fontSize: 20) ),
                                 InkWell(
                                     onTap: (){
                                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => Certificates()));
                                     },
                                     child: Icon(Icons.add_box, color: kPrimaryColor, size: 25,))
                               ]),
                         )
                       ]),
                   )
              ),
               ),

              SizedBox(
                  width: screenWidth,
                  height: screenHeight*.25,
                  child:  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Column(
                        children: [
                          if (!isDataFetched)
                            Column(
                              children: [
                                SizedBox(height: screenHeight*0.05,),
                                CircularProgressIndicator(
                                  color: kTextfieldColor,
                                ),
                              ],
                            )
                          else if(forms.length==0)
                            Column(
                              children: [
                                SizedBox(height: screenHeight*.03,),
                                SizedBox(
                                    height: screenHeight*.1,
                                    child: Lottie.asset('assets/image.json')),
                                Text('No Image Found',style: TextStyle(
                                    color: kTextfieldColor,fontSize: 16,fontWeight: FontWeight.w600
                                ),),
                                SizedBox(height: screenHeight*0.03,)
                              ],
                            ) else
                              Row(
                                children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                        ),
                                        child:Image.network(
                                          forms.length > 2 ? forms[2]['portfolio_file'] : forms[0]['portfolio_file'],
                                          fit: BoxFit.fill,
                                          height: screenHeight*0.18,
                                          width: screenWidth/2.35,
                                        )),
                                  Column(
                                      children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(15.0),
                                            ),
                                            child: Image.network(
                                              forms.length > 1 ? forms[1]['portfolio_file'] : forms[0]['portfolio_file'],
                                              fit: BoxFit.fill,
                                              height: screenHeight * 0.09,
                                              width: screenWidth / 2.3,
                                            ),
                                          ),
                                        ClipRRect(
                                          child: Image.network(
                                            forms[0]['portfolio_file'],
                                            fit: BoxFit.fill,
                                            height: screenHeight * 0.09,
                                            width: screenWidth / 2.3,
                                          ),
                                        ),
                                      ])
                                ]),
                          SizedBox(
                            height: screenHeight*0.05,
                            width: screenWidth*0.8,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Application Forms',style: Theme.of(context).textTheme.headline1?.copyWith(color: kHeadingText, fontSize: 20) ),
                                  InkWell(
                                      onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Forms()));
                                      },
                                      child: Icon(Icons.add_box, color: kPrimaryColor, size: 25,))
                                ]),
                          )
                        ]),
                  )
              ),

              SizedBox(
                  width: screenWidth,
                  height: screenHeight*.25,
                  child:  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Column(
                        children: [
                          if (!isDataFetched)
                            Column(
                              children: [
                                SizedBox(height: screenHeight*0.05,),
                                CircularProgressIndicator(
                                  color: kTextfieldColor,
                                ),
                              ],
                            )
                          else if(collegePhotos.length==0)
                            Column(
                              children: [
                                SizedBox(height: screenHeight*.03,),
                                SizedBox(
                                    height: screenHeight*.1,
                                    child: Lottie.asset('assets/image.json')),
                                Text('No Image Found',style: TextStyle(
                                    color: kTextfieldColor,fontSize: 16,fontWeight: FontWeight.w600
                                ),),
                                SizedBox(height: screenHeight*0.03,)
                              ],
                            ) else
                              Row(
                                children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                        ),
                                        child:Image.network(
                                          collegePhotos.length > 2 ? collegePhotos[2]['portfolio_file'] : collegePhotos[0]['portfolio_file'],
                                          fit: BoxFit.fill,
                                          height: screenHeight*0.18,
                                          width: screenWidth/2.35,
                                        )),
                                  Column(
                                      children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(15.0),
                                            ),
                                            child: Image.network(
                                              collegePhotos.length > 1 ? collegePhotos[1]['portfolio_file'] : collegePhotos[0]['portfolio_file'],
                                              fit: BoxFit.fill,
                                              height: screenHeight * 0.09,
                                              width: screenWidth / 2.3,
                                            ),
                                          ),
                                        ClipRRect(
                                          child: Image.network(
                                            collegePhotos[0]['portfolio_file'],
                                            fit: BoxFit.fill,
                                            height: screenHeight * 0.09,
                                            width: screenWidth / 2.3,
                                          ),
                                        ),
                                      ])
                                ]),
                          SizedBox(
                            height: screenHeight*0.05,
                            width: screenWidth*0.8,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('College Photos',style: Theme.of(context).textTheme.headline1?.copyWith(color: kHeadingText, fontSize: 20) ),
                                  InkWell(
                                      onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CollegePhotos()));
                                      },
                                      child: Icon(Icons.add_box, color: kPrimaryColor, size: 25,))
                                ]),
                          )
                        ]),
                  )
              ),

            ]),
        ),
       ),
     );
   }
 }
