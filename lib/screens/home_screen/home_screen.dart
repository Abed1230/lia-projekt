import 'package:flutter/material.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/screens/home_screen/widgets/home.dart';
import 'package:karlekstanken/screens/home_screen/widgets/profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Widget> _children;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _children = <Widget>[const Home(), Profile()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Padding(padding: EdgeInsets.all(10), child: Image(
          image: AssetImage('assets/images/logo.png'),
        ))), //Text(MyStrings.appName)
      ),
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(MyStrings.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text(MyStrings.profile),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,  
        selectedItemColor: Theme.of(context).accentColor,
      ),
    );
  }
}
