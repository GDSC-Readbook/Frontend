import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons
              .create), // Icon for story writing, can be changed according to design preferences
          label: 'Write', // Label for the story creation tab
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_outlined),
          label: 'Profile',
        ),
        // 추가 탭 아이템들
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      onTap: widget.onItemSelected,
    );
  }
}
