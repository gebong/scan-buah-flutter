import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/scan_buah.dart';
import '../pages/fruit_price.dart';
import '../pages/informasi.dart';
import '../pages/server_address.dart';

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage(
          title: 'Scan Kesegaran Buah',
        );
      },
    ),
    GoRoute(
      path: '/fruit_price',
      builder: (BuildContext context, GoRouterState state) {
        return const FruitPrice();
      },
    ),
    GoRoute(
      path: '/information',
      builder: (BuildContext context, GoRouterState state) {
        return const Information();
      },
    ),
    GoRoute(
      path: '/server',
      builder: (BuildContext context, GoRouterState state) {
        return const ServerSettingsPage();
      },
    ),
  ],
);
