import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../component/button.dart';
import '../../models/app_colors.dart';
import '../../providers/upload_article_provider.dart';

class UploadArticle extends StatelessWidget {
  const UploadArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UploadArticleProvider(),
      child: Scaffold(
        appBar: AppBar(
          title:const  Text('Publish Medical Article'),
        ),
        body: const Padding(
          padding:  EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ArticleForm(),
          ),
        ),
        
      ),
    );
  }
}

class ArticleForm extends StatelessWidget {
  const ArticleForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UploadArticleProvider>(context);
    

    return Form(
      key: provider.formKey,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CategoryDropdown(),
          SizedBox(height: 16),
          TitleTextField(),
          SizedBox(height: 16),
          ContentTextField(),
          SizedBox(height: 32),
          Center(
            child: PublishButton(),
          ),
        ],
      ),
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UploadArticleProvider>(context);

    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: 16), // Add margin on left and right
      child: DropdownButtonFormField<String>(
        value: provider.selectedCategory,
        items: provider.categories.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (value) => provider.selectedCategory = value,
        onSaved: (value) => provider.selectedCategory = value,
        decoration: InputDecoration(
          labelText: 'Category',
          labelStyle: const TextStyle(color: AppColors.primaryColor),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        validator: (value) {
          if (value == null) {
            return 'Please select a category';
          }
          return null;
        },
      ),
    );
  }
}

class TitleTextField extends StatelessWidget {
  const TitleTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UploadArticleProvider>(context);

    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: 16), // Add margin on left and right

      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Title',
          labelStyle: const TextStyle(color: AppColors.primaryColor),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
         
            enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        validator: (val) => val!.isEmpty ? 'Enter a title' : null,
        onChanged: (val) => provider.title = val,
        onSaved: (val) => provider.title = val,
      ),
    );
  }
}

class ContentTextField extends StatelessWidget {
  const ContentTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UploadArticleProvider>(context);


    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: 16), // Add margin on left and right

      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Content',
          labelStyle: const TextStyle(color: AppColors.primaryColor),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
            
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
         
            enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        maxLines: null,
        keyboardType: TextInputType.multiline,
        validator: (val) => val!.isEmpty ? 'Enter content' : null,
        onChanged: (val) => provider.content = val,
        onSaved: (val) => provider.content = val,
      ),
    );
  }
}

class PublishButton extends StatelessWidget {
  const PublishButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UploadArticleProvider>(context);

    return Button(
      text: 'Publish',
      background_color: AppColors.primaryColor,
      text_color: Colors.white,
      onTap: () => provider.publishArticle(context),
    );
  }
}

