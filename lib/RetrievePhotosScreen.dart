import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class RetrievePhotosScreen extends StatefulWidget {
  @override
  _RetrievePhotosScreenState createState() => _RetrievePhotosScreenState();
}

class _RetrievePhotosScreenState extends State<RetrievePhotosScreen> {
  List<File> _imageFiles = [];

  @override
  void initState() {
    super.initState();
    _retrieveImages();
  }

  Future<void> _retrieveImages() async {
    try {
      Directory appDir = await getApplicationDocumentsDirectory();
      String assetsPath = '${appDir.path}/assets'; // Adjust path as per your saving logic

      List<FileSystemEntity> files = Directory(assetsPath).listSync(recursive: true);

      List<File> images = files.whereType<File>().toList();
      setState(() {
        _imageFiles = images;
      });
    } catch (e) {
      print('Error retrieving images: $e');
      // Handle error gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retrieved Photos'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
        itemCount: _imageFiles.length,
        itemBuilder: (context, index) {
          return Image.file(_imageFiles[index]);
        },
      ),
    );
  }
}