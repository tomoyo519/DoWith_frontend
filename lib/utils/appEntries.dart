import "dart:developer";

import "package:flutter/material.dart";
import "package:iww_frontend/model/user/create-user.dto.dart";
import "package:iww_frontend/repository/user.repository.dart";
import 'package:iww_frontend/model/user/user-info.model.dart';
import "package:iww_frontend/utils/kakaoLogin.dart";

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

  Future<bool> createUserData() async {
    final List<CreateUserDto> dummy = [
      CreateUserDto("Tom", "010-0000-0000", "1"),
      CreateUserDto("Tom2", "010-1111-1111", "2"),
      CreateUserDto("Tom3", "010-1213-2342", "3"),
      CreateUserDto("Tom4", "010-2342-2342", "4"),
      CreateUserDto("Tom5", "010-2343-0043", "5"),
      CreateUserDto("Tom6", "010-3455-4432", "6"),
      CreateUserDto("Tom7", "010-0003-0000", "7"),
      CreateUserDto("Tom8", "010-3111-1111", "8"),
      CreateUserDto("Tom9", "010-1413-2342", "9"),
      CreateUserDto("Tom10", "010-2342-5342", "10"),
      CreateUserDto("Tom11", "010-2383-0043", "11"),
      CreateUserDto("Tom12", "010-3155-4432", "12"),
      CreateUserDto("Tom13", "010-8888-0009", "13"),
      CreateUserDto("Tom14", "010-8899-0039", "14"),
      CreateUserDto("Tom15", "010-4502-0934", "15"),
      CreateUserDto("Tom16", "010-4534-9239", "16"),
      CreateUserDto("Tom17", "010-1111-1112", "17"),
      CreateUserDto("Tom18", "010-1111-1113", "18"),
      CreateUserDto("Tom19", "010-1111-1114", "19"),
      CreateUserDto("Tom20", "010-1111-1115", "20"),
      CreateUserDto("Tom21", "010-1111-1116", "21"),
      CreateUserDto("Tom22", "010-1111-1117", "22"),
      CreateUserDto("Tom23", "010-1111-1118", "23"),
      CreateUserDto("Tom24", "010-1111-1119", "24"),
      CreateUserDto("Tom25", "010-1111-1120", "25"),
      CreateUserDto("Tom26", "010-1111-1121", "26"),
      CreateUserDto("Tom27", "010-1111-1122", "27"),
      CreateUserDto("Tom28", "010-1111-1123", "28"),
      CreateUserDto("Tom29", "010-1111-1124", "29"),
      CreateUserDto("Tom30", "010-1111-1125", "30"),
      CreateUserDto("Tom31", "010-1111-1126", "31")
    ];

    try {
      for (var data in dummy) {
        await UserRepository.createTestUser(data);
      }
      return true;
    } catch (error) {
      log("Error creating test users: $error");
      return false;
    }
  }
}

// 유저 로그인 여부에 따른 앱 진입 시나리오
class AppEntries extends StatelessWidget {
  final _signInTest = _SignUpTest();
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
                Navigator.pushNamed(context, "/landing");
              },
              child: const Text("🐤 회원가입")),
          ElevatedButton(
              onPressed: () {
                _signInTest.expiredToken();
                Navigator.pushNamed(context, "/landing");
              },
              child: const Text("🤔 액세스 토큰이 없거나 만료된 유저")),
          ElevatedButton(
              onPressed: () {
                // _signInTest.createUserData().then((value) {
                //   if (value == true) {
                Navigator.pushNamed(context, "/contact");
                //   }
                // });
              },
              child: const Text("🤔 연락처 기반 친구추가")),
          ElevatedButton(
              onPressed: () async {
                _signInTest.autoLogin().then((result) {
                  if (result && context.mounted) {
                    Navigator.pushNamed(context, "/home");
                  }
                });
              },
              child: const Text("👀 메인 랜딩 페이지"))
        ]);
  }
}
