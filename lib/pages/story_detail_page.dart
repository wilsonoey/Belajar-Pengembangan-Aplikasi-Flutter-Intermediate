import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../api/api_service.dart';

class StoryDetailPage extends StatelessWidget {
  final String storyId;
  final String token;

  StoryDetailPage({required this.storyId, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story Detail'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: ApiService().getStoryDetail(token, storyId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!['error']) {
              return Center(child: Text('Story not found'));
            } else {
              final story = snapshot.data!['story'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(story['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Image.network(story['photoUrl']),
                  SizedBox(height: 8),
                  Text(story['description']),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}