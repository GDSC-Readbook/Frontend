import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:readbook_hr/widgets/book_image_picker.dart';

class AddStoryScreen2 extends StatefulWidget {
  const AddStoryScreen2({super.key});

  @override
  _AddStoryScreenState2 createState() => _AddStoryScreenState2();
}

class _AddStoryScreenState2 extends State<AddStoryScreen2> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  File? _imageFile;
  String _bookName = '';
  String _bookTitle = '';
  String _bookAuthor = '';
  String _bookContent = '';

  void pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String base64Image = '';
      if (_imageFile != null) {
        List<int> imageBytes = await _imageFile!.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }

      final response = await http.post(
        Uri.parse('http://152.69.225.60/book/save'),
        headers: {'Content-Type': 'multipart/form-data'},
        body: jsonEncode({
          'book': {
            'bookName': _bookName,
            'bookTitle': _bookTitle,
            'bookAuthor': _bookAuthor,
            'bookContent': _bookContent,
          },
          'file': base64Image,
        }),
      );

      if (response.statusCode == 200) {
      } else {
        print('Failed to upload!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Story'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                BookImagePicker(
                  onPickImage: (pickedImage) {
                    _imageFile = pickedImage;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Book Name'),
                  onSaved: (value) => _bookName = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the book name.' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Book Title'),
                  onSaved: (value) => _bookTitle = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the book title.' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Book Author'),
                  onSaved: (value) => _bookAuthor = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the book Author.' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Book Content'),
                  onSaved: (value) => _bookContent = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the book Content.' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Make Your Story'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
