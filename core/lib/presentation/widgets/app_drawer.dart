import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final Function(String) onNavigate;

  const AppDrawer({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/app_logo.jpg'),
            ),
            accountName: Text('Vincentius Kennedy Winardinata'),
            accountEmail: Text('kenken010103@gmail.com'),
            decoration: BoxDecoration(
              color: Colors.blue, // Change the background color to blue
            ),
          ),
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: const Text('Watchlist'),
            onTap: () => onNavigate(WATCHLIST_ROUTE),
          ),
          ListTile(
            onTap: () => onNavigate(ABOUT_ROUTE),
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
          ),
        ],
      ),
    );
  }
}
