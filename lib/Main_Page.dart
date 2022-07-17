import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qtube/Browser_page.dart';
import 'package:qtube/paste_link.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  int index = 0;
  List<Widget> widgets = [
    const PasteLink(),
    const BrowsePage(),
  ];

  List<Widget> bodyPages() {
    return <Widget>[
      const PasteLink(),
      const BrowsePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          setState(
            () {
              index = value;
            },
          );
        },
        // ignore: prefer_const_literals_to_create_immutables, duplicate_ignore
        items: [
          // ignore: prefer_const_constructors
          BottomNavigationBarItem(
            icon: const Icon(Icons.paste),
            label: 'Paste Link',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.cell_tower),
            label: 'Browse',
          )
        ],
      ),
      body: bodyPages()[index],
    );
  }
}
