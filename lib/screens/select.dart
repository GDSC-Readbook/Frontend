import 'dart:convert';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:readbook_hr/screens/add_story.dart';
import 'package:readbook_hr/screens/profile.dart';
import 'package:readbook_hr/story.dart';
import 'package:http/http.dart' as http;
import 'package:readbook_hr/story_detail.dart';
import 'package:readbook_hr/widgets/drawer.dart';

import 'package:readbook_hr/widgets/navbar.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  late Future<List<Story>> futureStories;

  @override
  void initState() {
    super.initState();
    futureStories = fetchStories();
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'add') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const AddStoryScreen(),
        ),
      );
    }
  }

  Future<List<Story>> fetchStories() async {
    try {
      final response = await http.get(
        Uri.parse('http://152.69.225.60/book/findAll'),
        headers: {'Accept-Charset': 'utf-8'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<Story> stories = [];
        for (var data in responseData) {
          final int id = data['id'];
          final String name = data['bookName'] ?? 'Unknown Name';
          final String title = data['bookTitle'] ?? 'Unknown Title';
          final String content = data['bookContent'] ?? '';
          final String image = data['bookImage'];
          stories.add(Story(
              id: id,
              name: name,
              title: title,
              content: content,
              image: image));
        }
        return stories;
      } else {
        throw Exception('Failed to load stories');
      }
    } catch (e) {
      throw Exception('Failed to fetch stories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Readbook'),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextTheme(
          titleLarge: TextStyle(
            color: Color.fromRGBO(52, 168, 83, 1),
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ).titleLarge,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color.fromARGB(66, 190, 190, 190),
            height: 1.0,
          ),
        ),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20),
              child: Text(
                'Readbook이 제공하는 이야기',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                '저작권이 지난 동화들을 Readbook이 들려줄거예요',
                style: TextStyle(
                    fontSize: 13, color: Color.fromRGBO(131, 133, 137, 1)),
              ),
            ),
            FutureBuilder<List<Story>>(
              future: futureStories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  const int halfLength = 7; // 데이터의 반을 계산
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 300, // ListView의 고정 높이
                        child: makeList(snapshot, 0, halfLength),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20),
              child: Text(
                'Readbook과 만드는 이야기',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Readbook과 함께 나만의 이야기를 만들어봐요',
                style: TextStyle(
                    fontSize: 13, color: Color.fromRGBO(131, 133, 137, 1)),
              ),
            ),
            FutureBuilder<List<Story>>(
              future: futureStories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  const int halfLength = 7;
                  return halfLength == 7
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Container(
                                    padding: const EdgeInsets.only(top: 105),
                                    width: 182,
                                    height: 225,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.green,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 15,
                                          offset: const Offset(10, 10),
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'No Stories Yet',
                                      textAlign: TextAlign.center,
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                            )
                          ],
                        )
                      : Column(
                          children: [
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 350, // ListView의 고정 높이
                              child: makeList(
                                  snapshot, halfLength, snapshot.data!.length),
                            ),
                          ],
                        );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 0,
        onItemSelected: (index) {
          if (index == 0) {
            // 홈 탭 선택 시, 현재 화면유지
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const SelectScreen()));
          } else if (index == 1) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AddStoryScreen()));
          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const MyProfileScreen()));
          }
        },
      ),
    );
  }
}

ListView makeList(AsyncSnapshot<List<Story>> snapshot, int start, int end) {
  final int correctedEnd = min(end, snapshot.data!.length);
  return ListView.separated(
    shrinkWrap: true, // if you want to constrain the height of the ListView
    physics:
        const ClampingScrollPhysics(), // to prevent scrolling if wrapped in a SingleChildScrollView
    scrollDirection: Axis.horizontal,
    itemCount: correctedEnd - start,
    padding: const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 20,
    ),
    itemBuilder: (context, index) {
      var story = snapshot.data![start + index];
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoryDetailScreen(
                story: story,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Container(
                width: 182,
                height: 225,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.green,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      offset: const Offset(10, 10),
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                child: Image.network(
                  'http://152.69.225.60/book/image/${story.image}',
                  errorBuilder: (context, url, error) =>
                      const Icon(Icons.error),
                ) // 이 부분에서 백엔드에서 제공하는 .png 이미지를 표시
                ),
            const SizedBox(
              height: 10,
            ),
            Text(
              story.name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    },
    separatorBuilder: (context, index) => const SizedBox(
      width: 40,
    ),
  );
}
