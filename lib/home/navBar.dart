import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sri_sai_col/constants.dart';
import 'package:sri_sai_col/home/courseScreen.dart';
import 'package:sri_sai_col/home/gallery.dart';
import 'package:sri_sai_col/home/homeScreen.dart';
import 'package:sri_sai_col/home/profileScreen.dart';



class BottomNav extends StatefulWidget {
  final int initialIndex;

  const BottomNav({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: height,
                  width: width,
                  child: _selectedIndex == 0
              ? HomeScreen()
               : _selectedIndex == 1
              ? CourseScreen()
              : _selectedIndex == 2
            ? GalleryScreen()
            : ProfileScreen(),
     ),

                Padding(
                  padding:EdgeInsets.only(bottom: height*.07),
                  child: Container(
                    width: width*.853,
                    height: height*.0785,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.only(left: width*.031, right: width*.031),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap:(){
                                setState(() {
                                  _selectedIndex = 0;
                                });
                              },
                              child:  _selectedIndex == 0 ? Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.home, color: kPrimaryColor,size: 27,),
                                  ],
                                ),
                              )
                                  :Icon(Icons.home_outlined,
                                color: kPrimaryColor,
                              ),
                            ),
                            GestureDetector(
                              onTap:(){
                                setState(() {
                                  _selectedIndex = 1;
                                });
                              },
                              child: _selectedIndex == 1 ? Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.school, color: kPrimaryColor,size: 27,),
                                  ],
                                ),
                              )
                                  :Icon(
                                Icons.school_outlined, color: kPrimaryColor,
                              ),
                            ),
                            GestureDetector(
                              onTap:(){
                                setState(() {
                                  _selectedIndex = 2;
                                });
                              },
                              child: _selectedIndex == 2 ? Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.my_library_add, color: kPrimaryColor,),
                                    ],
                                ),
                              )
                                  :Icon(
                                Icons.my_library_add_outlined, color: kPrimaryColor,
                              ),
                            ),
                            GestureDetector(
                              onTap:(){
                                setState(() {
                                  _selectedIndex = 3;
                                });
                              },
                              child: _selectedIndex == 3 ? Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person, color: kPrimaryColor,),
                                  ],
                                ),
                              )
                                  :Icon(Icons.person_outline, color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}


