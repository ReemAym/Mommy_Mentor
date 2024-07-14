import 'package:flutter/material.dart';
import '../admin/show_users_screen.dart';
import '../admin/vaccine_modification.dart';

import '../../component/grid_item.dart';
import '../../models/app_colors.dart';
import 'advice_modification.dart';
import 'show_article_categories_screen.dart';

class AdminHomeScreen extends StatefulWidget {

  final String token = 'admintoken55';
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: AppColors.primaryColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: Column(
                children: [
                  Icon(Icons.admin_panel_settings_rounded,
                      size: 100, color: AppColors.primaryColor),
                  SizedBox(height: 8),
                  Text('Welcome', style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  GridItem(context, Icons.article, 'Articles',
                      ShowArticleCategories(token:widget.token)),
                  GridItem(context, Icons.group, 'Users', ShowUsersScreen()),
                  GridItem(
                      context, Icons.note_add, 'Avices', const AdviceModification()),
                  GridItem(context, Icons.vaccines, 'Vaccine',
                     const VaccineModification()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
