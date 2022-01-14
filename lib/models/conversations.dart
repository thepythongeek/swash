import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:swash/exceptions/network.dart';
import '../path.dart';

class Conversation {
  Message message;
  List<Message>? messages;
  String id;
  String userId1;
  String userId2;
  String username;
  String username2;
  String createdAt;

  Conversation(
      {required this.message,
      required this.userId1,
      required this.userId2,
      required this.username,
      required this.username2,
      this.messages,
      required this.id,
      required this.createdAt});

  factory Conversation.fromjson(Map json) {
    return Conversation(
        message: Message.fromjson(json['messages']),
        id: json['conversation_id'],
        userId1: json['user_id'],
        userId2: json['user2'],
        username: json['username'],
        username2: json['username2'],
        createdAt: json['createdAt']);
  }

  // void update(Conversation value) {
  //  if (value.messages.isNotEmpty) {
  //   messages.addAll(value.messages);
  //  }
  // }

  void addMessages(List<Message> value) {
    messages = value;
  }
}

class Message {
  final int id;
  final String body;
  String createdAt;
  final int senderId;
  final int recipientId;
  String isRead;

  Message(
      {required this.id,
      required this.body,
      required this.createdAt,
      required this.isRead,
      required this.recipientId,
      required this.senderId});

  factory Message.fromjson(Map json) {
    return Message(
        id: int.parse(json['id']),
        body: json['body'],
        createdAt: json['createdAt'],
        isRead: json['isRead'],
        recipientId: int.parse(json['recipientID']),
        senderId: int.parse(json['senderId']));
  }
  String recieverOrSender(String currentUserId) {
    if (currentUserId == senderId.toString()) {
      return 'sender';
    } else {
      return 'reciever';
    }
  }

  void update() {
    updateMessage(id: id.toString());
  }
}

Future<String> updateMessage({required String id}) async {
  http.Response response = await http.post(
      Uri.parse('${AppPath.domain}/chat/updateMessage.php'),
      body: {'id': id});
  print(response.body);

  Map<String, dynamic> data = jsonDecode(response.body);
  if (data['success']) {
    return data['message'];
  } else {
    throw NetworkError(msg: data['message']);
  }
}
