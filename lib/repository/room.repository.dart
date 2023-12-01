import 'dart:convert';

import 'package:iww_frontend/datasource/remoteDataSource.dart';
import 'package:iww_frontend/model/item/item.model.dart';
import 'package:iww_frontend/utils/logger.dart';
import 'package:iww_frontend/viewmodel/myroom.viewmodel.dart';

class RoomRepository {
  // 특정 유저의 룸 정보 가져오기
  Future<List<Item>> getItemsOfMyRoom(int userId) async {
    return await RemoteDataSource.get('/room/$userId').then((response) {
      Map<String, dynamic> parsedJson = json.decode(response.body);
      List<Item> items = (parsedJson['result'] as List<dynamic>)
          .map((item) => Item.fromJson(item))
          .toList();
      LOG.log('[Room status]: ${response.body}');

      return items;
    });
  }

  // NOTE 하위 3개의 함수의 인자 userId는 항상 나 자신의 userId 입니다.
  // 나의 인벤토리 정보 가져오기
  Future<List<Item>> getItemsOfInventory(int userId) async {
    return await RemoteDataSource.get('/item-inventory/$userId')
        .then((response) {
      Map<String, dynamic> parsedJson = json.decode(response.body);
      List<Item> items = (parsedJson['result'] as List<dynamic>)
          .map((item) => Item.fromJson(item))
          .toList();
      LOG.log('[Inventory status] ${response.body}');

      return items;
    });
  }

  // 나의의 룸에 아이템 추가하기
  Future<void> addItemToMyRoom(int userId, int itemId) async {
    return await RemoteDataSource.post('/room/$userId/$itemId')
        .then((response) {
      LOG.log('Add item to my room: ${response.statusCode}');
      LOG.log('Add item to my room: ${response.body}');
    });
  }

  // 나의 룸에서 아이템 삭제하기
  Future<void> removeItemFromMyRoom(int userId, int itemId) async {
    return await RemoteDataSource.delete('/room/$userId/$itemId')
        .then((response) {
      LOG.log('Remove item from my room: ${response.statusCode}');
      LOG.log('Remove item from my room: ${response.body}');
    });
  }
}
