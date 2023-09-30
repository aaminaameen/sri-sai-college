import 'dart:convert';
import 'package:http/http.dart' as http;



const String coursePoint = "https://srisai.besocial.pro/api/v1/getCoures";

const String newsPoint = "https://srisai.besocial.pro/api/v1/getNews";

const String galleryPoint = "https://srisai.besocial.pro/api/v1/getPortfolio";


List<dynamic> courses = [];

class UserRepo{
  static Future<List> courseData() async {
    final response = await http.get(Uri.parse(coursePoint));
    if (response.statusCode == 200) {
        List courses = jsonDecode(response.body)['data'];
      return courses;
    } else {
      throw Exception('Failed to load data');
    }
  }
}


List<dynamic> news = [];


class NewsRepo{
  static Future<List> newsData() async {
    final response = await http.get(Uri.parse(newsPoint));
    if (response.statusCode == 200) {
      List news = jsonDecode(response.body)['data'];
      return news;
    } else {
      throw Exception('Failed to load data');
    }
  }
}


List<dynamic> gallery = [];


class GalleryRepo{
  static Future<List> galleryData() async {
    final response = await http.get(Uri.parse(galleryPoint));
    if (response.statusCode == 200) {
      List gallery = jsonDecode(response.body)['data'];
      return gallery;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
