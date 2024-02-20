import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:readbook_hr/screens/select.dart';

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

      //final storyData = {
      //  'book': {
      //    'bookName': _bookName,
      //    'bookTitle': _bookTitle,
      //    'bookAuthor': _bookAuthor,
      //    'bookContent': _bookContent,
      //  },
      //};

      final response = await http.post(
        Uri.parse('http://152.69.225.60/book2/save'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'bookName': _bookName,
          'bookTitle': _bookTitle,
          'bookAuthor': _bookAuthor,
          'bookContent': _bookContent,
        }),
      );
      if (response.statusCode == 200) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const SelectScreen(),
          ),
        );
      } else {
        print('failed');
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
