import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/covid_provider.dart';
import './home_screen.dart';
import './info_screen.dart';
import './profile_screen.dart';

class TabsScreen extends StatefulWidget {
  static String routeName = 'tabs_screen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  String _selectedLanguage;

  List<BottomNavigationBarItem> items = List<BottomNavigationBarItem>();
  final List<Map<String, Object>> _pages = [
    {
      'page': HomeScreen(),
      'title': 'Home',
      'showAppBar': false,
    },
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  bool isInit = true;
  @override
  void didChangeDependencies() async {
    
    if (isInit) {
      await Provider.of<CovidProvider>(context, listen: false).getLanguage();
    setState(() {
      _selectedLanguage =
          Provider.of<CovidProvider>(context, listen: false).language;
    });
      isInit = false;
      /* items.add(
        BottomNavigationBarItem(
          backgroundColor: Colors.purpleAccent,
          icon: Icon(Icons.home),
          title: Text(_selectedLanguage == 'Amharic' ? 'ዋና ገፅ' : 'Home'),
        ),
      ); */
      _pages.add(
        {
          'page': Profile(),
          'title': 'Country',
          'showAppBar': false,
        },
      );

      _pages.add(
        {
          'page': InfoScreen(),
          'title': 'Info',
          'showAppBar': false,
        },
      );

      /* items.add(BottomNavigationBarItem(
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(Icons.language),
        title: Text(_selectedLanguage == 'Amharic' ? 'ሀገራዊ መረጃ' : 'Country'),
      )); */

      /* items.add(BottomNavigationBarItem(
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(Icons.info),
        title: Text(_selectedLanguage == 'Amharic' ? 'መከላከያ መንገዶች' : 'Prevention'),
      )); */
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //setState(() {
    _selectedLanguage = Provider.of<CovidProvider>(context).language;
    //});
    return Scaffold(
      appBar: _pages[_selectedPageIndex]['showAppBar'] as bool == false
          ? null
          : AppBar(
              title: Text(_pages[_selectedPageIndex]['title']),
            ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Color.fromRGBO(178, 102, 255, 1),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white60,
        currentIndex: _selectedPageIndex,
        //items: items,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.purpleAccent,
            icon: Icon(Icons.home),
            title: Text(_selectedLanguage == 'Amharic' ? 'ዋና ገፅ' : 'Home'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.language),
            title:
                Text(_selectedLanguage == 'Amharic' ? 'ሀገራዊ መረጃ' : 'Country'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.info),
            title: Text(
                _selectedLanguage == 'Amharic' ? 'መከላከያ መንገዶች' : 'Prevention'),
          )
        ],
      ),
    );
  }
}
