import 'package:flutter/material.dart';

import '../../models/app_colors.dart';

class ReadArticles extends StatelessWidget {
  final List<Map<String, dynamic>> articles;

  const ReadArticles({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('The Articles'),
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context); // Navigate back to previous screen
        //   },
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ArticleCard(
            image: 'assets/image/baby.png',
            title: articles[index]['title'],
            description: articles[index]['content'],
            category: articles[index]['category'], 
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: AppColors.primaryColor,
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String category;

  const ArticleCard({super.key, 
    required this.image,
    required this.title,
    required this.description,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding:const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                image,
                height: 200,
                width: 400,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error); // Placeholder icon for error
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Category: $category',
              style:const TextStyle(
                fontSize: 14.0,
                color: AppColors.primaryColor,
              ),
            ),
           const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style:const TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'See More',
              style: TextStyle(
                fontSize: 14.0,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
