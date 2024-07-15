import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'upload_image_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clothing Image Uploader',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UploadImageScreen(),
    );
  }
}
