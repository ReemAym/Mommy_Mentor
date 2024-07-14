import 'package:flutter/material.dart';
import '../../component/article_card.dart';
import '../../models/article.dart';
import '../../services/articles_service.dart';

class ArticleListScreen extends StatefulWidget {
  final String image;
  final String category;
  final String? token;

  const ArticleListScreen({super.key, required this.image, required this.category, this.token});

  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  late Future<List<Article>> futureArticles;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  void _loadArticles() {
    futureArticles = ArticleService().getArticlesByCategoryLang(widget.category, _selectedLanguage, widget.token);
  }

  @override
  Widget build(BuildContext context) {
    String languageCode = _selectedLanguage == 'Arabic' ? 'ar' : 'en';

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslatedText('articles', languageCode)),
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedLanguage = newValue;
                  _loadArticles();
                });
              }
            },
            items: <String>['English', 'Arabic']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${getTranslatedText('error', languageCode)}: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(getTranslatedText('no_articles_found', languageCode)));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ArticleCard(article: snapshot.data![index], image: widget.image);
              },
            );
          }
        },
      ),
    );
  }
}

String getTranslatedText(String key, String languageCode) {
  return translations[languageCode]?[key] ?? key;
}

const Map<String, Map<String, String>> translations = {
  'en': {
    'articles': 'Articles',
    'no_articles_found': 'No articles found',
    'error': 'Error',
  },
  'ar': {
    'articles': 'مقالات',
    'no_articles_found': 'لم يتم العثور على مقالات',
    'error': 'خطأ',
  },
};