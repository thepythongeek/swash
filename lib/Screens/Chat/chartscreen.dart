import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:swash/models/message_manager.dart';
import 'package:swash/object/get_messages.dart';
import 'package:swash/object/send_chat.dart';
import 'package:web_socket_channel/io.dart';
import '../../models/models.dart';

class Chats {
  String body;
  DateTime when;
  String sender;
  Chats({required this.body, required this.when, required this.sender});
}

class ChatArea extends StatefulWidget {
  final IOWebSocketChannel channel;
  const ChatArea({Key? key, required this.channel}) : super(key: key);

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  final TextEditingController _controller = TextEditingController();
  late Future<List<Message>> _future;
  Stream? _stream;

  List chats = [
    Chats(
        body: 'helo john',
        when: DateTime.utc(2008, 1, 20, 18, 23),
        sender: 'sender'),
    Chats(
        body: 'helo max',
        when: DateTime.utc(2008, 1, 20, 18, 23),
        sender: 'recipient'),
    Chats(
        body: 'abt yersterday',
        when: DateTime.utc(2008, 1, 20, 18, 23),
        sender: 'sender'),
    Chats(
        body: 'wat abt it',
        when: DateTime.utc(2008, 1, 20, 18, 23),
        sender: 'reciever'),
    Chats(
        body: 'i dont know',
        when: DateTime.utc(2008, 1, 20, 18, 23),
        sender: 'sender'),
    Chats(
        body: 'bt u kno wat',
        when: DateTime.utc(2008, 1, 20, 18, 23),
        sender: 'sender'),
    Chats(
        body: 'jane likes u',
        when: DateTime.utc(2008, 1, 20, 18, 23),
        sender: 'sender'),
    Chats(
        body: 'dont hurt her',
        when: DateTime.utc(2008, 1, 20, 18, 23),
        sender: 'sender'),
    Chats(
        body: 'whaaat!',
        when: DateTime.utc(2008, 1, 20, 18, 23),
        sender: 'reciever'),
    Chats(
        body: 'u joking me ryt nw!!',
        when: DateTime.utc(2008, 1, 20, 18, 23),
        sender: 'reciever'),
    Chats(
        body: 'go away now',
        when: DateTime.utc(2008, 1, 20, 18, 23),
        sender: 'reciever'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Conversation conversation =
        Provider.of<MessageManager>(context, listen: false).conversation!;
    // getMessages(conversationId: conversation.id).then((value) => print(value));
    _future = getMessages(conversationId: conversation.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MessageManager manager =
        Provider.of<MessageManager>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                manager.clear();
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          title: Text('messages'),
        ),
        body: Column(children: [
          Expanded(
              flex: 9,
              child: FutureBuilder<List<Message>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('${snapshot.data}');
                    } else if (snapshot.hasData) {
                      List<Message> m = snapshot.data!;
                      return StreamBuilder(
                          initialData: m,
                          stream: _stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 5),
                                  child: Consumer<MessageManager>(
                                      builder: (context, value, child) {
                                    return Column(
                                      children: buildList(
                                          m,
                                          Provider.of<ProfileManager>(context,
                                                  listen: false)
                                              .user!
                                              .id),
                                    );
                                  }));
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.data}');
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          });
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })),
          Expanded(
              child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
                hintText: 'Enter here',
                suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: (() {
                      /*sendMessage(
                              context: context,
                              from: Provider.of<ProfileManager>(context,
                                      listen: false)
                                  .user!
                                  .id,
                              to: manager.recipient,
                              body: _controller.text,
                              conversationId: manager.conversation != null
                                  ? manager.conversation!.id
                                  : 'null')
                          .then((value) {
                        // manager.update(value);
                        manager =
                            Provider.of<MessageManager>(context, listen: false);
                       
                      });*/
                      widget.channel.sink.add(jsonEncode({
                        "event": "sendMessage",
                        "message": {
                          "conversationId": manager.conversation != null
                              ? manager.conversation!.id
                              : 'null',
                          "senderId": Provider.of<ProfileManager>(context,
                                  listen: false)
                              .user!
                              .id,
                          "recipientID": manager.recipient,
                          "body": _controller.text,
                        }
                      }));
                      //  setState(() {});
                    })),
                border: OutlineInputBorder()),
          ))
        ]));
  }

  List<Widget> buildList(List<Message> chats, String userId) {
    List<Widget> children = [];
    for (int i = 0; i < chats.length; i++) {
      String body = chats[i].body;
      chats[i].update();
      children.add(Align(
        alignment: chats[i].recieverOrSender(userId) == 'sender'
            ? Alignment.topRight
            : Alignment.topLeft,
        child: Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.all(15),
            child: Text(
              body,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            )),
      ));
    }
    return children;
  }
}
