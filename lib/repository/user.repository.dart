import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:iww_frontend/datasource/localStorage.dart';
import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/user/get-user-by-contact.dto.dart';
import 'package:iww_frontend/model/user/user-info.model.dart';
import 'package:iww_frontend/model/user/user.model.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 로컬 캐시 및 DB에서 유저 데이터를 관리합니다.
class UserRepository {
  /// ================== ///
  ///       Create       ///
  /// ================== ///

  // 현재 로그인한 유저 생성
  Future<UserModel?> createUser(
    String userName,
    String userTel,
    String userKakaoId,
  ) async {
    // 서버로 유저 정보 전송
    Response response = await RemoteDataSource.post(
      "/auth/singup",
      body: {
        "user_name": userName,
        "user_tel": userTel,
        "user_kakao_id": userKakaoId
      },
    );

    if (response.statusCode != 201) {
      return null;
    }

    var jsonBody = jsonDecode(response.body)['result'];
    UserModel user = UserModel.fromJson(jsonBody['user']);
    String token = jsonBody['token'];

    // 로그인 정보를 로컬에 저장
    await LocalStorage.saveKey('jwt', token);
    await LocalStorage.saveKey("user_info", jsonBody['user']);

    return user;
  }

  // 유저 프로필 이미지 서버로 전송
  Future<bool> createUserProfile(int userId) async {
    // 로컬 스토리지에 저장해둔 파일 불러오기
    File image = await LocalStorage.read("$userId.jpg");

    return await RemoteDataSource.postFormData(
      "/user/$userId/profile",
      'profile',
      file: image,
      filename: '$userId.jpg',
    ).then((response) => response.statusCode == 201);
  }

  /// ================== ///
  ///        Read        ///
  /// ================== ///

  // 카카오 아이디 기준으로 유저 정보 조회
  Future<UserModel?> getUserByKakaoId(String userKakaoId) async {
    return await RemoteDataSource.get("/user?user_kakao_id=$userKakaoId")
        .then((response) {
      LOG.log("Get user by kakao id ${response.body}");
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var jsonData = json.decode(response.body);
        return UserModel.fromJson(jsonData);
      } else {
        // 해당 유저가 없거나 예외 반환한 경우
        return null;
      }
    });
  }

  // 이름을 기준으로 유저 정보 조회
  Future<UserModel?> getUserByName(String name) async {
    return await RemoteDataSource.get("/user?user_name=$name").then((response) {
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var jsonData = json.decode(response.body);
        return UserModel.fromJson(jsonData);
      } else {
        // 해당 유저가 없거나 예외 반환한 경우
        return null;
      }
    });
  }

  // 연락처 기준으로 유저 정보 조회
  Future<List<UserModel>?> getUsersByContacts(
      GetUsersByContactsDto body) async {
    return await RemoteDataSource.post("/user/contacts", body: body.toJson())
        .then((response) {
      if (response.statusCode == 201 && response.body.isNotEmpty) {
        // JSON 문자열을 Dart 객체로 변환
        var jsonData = json.decode(response.body);
        var listData = jsonData as List;
        if (listData.isNotEmpty) {
          return listData
              .map((item) => UserModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          return null;
        }
      } else {
        LOG.log("Fail to fetch user infos");
        return null;
      }
    });
  }

  /// ================== ///
  ///       Update       ///
  /// ================== ///
  Future<bool> updateUserPet(int userId, int petId) {
    return RemoteDataSource.put("/user/$userId/pet/$petId")
        .then((response) => response.statusCode == 200);
  }

  /// ================== ///
  ///       Delete       ///
  /// ================== ///

  // 유저 아이디를 기준으로 DB에서 삭제 처리
  Future<bool> deleteUserById(int userId) async {
    return RemoteDataSource.delete("/user/$userId")
        .then((response) => response.statusCode == 200);
  }

  // 유저 카카오 아이디를 기준으로 DB에서 삭제 처리
  Future<bool> deleteUserByKakaoId(String kakaoId) async {
    return RemoteDataSource.delete("/user?user_kakao_id=$kakaoId")
        .then((response) => response.statusCode == 200);
  }

  // 로컬 캐시에서 유저 정보 클리어
  Future<bool> deleteUserInLocal() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      await pref.remove("user_id");
      await pref.remove("user_name");
      await pref.remove("user_tel");
      await pref.remove("user_kakao_id");
      await pref.remove("user_hp");
      return true;
    } catch (error) {
      return false;
    }
  }
}
