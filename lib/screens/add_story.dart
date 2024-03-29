import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:readbook_hr/screens/profile.dart';
import 'dart:convert';
import 'dart:io';
//import 'package:image_picker/image_picker.dart';

import 'package:readbook_hr/screens/select.dart';
import 'package:readbook_hr/widgets/bottom.dart';
import 'package:readbook_hr/widgets/navbar.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  _AddStoryScreenState createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _formKey = GlobalKey<FormState>();

  String _bookName = '';
  String _bookTitle = '';
  String _bookAuthor = '';
  String _bookContent = '';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final Map<String, dynamic> storyData = {
        'book': {
          'bookName': _bookName,
          'bookTitle': _bookTitle,
          'bookAuthor': _bookAuthor,
          'bookImage': '',
          'bookContent': _bookContent,
        },
      };

      final response = await http.post(
        Uri.parse('http://152.69.225.60/book2/save'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(storyData),
      );
      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => const DefaultTabController(
            length: 3,
            child: Scaffold(
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  SelectScreen(),
                  AddStoryScreen(),
                  MyProfileScreen()
                ],
              ),
              // bottomNavigationBar: CustomBottomNavigationBar(),
            ),
          ),
        ));
      } else {
        print('failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Add Story'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
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
                  child: const Text('Add Story'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1, // Assuming index 1 is for AddStoryScreen
        onItemSelected: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SelectScreen()),
            );
          } else if (index == 1) {
            // Current screen, no action needed.
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MyProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
