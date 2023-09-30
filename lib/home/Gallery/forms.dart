import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:sri_sai_col/constants.dart';

class Forms extends StatefulWidget {
  @override
  _FormsState createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  List<dynamic> portfolioData = [];
  bool isDataFetched = false; // Added

  Future<void> _fetchPortfolioData() async {
    final response = await http.get(Uri.parse('https://srisai.besocial.pro/api/v1/getPortfolio'));
    final decodedResponse = jsonDecode(response.body);
    setState(() {
      portfolioData = decodedResponse['data'];
      isDataFetched = true; // Set to true when data is fetched
    });
  }

  List<dynamic> _getPortfolioFilesByCategory(String category) {
    return portfolioData.where((data) => data['portfolio_category'] == category).toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchPortfolioData();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(addPadding / 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: screenHeight * 0.07,
                  child: Text('Application Forms', style: Theme.of(context).textTheme.headline1?.copyWith(color: kHeadingText))),
              if (!isDataFetched)
                Center(
                  child: CircularProgressIndicator(
                    color: kTextfieldColor,
                  ),
                )
              else if (_getPortfolioFilesByCategory('Forms').isEmpty)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.2, child: Lottie.asset('assets/image.json')),
                      Text(
                        'No Image Found',
                        style: TextStyle(color: kTextfieldColor, fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  width: screenWidth,
                  height: screenHeight * 0.83,
                  child: ListView.builder(
                    itemCount: _getPortfolioFilesByCategory('Forms').length,
                    itemBuilder: (context, index) {
                      final portfolioFile = _getPortfolioFilesByCategory('Forms')[index];
                      return Card(
                          elevation: 1,
                          child: SizedBox(
                              height: screenHeight * 0.25,
                              width: screenWidth,
                              child: Image.network(portfolioFile['portfolio_file'], fit: BoxFit.fill)));
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
