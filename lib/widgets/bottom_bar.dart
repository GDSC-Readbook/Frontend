import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {
  const Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const SizedBox(
        height: 60,
        child: TabBar(
          labelColor: Color.fromRGBO(52, 168, 83, 1),
          unselectedLabelColor: Color.fromRGBO(32, 14, 50, 1),
          indicatorColor: Colors.transparent,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.home_outlined,
                size: 20,
              ),
              child: Text(
                'Home',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.headphones_outlined,
                size: 18,
              ),
              child: Text(
                'Playing',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.book_outlined,
                size: 18,
              ),
              child: Text(
                'My Profile',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
