import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/articles_service.dart';

class UploadArticleProvider with ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? selectedCategory;
  String? title;
  String? content;
  List<String> categories = ['General', 'Nutrition', 'BreastFeeding', 'Diseases', 'Abnormal Babies'];

  final _storage = const FlutterSecureStorage();

  Future<void> publishArticle(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      try {
        String? token = await _storage.read(key: 'jwtToken'); // Retrieve the token from secure storage

        if (token == null) {
          throw Exception('No token found');
        }

        final response = await ArticleService.uploadArticle(
          title: title!,
          category: selectedCategory!,
          content: content!,
          token: token,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article published successfully')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to publish article: $error')),
        );
      }
    }
  }
}
