import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/wallpaper.jpg"),
        fit: BoxFit.cover,
      )),
      child: Center(
          // child: Text("로딩중입니다", st),
          ),
    );
  }
}