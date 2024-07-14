import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
class ChatNotificationService {
  static const String baseUrl = Constant.serverAddress; // Replace with your backend URL
  static const Duration pollingInterval = Duration(seconds: 10); // Adjust as needed
  static Timer? _pollingTimer;
  static Function(int)? onNewMessage;

  static void startPolling(String userId, String userModel) {
    _pollingTimer?.cancel(); // Cancel previous timer if exists

    _pollingTimer = Timer.periodic(pollingInterval, (timer) {
      fetchUnreadMessageCount(userId, userModel).then((unreadCount) {
        onNewMessage?.call(unreadCount); // Notify listeners about new messages
      }).catchError((error) {
        print('Error fetching unread message count: $error');
      });
    });
  }

  static Future<int> fetchUnreadMessageCount(String userId, String userModel) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chat/history?userId=$userId&userModel=$userModel&contactId=&contactModel='),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['unreadCount'] ?? 0;
    } else {
      throw Exception('Failed to fetch unread message count');
    }
  }

  static void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }
}
