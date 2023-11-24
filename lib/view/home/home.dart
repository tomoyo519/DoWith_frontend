import 'package:flutter/material.dart';
import 'package:iww_frontend/repository/todo.repository.dart';
import 'package:iww_frontend/service/auth.service.dart';
import 'package:iww_frontend/style/colors.dart';
import 'package:iww_frontend/view/_common/appbar.dart';
import 'package:iww_frontend/view/_common/bottombar.dart';
import 'package:iww_frontend/view/home/home_profile.dart';
import 'package:iww_frontend/view/todo/todo-list.dart';
import 'package:iww_frontend/viewmodel/todo.viewmodel.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoRepository = Provider.of<TodoRepository>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    // 현재 유저가 없는 경우
    if (authService.currentUser == null) {
      Navigator.pushNamedAndRemoveUntil(context, "/app", (route) => false);
    }

    return Scaffold(
      backgroundColor: MyColors.light,
      appBar: MyAppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {},
            color: (Colors.black),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          // 배경 이미지
          image: AssetImage("assets/wallpaper.jpg"),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: HomeProfile(),
            ),
            Expanded(
              flex: 4,
              child: ChangeNotifierProvider<TodoViewModel>(
                create: (context) => TodoViewModel(
                  todoRepository,
                  authService,
                ),
                child: ToDoList(),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNav(),
    );
  }
}
