import 'dart:convert';

import 'package:http/http.dart';
import 'package:swash/exceptions/network.dart';
import 'package:swash/models/conversations.dart';
import 'package:swash/path.dart';

Future<List<Message>> getMessages({required String conversationId}) async {
  Response response = await post(
      Uri.parse(AppPath.api + '/chat/getMessages.php'),
      body: {"id": conversationId});
  print(response.body);
  Map<String, dynamic> data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    if (data['status']) {
      List<Message> m = [];
      for (Map i in data['message']) {
        m.add(Message.fromjson(i));
      }
      return m;
    } else {
      return Future.error(NetworkError(msg: data['message']));
    }
  }
  return Future.error(NetworkError(msg: 'something is wrong'));
}
