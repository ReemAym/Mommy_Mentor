// lib/services/chat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/chat.dart';
import '../models/reciever.dart';

class ChatService {
  static const String baseUrl = Constant.serverAddress;
  Future<List<Receiver>> fetchReceivers(
      String type, int limit, int page, String? token) async {
    List<Receiver> list = [];
    final response = await http.get(
      Uri.parse('$baseUrl/$type/all'),
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Add the token to the header
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      for (int i = 0; i < data.length; i++) {
        // Determine the first name key
        String name = data[i]['name'] ?? data[i]['name'] ?? '';
        String firstName = data[i]['firstname'] ?? data[i]['firstName'] ?? '';
        String lastName = data[i]['lastname'] ?? data[i]['lastName'] ?? '';
        bool online = data[i]['online'] ?? data[i]['online'] ??  false;


        // Create a Receiver object with the required keys
        Receiver receiver;
        if (name == '') {
          receiver = Receiver(
            id: data[i]['_id'],
            name: "$firstName $lastName",
            model: type,
            online: online,
          );
        } else {
          receiver = Receiver(
            id: data[i]['_id'],
            name: name,
            model: type,
            online: online,
          );
        }

        // Add the Receiver object to the list
        list.add(receiver);
      }
      return list;
    } else {
      throw Exception('Failed to load receivers');
    }
  }

  Future<List<Receiver>> fetchOnlineReceivers(
      String type, int limit, int page,String? token) async {
    List<Receiver> list = [];
    final response = await http.get(
      Uri.parse('$baseUrl/$type/online'),
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Add the token to the header
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      for (int i = 0; i < data.length; i++) {
        // Determine the first name key
        String name = data[i]['name'] ?? data[i]['name'] ?? '';
        String firstName = data[i]['firstname'] ?? data[i]['firstName'] ?? '';
        String lastName = data[i]['lastname'] ?? data[i]['lastName'] ?? '';
        bool online = data[i]['online'] ?? data[i]['online'] ??  false;

        // Create a Receiver object with the required keys
        Receiver receiver;
        if (name == '') {
          receiver = Receiver(
            id: data[i]['_id'],
            name: "$firstName $lastName",
            model: type,
            online: online,
          );
        } else {
          receiver = Receiver(
            id: data[i]['_id'],
            name: name,
            model: type,
            online: online,
          );
        }

        // Add the Receiver object to the list
        list.add(receiver);
      }
      return list;
    } else {
      throw Exception('Failed to load receivers');
    }
  }

  static Future<List<ChatMessage>> getChatHistory(String userId,
      String userModel, String contactId, String contactModel,String? token) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/chat/history?userId=$userId&userModel=$userModel&contactId=$contactId&contactModel=$contactModel'),
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Add the token to the header
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body)['chatHistory'];
      return body.map((dynamic item) => ChatMessage.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load chat history');
    }
  }

  static Future<void> sendMessage(String senderId, String senderModel,
      String receiverId, String receiverModel, String message,String? token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chat/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Add the token to the header
      },
      body: json.encode({
        'sender': senderId,
        'senderModel': senderModel,
        'receiver': receiverId,
        'receiverModel': receiverModel,
        'message': message,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }
}
