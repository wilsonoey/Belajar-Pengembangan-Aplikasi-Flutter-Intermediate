import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../api/api_service.dart';

class TambahCeritaPage extends StatefulWidget {
  @override
  _TambahCeritaPageState createState() => _TambahCeritaPageState();
}

class _TambahCeritaPageState extends State<TambahCeritaPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final ApiService _apiService = ApiService();
  late SharedPreferences prefs;
  late String token;
  XFile? _selectedPhoto;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: source);
    setState(() {
      _selectedPhoto = photo;
    });
  }

  void _addStory() async {
    if (_selectedPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a photo')));
      return;
    }
    final response = await _apiService.addStory(token, _descriptionController.text, _selectedPhoto!.path);
    if (!response['error']) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Failed to add story')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Cerita'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: Text('Take Photo'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: Text('Select Gallery'),
                ),
              ],
            ),
            if (_selectedPhoto != null) Image.file(File(_selectedPhoto!.path)),
            ElevatedButton(onPressed: _addStory, child: Text('Add Story')),
          ],
        ),
      ),
    );
  }
}