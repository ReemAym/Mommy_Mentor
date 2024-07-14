import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/article.dart';

class ArticleService {
  static const String _baseUrl = Constant.serverAddress;

  static Future<Map<String, dynamic>> uploadArticle({
    required String title,
    required String category,
    required String content,
    required String token, // Pass the token
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/article/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add the token to the header
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'category': category,
        'content': content,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to upload article');
    }
  }

  Future<List<Article>> getArticlesByCategory(String category,String token) async {
    print(token);
    final response =
        await http.get(Uri.parse('$_baseUrl/article/category/$category'),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add the token to the header
      },);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((article) => Article.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<List<Article>> getArticlesByCategoryLang(
      String category, String language,String? token) async {
        print(token);
    String endpoint = language == 'Arabic' ? 'arabic' : 'english';
    print(language);
    final response =
        await http.get(Uri.parse('$_baseUrl/article/$endpoint?category=$category'),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add the token to the header
      },
        
        );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((article) => Article.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<List<Article>> getArticles() async {
    final response = await http.get(Uri.parse('$_baseUrl/article'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((article) => Article.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }



  static Future<void> deleteArticle(String articleId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/article/$articleId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print('Article deleted successfully');
    } else {
      print('Failed to delete article: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to delete article');
    }
  }
}
