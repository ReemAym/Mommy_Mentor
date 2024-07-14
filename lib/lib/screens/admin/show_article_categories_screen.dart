import 'package:flutter/material.dart';
import 'article_modification_screen.dart';

import '../../component/grid_item.dart';
import '../../models/app_colors.dart';

class ShowArticleCategories extends StatelessWidget {
  final String token;
  const ShowArticleCategories({super.key,required this.token});

  @override
  Widget build(BuildContext context) {
    String token=this.token;
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          "Articles Categories",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme:const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 32.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            GridItem(
                context,
                Icons.article,
                'General',
                ArticleModificationScreen(
                  image: 'assets/image/General.webp',
                  category: "General",
                  token: token,
                )),
            GridItem(
                context,
                Icons.restaurant_menu,
                'Nutrition',
                ArticleModificationScreen(
                  image: 'assets/image/Nutrition.jpg',
                  category: "Nutrition",
                                    token: token,

                )),
            GridItem(
                context,
                Icons.child_friendly,
                'BreastFeeding',
                ArticleModificationScreen(
                  image: 'assets/image/BreastFeeding.jpg',
                  category: "BreastFeeding",
                                    token: token,

                )),
            GridItem(
                context,
                Icons.healing,
                'Diseases',
                ArticleModificationScreen(
                  image: 'assets/image/Diseases.jpg',
                  category: "Diseases",
                                    token: token,

                )),
            GridItem(
                context,
                Icons.sentiment_very_dissatisfied,
                'Abnormal Babies',
                ArticleModificationScreen(
                  image: 'assets/image/Abnormal Babies.jpg',
                  category: "Abnormal Babies",
                                    token: token,

                )),
          ],
        ),
      ),
    );
  }
}
