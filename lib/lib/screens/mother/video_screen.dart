import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoScreen extends StatelessWidget {
  final List<Video> videos = [
    Video(
      title: 'How to teach your baby to walk in 7 steps ★ 9-12 months ★ Baby Exercises, Activities & Development',
      thumbnailAsset: 'assets/image/0.jpeg',
      videoUrl: 'https://www.youtube.com/watch?v=hK3br6kpP1g&pp=ygUeaG93IHRvIHRlYWNoIHlvdXIgYmFieSB0byB3YWxr',
    ),
    Video(
      title: 'Best Ways To Teach Your Baby to Talk (Simple, stress-free strategies!)',
      thumbnailAsset: 'assets/image/1.jpeg',
      videoUrl: 'https://www.youtube.com/watch?v=yksO0xiW9DY&pp=ygUfaG93IHRvIHRlYWNoIHlvdXIgYmFieSB0byBzcGVhaw%3D%3D',
    ),
    Video(
      title: 'Tips to Teach Self Feeding to a 7-9 Month Old Baby',
      thumbnailAsset: 'assets/image/2.jpeg',
      videoUrl: 'https://www.youtube.com/watch?v=BKgwzkwKi48&pp=ygUdaG93IHRvIHRlYWNoIHlvdXIgYmFieSB0byBlYXQ%3D',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:const Row(
          children: [
            Icon(Icons.video_library),
            SizedBox(width: 10),
            Text('Videos'),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.pink[50],
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics:const NeverScrollableScrollPhysics(),
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
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
                                  Image.asset(
                                    video.thumbnailAsset,
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
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}

class Video {
  final String title;
  final String thumbnailAsset;
  final String videoUrl;

  Video({
    required this.title,
    required this.thumbnailAsset,
    required this.videoUrl,
  });
}