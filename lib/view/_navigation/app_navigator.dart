// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/view/_navigation/app_page.model.dart';
import 'package:iww_frontend/view/_navigation/enum/app_route.dart';
import 'package:iww_frontend/view/group/groupMain.dart';
import 'package:iww_frontend/view/home/home.dart';
import 'package:iww_frontend/view/mypage/myPage.dart';
import 'package:iww_frontend/view/myroom/myroom.dart';
import 'package:iww_frontend/view/notification/notification.dart';
import 'package:iww_frontend/view/shop/shop_page.dart';

/// ************************ ///
/// *                      * ///
/// *       Navigator      * ///
/// *                      * ///
/// ************************ ///

class AppNavigator extends ChangeNotifier {
  AppNavigator() {
    // 초기 내비게이션 상태
    _stack.add(_idx);
  }

  // * ===== navigation status ===== * //
  List<int> _stack = [];
  int _idx = 0;

  AppPage get current => ALL_PAGES[_idx];
  bool get isBottomSheetPage => _idx < 5;
  int get idx => _idx;

  void navigate(AppRoute route) {
    _idx = route.index;
    _stack = [];
    _stack.add(route.index);
    notifyListeners();
  }

  void push(AppRoute route) {
    _idx = route.index;
    _stack.add(route.index);
    notifyListeners();
  }

  void pop() {
    _stack.removeLast();
    _idx = _stack.isEmpty ? 0 : _stack.last;
    notifyListeners();
  }

  // * ===== Page Getters ==== * //
  List<AppPage> get ALL_PAGES {
    return [_todo, _group, _room, _shop, _mypage, _notification];
  }

  List<AppPage> get BOTTOM_PAGES {
    return [_todo, _group, _room, _shop, _mypage];
  }

  List<AppPage> get APPBAR_PAGES {
    return [_notification];
  }

  IconButton? get pushback {
    return isBottomSheetPage
        ? null
        : IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              pop();
            },
          );
  }

  // * =====   Page List   ==== * //
  final AppPage _todo = AppPage(
    idx: AppRoute.todo,
    label: "할일",
    icon: Icons.check_box_outlined,
    builder: (context) => TodoPage(),
  );

  final AppPage _group = AppPage(
    idx: AppRoute.group,
    label: "그룹",
    icon: Icons.people_alt_outlined,
    builder: (context) => MyGroupPage(),
  );

  final AppPage _room = AppPage(
    idx: AppRoute.room,
    label: "홈",
    icon: Icons.home_outlined,
    builder: (context) => MyRoom(),
  );

  final AppPage _shop = AppPage(
    idx: AppRoute.shop,
    label: "상점",
    icon: Icons.shopping_bag_outlined,
    builder: (context) => ShopPage(),
  );

  final AppPage _mypage = AppPage(
    idx: AppRoute.mypage,
    label: "마이페이지",
    icon: Icons.person_outline_rounded,
    builder: (context) => MyPage(),
  );

  final AppPage _notification = AppPage(
    idx: AppRoute.notification,
    label: "알림 히스토리",
    icon: Icons.notifications,
    builder: (context) => MyNotification(),
  );
}