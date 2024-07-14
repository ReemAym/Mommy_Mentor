import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/video.dart';

class VideoCard extends StatelessWidget {
  final Video video;

  const VideoCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin:const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _launchURL(video.videoUrl),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                    image: AssetImage(video.thumbnailAsset),
                    width: 300,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Icon(
                    Icons.play_circle_outline,
                    size: 64,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              video.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(Uri.encodeFull(url)); // Encode the URL
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}
