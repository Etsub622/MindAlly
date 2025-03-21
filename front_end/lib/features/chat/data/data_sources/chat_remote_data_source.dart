

import 'dart:convert';
import 'dart:core';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/core/config/config_key.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/features/chat/data/models/chats_model.dart';
import 'package:front_end/features/chat/data/models/single_chat_model.dart';
import 'package:front_end/features/chat/domain/entities/chats_entity.dart';
import 'package:front_end/features/chat/domain/entities/list_chats_entity.dart';
import 'package:front_end/features/chat/domain/entities/message_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


abstract class ChatRemoteDataSource {
  Future<void> sendMessage(
      {required MessageModel messageModel});

  Future<List<MessageEntity>> fetchMessages({
    required String chatId
  });
  Future<ListChatsEntity> getAllChats();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final sharedPreferences = SharedPreferences.getInstance();
  final String baseUrl = ConfigKey.baseUrl;
  
  final FlutterSecureStorage flutterSecureStorage =
      const FlutterSecureStorage();

  final String authenticationKey = "access_token";
  final String userProfileKey = "user_profile";
  
   Future<String?> getUserId() async {
    final userCredential = await flutterSecureStorage.read(key: userProfileKey);

    if (userCredential != null) {
      final body = await json.decode(userCredential);

      return body["_id"].toString();
    }
    return null;
  }
  
  @override
  Future<ListChatsEntity> getAllChats() async {
    
    try {
      final prefs = await sharedPreferences;
      String token = prefs.getString("token_key") ?? '';
     
      String userId = await getUserId() ?? "";

      final responce = await http.get(
        Uri.parse('$baseUrl/chat/?userId=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

    if(responce.statusCode == 200) {
      final jsonBody = jsonDecode(responce.body) as Map<String, dynamic>;
      final List<dynamic> data = jsonBody['data'] as List<dynamic>;
      List<ChatsEntity> messages = data.map((e) => ChatsModel.fromJson(e as Map<String, dynamic>)).toList();

      final chatList = ListChatsEntity(chats: messages, userId: userId);

      return chatList;
      }else{
        throw ServerException(
          message: jsonDecode(responce.body)["error"],
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Error in getting single chat',
      );
    }
  }

  @override
  Future<List<MessageEntity>> fetchMessages({required String chatId}) async {
    try {
      final prefs = await sharedPreferences;
      String token = prefs.getString("token_key") ?? '';
      String userId = await getUserId() ?? "";


      final responce = await http.get(
        Uri.parse('$baseUrl/chat/$userId?chatId=$chatId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if(responce.statusCode == 200) {
      final jsonBody = jsonDecode(responce.body) as Map<String, dynamic>;
      final Map<String, dynamic> data = jsonBody['data'] as Map<String, dynamic>;
      final List<dynamic> messagesData = data['messages'] as List<dynamic>;
      List<MessageEntity> messages = messagesData.map((e) => MessageModel.fromJson(e)).toList();

      return messages;
        
      }else{
          throw ServerException(
          message: 'Error in getting single chat',
        );
      }

    } catch (e) {
      throw ServerException(
        message: 'Error in getting single chat',
      );
    }
  }

  @override
  Future<void> sendMessage(
      {required MessageModel messageModel}) async {
    try {
      final response = http.post(
        Uri.parse('$baseUrl/chat/message/send'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(messageModel.toJson()),
      );
    } catch (e) {
      throw ServerException(
        message: 'Error in sending message',
      );
    }
  }
}
