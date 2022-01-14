import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:swash/exceptions/network.dart';
import 'package:swash/models/models.dart';
import '../path.dart';

Future<Conversation> sendMessage(
    {required BuildContext context,
    required String from,
    required String to,
    required String body,
    String? conversationId}) async {
  http.Response response = await http
      .post(Uri.parse('${AppPath.domain}/chat/send_message.php'), body: {
    'sender_id': from,
    'recipient_id': to,
    'body': body,
    if (conversationId != null) 'conv_id': conversationId
  });
  print(response.body);
  Map<String, dynamic> data = jsonDecode(response.body);
  print(data);
  if (data['success']) {
    // attempt to grab all unread messages for every conversation of this user
    getConversations(userId: from, read: '0').then((value) {
      Provider.of<ConversationList>(context, listen: false).update(value);
    });
    return Conversation.fromjson(data['message']);
  } else {
    throw NetworkError(msg: data['message']);
  }
}

Future<List<Conversation>> getConversations(
    {required String userId, String read = 'all'}) async {
  http.Response response = await http.post(
      Uri.parse('${AppPath.domain}/chat/get_conversations.php'),
      body: {'user_id': userId, 'read': read});
  print(response.body);
  Map<String, dynamic> data = jsonDecode(response.body);
  print(data['success']);
  if (data['success'] != null) {
    List<Conversation> conversations = [];
    for (var i in data['message']) {
      conversations.add(Conversation.fromjson(i));
    }
    print('gotya');
    print(conversations);
    return conversations;
  } else {
    throw NetworkError(msg: data['message']);
  }
}
