import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  //문자열 식별자를 추가한 이유? 탭 시작에서 함수를 정의할 수 있도록 하기 위함.
  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(52, 168, 83, 0.5),
            ),
            child: Row(children: [
              const Icon(
                Icons.book,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(
                width: 18,
              ),
              Text(
                "Blah Blah",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
              )
            ]),
          ),
          //리스트 콘텐츠 출력에 유용. 여러 정보를 묶는 데 최적화.
          ListTile(
            //행 시작 부분에 나타날 위젯 설정. title은 leading 뒤에 온다.
            leading: Icon(
              Icons.add_box_outlined,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Add Story',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              onSelectScreen('add');
            },
          ),
          ListTile(
            //행 시작 부분에 나타날 위젯 설정. title은 leading 뒤에 온다.
            leading: Icon(
              Icons.settings,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Edit Profile',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              onSelectScreen('profile');
            },
          ),
        ],
      ),
    );
  }
}
