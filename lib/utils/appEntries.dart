import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iww_frontend/home.dart';
import 'package:iww_frontend/screens/landing.dart';
import 'package:iww_frontend/screens/signup.dart';
import 'package:iww_frontend/utils/kakaoLogin.dart';
import 'package:iww_frontend/webservice.dart';

/// 메인에서 여러 가지 인증 로직을 테스트합니다.
class _SignUpTest {
  static final kakaoLogin = KaKaoLogin.instance;

  newUser() {
    kakaoLogin.disconnect();
  }

  expiredToken() {
    kakaoLogin.logout();
  }

  Future<bool> autoLogin() async {
    return await kakaoLogin.autoLogin() != null;
  }
}

// 유저 로그인 여부에 따른 앱 진입 시나리오
class AppEntries extends StatelessWidget {
  final _signInTest = _SignUpTest();
  static final _webService = WebService.instance;
  AppEntries({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: () {
                _signInTest.newUser();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Landing()));
              },
              child: const Text("👏 유저가 앱을 처음으로 방문")),
          ElevatedButton(
              onPressed: () {
                _signInTest.expiredToken();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Landing()));
              },
              child: const Text("🤔 액세스 토큰이 없거나 만료된 유저")),
          ElevatedButton(
              onPressed: () async {
                if (await _signInTest.autoLogin() && context.mounted) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyHome()));
                }
              },
              child: const Text("👀 일반적인 자동 로그인")),
          ElevatedButton(
              onPressed: () async {
                await _webService
                    .hello()
                    .then((response) => {log("Hello? ${response.toString()}")});
              },
              child: const Text("🐹 테스트 서버 연결 체크"))
        ]);
  }
}
