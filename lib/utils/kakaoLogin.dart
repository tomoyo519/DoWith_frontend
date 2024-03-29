import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:iww_frontend/model/auth/login_result.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';

// // 카카오 서버와의 통신과 인증 토큰 발급을 담당하는 서비스 레이어
// class KaKaoLogin {
//   // 카카오톡 로그인 후 사용자 정보 반환
//   Future<AuthStatus> backgroundLogin() async {
//     // 모달창 없이 백그라운드에서만 로그인
//     // Flutter SDK에 저장된 토큰의 유효성을 먼저 검사하고
//     if (await getTokenInfo() != null) {
//       return AuthStatus.success;
//     }
//     return AuthStatus.failed;
//   }

//   // 카카오톡 로그인 후 사용자 정보 반환
//   Future<AuthStatus> login() async {
//     // Flutter SDK에 저장된 토큰의 유효성을 먼저 검사하고
//     if (await getTokenInfo() != null) {
//       return AuthStatus.success;
//     }
//     // 유효하지 않으면 로그인 시도
//     return await _doLogin();
//   }

//   // 카카오톡 로그아웃
//   Future<bool> logout() async {
//     try {
//       await UserApi.instance.logout();
//       LOG.log('로그아웃 성공, SDK에서 토큰 삭제');
//       return true;
//     } catch (error) {
//       LOG.log('로그아웃 실패, SDK에서 토큰 삭제 $error');
//       return false;
//     }
//   }

//   // 카카오톡 연결 해제
//   Future<bool> disconnect() async {
//     try {
//       await UserApi.instance.unlink();
//       LOG.log('연결 끊기 성공, SDK에서 토큰 삭제');
//       return true;
//     } catch (error) {
//       LOG.log('연결 끊기 실패 $error');
//       return false;
//     }
//   }

//   // 사용자 정보 반환
//   Future<User?> getUserInfo() async {
//     try {
//       return await UserApi.instance.me();
//     } catch (error) {
//       LOG.log('사용자 정보 요청 실패 $error');
//       return null;
//     }
//   }

//   // Flutter SDK에 저장된 액세스 토큰 정보 조회
//   Future<AccessTokenInfo?> getTokenInfo() async {
//     try {
//       return await UserApi.instance.accessTokenInfo();
//     } catch (error) {
//       return null;
//     }
//   }

//   // 사용자에게 카카오톡 인증을 요청하고
//   // 인증 토큰을 내부적으로 저장
//   Future<AuthStatus> _doLogin() async {
//     if (await isKakaoTalkInstalled()) {
//       try {
//         await UserApi.instance.loginWithKakaoTalk();
//         LOG.log('Kakao Talk login success');
//         return AuthStatus.success;
//       } catch (error) {
//         LOG.log('Kakao Talk login failed: $error');
//         // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
//         // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
//         if (error is PlatformException && error.code == 'CANCELED') {
//           return AuthStatus.failed;
//         }
//         // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
//         try {
//           await UserApi.instance.loginWithKakaoAccount();
//           LOG.log('Kakao Account login success');
//           return AuthStatus.success;
//         } catch (error) {
//           LOG.log('Kakao Account login failed: $error');
//           if (error is PlatformException && error.code == 'CANCELED') {
//             return AuthStatus.failed;
//           }
//           return AuthStatus.permission;
//         }
//       }
//     } else {
//       try {
//         await UserApi.instance.loginWithKakaoAccount();
//         LOG.log('Kakao Account login success');
//         return AuthStatus.success;
//       } catch (error) {
//         LOG.log('Kakao Account login failed: $error');
//         if (error is PlatformException && error.code == 'CANCELED') {
//           return AuthStatus.failed;
//         }
//         return AuthStatus.permission;
//       }
//     }
//   }
// }
