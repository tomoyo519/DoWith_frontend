import 'package:flutter/material.dart';
import 'package:iww_frontend/view/_navigation/routes.dart';

// 단일 페이지 정보
class AppPage<T> {
  final String route;
  final String label;
  final IconData icon;
  final ActionPage? float;
  final List<ActionPage>? appbar;
  final T Function(BuildContext context) builder;

  AppPage({
    required this.route,
    required this.label,
    required this.icon,
    required this.builder,
    this.float,
    this.appbar,
  });
}

// Appbar, FloatingActionButton 등
// Scaffold 서브위젯으로 내비게이팅되는 화면 정보
class ActionPage {
  final String route;
  final String label;
  final IconData icon;

  ActionPage({
    required this.route,
    required this.label,
    required this.icon,
  });

  Widget toWidget(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (ROUTE_TABLE.keys.contains(route)) {
          Navigator.pushNamed(context, route);
        }
      },
      icon: Icon(icon),
    );
  }
}