import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {
  const Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: const SizedBox(
        height: 65,
        child: TabBar(
          labelColor: Color.fromRGBO(52, 168, 83, 1),
          unselectedLabelColor: Color.fromARGB(153, 0, 0, 0),
          indicatorColor: Color.fromRGBO(52, 168, 83, 1),
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.home_outlined,
                size: 24,
              ),
              child: Text(
                'Home',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.create,
                size: 24,
              ),
              child: Text(
                'Write',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.book_outlined,
                size: 24,
              ),
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
