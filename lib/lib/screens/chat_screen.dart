import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userModel;
  final String contactId;
  final String contactModel;
  final String? token;

  const ChatScreen({super.key, 
    required this.userId,
    required this.userModel,
    required this.contactId,
    required this.contactModel, this.token,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _fetchChatHistory();
  }

  Future<void> _fetchChatHistory() async {
    try {
      List<ChatMessage> messages = await ChatService.getChatHistory(
        widget.userId,
        widget.userModel,
        widget.contactId,
        widget.contactModel,
        widget.token,
      );
      if (mounted) {
        setState(() {
          _messages = messages;
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isSending) return;

    String message = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _isSending = true;
    });

    try {
      await ChatService.sendMessage(
        widget.userId,
        widget.userModel,
        widget.contactId,
        widget.contactModel,
        message,
        widget.token,
      );
      await _fetchChatHistory();
    } catch (e) {
      // Handle error (e.g., show a Toast message)
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('hh:mm a').format(timestamp);
  }

  String _formatDate(DateTime timestamp) {
    return DateFormat('MMMM dd, yyyy').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.contactModel}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      ChatMessage msg = _messages[index];
                      bool isSentByUser = msg.senderId == widget.userId;

                      bool showDateSeparator = false;
                      if (index == 0 ||
                          msg.timestamp.toLocal().day !=
                              _messages[index - 1].timestamp.toLocal().day) {
                        showDateSeparator = true;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showDateSeparator)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Text(
                                  _formatDate(msg.timestamp),
                                  style:const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Align(
                              alignment: isSentByUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                padding:const  EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSentByUser
                                      ? Colors.blueAccent
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      msg.message,
                                      style: TextStyle(
                                          color: isSentByUser
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _formatTimestamp(msg.timestamp),
                                          style: TextStyle(
                                              color: isSentByUser
                                                  ? Colors.white
                                                  : Colors.black54,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(width: 5),
                                        if (isSentByUser)
                                          Icon(
                                            Icons.done_all,
                                            size: 12,
                                            color: msg.isRead
                                                ? Colors.blue
                                                : Colors.grey,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: Icon(Icons.message),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: _isSending ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
