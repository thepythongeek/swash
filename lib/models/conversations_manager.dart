import 'package:flutter/cupertino.dart';
import 'package:swash/models/conversations.dart';

class ConversationList extends ChangeNotifier {
  List<Conversation> _conversations = [];
  bool _update = false;

  bool get isupdate => _update;
  List<Conversation> get conversations => _conversations;

  void add(List<Conversation> value) {
    _conversations.addAll(value);
  }

  void update(List<Conversation> fresh) {
    for (var i in fresh) {
      bool fresh = false;
      for (var j in _conversations) {
        // update the conversation object
        if (i.id == j.id) {
          // j.update(i);
          print('hey');
          fresh = true;
          break;
        }
      }
      if (!fresh) {
        _conversations.add(i);
      }
    }
    _update = true;
    notifyListeners();
  }
}
