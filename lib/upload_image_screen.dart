import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
enum ClothingType { pants, shoes, shirt, jacket }
enum Season { winter, summer }
enum Formality { formal, informal }

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _imageFile;
  ClothingType? _clothingType;
  Season? _season;
  Formality? _formality;

  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    print('Image saved at');
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

Future<void> _saveImage() async {
  if (_imageFile == null || _clothingType == null || _season == null || _formality == null) {
    // Handle validation or show error message
    return;
  }

  String appDocPath;
  if (Platform.isAndroid || Platform.isIOS) {
    // For mobile platforms (Android and iOS)
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
  } else {
    // For web platform
    appDocPath = 'assets'; // Replace with your desired directory for web
  }

  print('App Directory Path: $appDocPath');

  // Define directory structure based on user data
  String directoryName = _formality.toString().split('.').last;
  String seasonName = _season.toString().split('.').last;
  String typeName = _clothingType.toString().split('.').last;
  print('Directory Name: $directoryName');
  print('Season Name: $seasonName');
  print('Type Name: $typeName');

  // Construct the path to the assets directory
  String assetsPath = '$appDocPath/assets/$directoryName/$seasonName/$typeName';
  print('Assets Directory Path: $assetsPath');

  // Create directories if they don't exist
  Directory(assetsPath).create(recursive: true);
  print('Created Directories if they do not exist');

  // Save image to the specified path
  String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
  File newImage = await _imageFile!.copy('$assetsPath/$fileName');
  print('Image saved at: ${newImage.path}');

  // Optionally, show success message or navigate to another screen
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Image saved successfully')),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Image')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Take Picture'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Choose from Gallery'),
            ),
            SizedBox(height: 32.0),
            if (_imageFile != null)
              // Platform-specific image handling
              kIsWeb
                  ? Image.network(
                      _imageFile!.path,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      _imageFile!,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
            SizedBox(height: 32.0),
            DropdownButtonFormField<ClothingType>(
              value: _clothingType,
              onChanged: (value) {
                setState(() {
                  _clothingType = value;
                });
              },
              items: ClothingType.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.toString().split('.').last),
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Clothing Type'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<Season>(
              value: _season,
              onChanged: (value) {
                setState(() {
                  _season = value;
                });
              },
              items: Season.values
                  .map((season) => DropdownMenuItem(
                        value: season,
                        child: Text(season.toString().split('.').last),
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Season'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<Formality>(
              value: _formality,
              onChanged: (value) {
                setState(() {
                  _formality = value;
                });
              },
              items: Formality.values
                  .map((formality) => DropdownMenuItem(
                        value: formality,
                        child: Text(formality.toString().split('.').last),
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Formality'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _saveImage,
              child: Text('Save Image'),
            ),
          ],
        ),
      ),
    );
  }
}
