import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  List<dynamic> _stories = [];
  late SharedPreferences prefs;
  late String token;
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initialize();
    _scrollController.addListener(_scrollListener);
  }

  void _initialize() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    _fetchStories();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
      _fetchStories();
    }
  }

  void _fetchStories() async {
    setState(() {
      _isLoading = true;
    });
    final response = await _apiService.getAllStories(token, page: _page);
    if (!response['error']) {
      setState(() {
        _stories.addAll(response['listStory']);
        _page++;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stories'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              context.go('/addStory');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              context.go('/login');
            },
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          final story = _stories[index];
          return ListTile(
            title: Text(story['name']),
            subtitle: Text(story['description']),
            leading: Image.network(story['photoUrl']),
            onTap: () {
              context.go('/storyDetail/${story['id']}', extra: token);
            },
          );
        },
      ),
    );
  }
}