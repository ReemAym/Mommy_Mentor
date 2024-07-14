import 'package:flutter/material.dart';
import '../../component/modifiy_article.dart';
import '../../models/article.dart';
import '../../services/articles_service.dart';

class ArticleModificationScreen extends StatefulWidget {
  final String image;
  final String category;
  final String token; // Add the token here

  const ArticleModificationScreen({
    super.key, 
    required this.image, 
    required this.category,
    required this.token, // Pass the token
  });

  @override
  _ArticleModificationScreenState createState() => _ArticleModificationScreenState();
}

class _ArticleModificationScreenState extends State<ArticleModificationScreen> {
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = ArticleService().getArticlesByCategory(widget.category,widget.token);
  }

  void deleteArticle(String articleId) async {
    try {
      await ArticleService.deleteArticle(articleId);
      setState(() {
        futureArticles = ArticleService().getArticlesByCategory(widget.category,widget.token);
      });
    } catch (e) {
      // Handle deletion error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete article: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Articles"),
      ),
      body: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No articles found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ModifiyArticle(
                  article: snapshot.data![index], 
                  image: widget.image, 
                  onDelete: () => deleteArticle(snapshot.data![index].id),
                );
              },
            );
          }
        },
      ),
    );
  }
}
