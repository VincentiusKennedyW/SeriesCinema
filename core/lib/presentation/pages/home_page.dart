import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:movies/presentation/pages/home_movie_page.dart';
import 'package:tv_series/presentation/pages/home_tv_series_page.dart';

import '../widgets/app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;

  final List<BottomNavigationBarItem> _bottomNavBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.movie),
      label: 'Movies',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.live_tv_rounded),
      label: 'TV Series',
    ),
  ];

  final List<Widget> _listWidget = [
    const HomeMoviePage(),
    const HomeTvSeriesPage(),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  void _onSearchPressed(BuildContext context) {
    if (_bottomNavIndex == 0) {
      Navigator.pushNamed(context, SEARCH_MOVIE_ROUTE);
    } else {
      Navigator.pushNamed(context, SEARCH_TV_SERIES_ROUTE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              _onSearchPressed(context);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      drawer: AppDrawer(onNavigate: (route) {
        Navigator.popAndPushNamed(context, route);
      }),
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
        selectedItemColor: Colors.blue,
      ),
    );
  }
}
