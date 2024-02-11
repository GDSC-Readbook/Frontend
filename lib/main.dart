import 'package:flutter/material.dart';
import 'package:readbook_hr/screens/select.dart';
import 'package:readbook_hr/screens/splash.dart';
import 'package:readbook_hr/screens/start.dart';
import 'package:readbook_hr/story_detail.dart';
import 'package:readbook_hr/widgets/bottom_bar.dart';
// import 'story_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//void main() {
//  runApp(const MyApp());
//}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            DefaultTabController(
              length: 3,
              child: Scaffold(
                body: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    const SelectScreen(),
                    // const StoryListScreen(),
                    Container(
                      child: const Center(
                        child: Text('save2'),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: const Bottom(),
              ),
            );
          }
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  const SelectScreen(),
                  // const StoryListScreen(),
                  Container(
                    child: const Center(
                      child: Text('save1'),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: const Bottom(),
            ),
          );
        },
      ),
      // home: StoryListScreen(),
    );
  }
}
