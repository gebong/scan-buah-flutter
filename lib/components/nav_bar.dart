import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Main Menus'),
          ),
          ListTile(
            title: const Text('Pemindaian Kesegaran Buah'),
            onTap: () => context.go('/'),
          ),
          ListTile(
            title: const Text('Pengaturan Harga Buah'),
            onTap: () => context.go('/fruit_price'),
          ),
          ListTile(
            title: const Text('Informasi'),
            onTap: () => context.go('/information'),
          ),
          ListTile(
            title: const Text('Konfigurasi Server'),
            onTap: () => context.go('/server'),
          ),
        ],
      ),
    );
  }
}
