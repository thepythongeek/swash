import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:provider/provider.dart';
import 'package:swash/Screens/Chat/chatlist.dart' as c;
import 'package:swash/models/message_manager.dart';
import 'package:swash/object/get_messages.dart';

import '../../models/models.dart';

class ChatArea extends StatefulWidget {
  const ChatArea({Key? key}) : super(key: key);

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  final TextEditingController _controller = TextEditingController();
  late Future<List<Message>> _future;
  List<Message>? messages;
  Stream? _stream;
  bool update = false;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

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
    AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    return Theme(
      data: c.ChatTheme.dark(),
      child: Scaffold(
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
                        messages = m;

                        return Consumer<MessageManager>(
                            builder: (context, value, child) {
                          return update
                              ? StreamBuilder<dynamic>(
                                  stream: appStateManager.channelStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      print('|||###>>>??**');
                                      Map<String, dynamic> data =
                                          jsonDecode(snapshot.data);

                                      print(data);
                                      if (data['event'] == 'sendMessage') {
                                        // update with current messages
                                        List<Message> newMessages = [];
                                        print('mambooo');
                                        print(data['message']);
                                        for (Map i in data['message']
                                            ['messages']) {
                                          newMessages.add(Message.fromjson(i));
                                        }
                                        messages!.addAll(newMessages);
                                      }
                                      return buildScrollingMessageBubble();
                                    } else {
                                      return Text(snapshot.data.toString());
                                    }
                                  })
                              : buildScrollingMessageBubble();
                        });
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })),
            Expanded(
                child: TextFormField(
              textInputAction: TextInputAction.done,
              onTap: () {
                scrollTo();
              },
              controller: _controller,
              decoration: InputDecoration(
                  hintText: 'Enter here',
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: (() {
                        //scrollTo();
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
                        print(manager.recipient);
                        print(
                            Provider.of<ProfileManager>(context, listen: false)
                                .user!
                                .id);
                        print(manager.conversation?.id);
                        appStateManager.channel!.sink.add(jsonEncode({
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
                        setState(() {
                          update = true;
                          _controller.clear();
                        });
                        /* widget.channel.stream.listen((event) {
                          print('*******');
                          Map<String, dynamic> data =
                              jsonDecode(event['message']);
                          print(data);
                          // update with current messages
                          List<Message> newMessages = [];
                          for (Map i in data['message']['messages']) {
                            newMessages.add(Message.fromjson(i));
                          }
                          messages!.addAll(newMessages);
                          print(messages![messages!.length]);
                        });*/

                        //   setState(() {});
                      })),
                  border: OutlineInputBorder()),
            ))
          ])),
    );
  }

  Future<void> scrollTo() {
    return itemScrollController.scrollTo(
        index: messages!.length - 1,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOutCubic);
  }

  ScrollablePositionedList buildScrollingMessageBubble() {
    return ScrollablePositionedList.builder(
        itemPositionsListener: itemPositionsListener,
        itemScrollController: itemScrollController,
        itemCount: messages!.length,
        itemBuilder: (context, index) {
          return showMessageBubble(index, context);
        });
  }

  Align showMessageBubble(int index, BuildContext context) {
    messages![index].update();
    return Align(
      alignment: messages![index].recieverOrSender(
                  Provider.of<ProfileManager>(context, listen: false)
                      .user!
                      .id) ==
              'sender'
          ? Alignment.topRight
          : Alignment.topLeft,
      child: Container(
          margin: const EdgeInsets.only(top: 5, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(15),
          child: Text(
            messages![index].body,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          )),
    );
  }

  Column chatBody(List<Message> m, BuildContext context) {
    return Column(
      children: buildList(
          m, Provider.of<ProfileManager>(context, listen: false).user!.id),
    );
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
