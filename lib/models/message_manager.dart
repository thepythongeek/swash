import 'package:flutter/material.dart';
import 'package:swash/models/models.dart';

class MessageManager extends ChangeNotifier {
  Conversation? _conversation;
  String? _user_id;
  bool _updateConversation = false;

  Conversation? get conversation => _conversation;
  String get recipient => _user_id!;

  void clear() {
    _conversation = null;
    _updateConversation = false;
  }

  void add(
    Conversation? value,
  ) {
    if (value != null) {
      _conversation = value;

      // notifyListeners();
    }
  }

  void addRecipient(String id) {
    _user_id = id;
  }

  /*void update(Conversation fresh) {
    _conversation!.messages.addAll(fresh.messages);
    notifyListeners();
  }*/
}
