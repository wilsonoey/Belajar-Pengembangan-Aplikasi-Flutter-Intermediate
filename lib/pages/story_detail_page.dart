import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../api/api_service.dart';
import '../models/story.dart';
import 'package:geocoding/geocoding.dart' as geo;

class StoryDetailPage extends StatefulWidget {
  final String storyId;
  final String token;

  StoryDetailPage({required this.storyId, required this.token});

  @override
  _StoryDetailPageState createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;
  late Future<Story> _storyFuture;

  @override
  void initState() {
    super.initState();
    _storyFuture = ApiService().getStoryDetail(widget.token, widget.storyId);
  }

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
        child: FutureBuilder<Story>(
          future: _storyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('Story not found'));
            } else {
              final story = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(story.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Image.network(story.photoUrl),
                  SizedBox(height: 8),
                  Text(story.description),
                  if (story.lat != null && story.lon != null) ...[
                    SizedBox(height: 8),
                    SizedBox(
                      height: 300,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(story.lat!, story.lon!),
                          zoom: 14,
                        ),
                        markers: markers,
                        onMapCreated: (controller) async {
                          final info = await geo.placemarkFromCoordinates(
                              story.lat!, story.lon!);

                          final place = info[0];
                          final street = place.street!;
                          final address =
                              '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

                          setState(() {
                            markers.add(Marker(
                              markerId: MarkerId('1'),
                              position: LatLng(story.lat!, story.lon!),
                              infoWindow: InfoWindow(
                                title: street,
                                snippet: address,
                              ),
                            ));
                          });
                        },
                      ),
                    ),
                  ],
                ],
              );
            }
          },
        ),
      ),
    );
  }
}