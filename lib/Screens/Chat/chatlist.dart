import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:swash/Screens/Chat/chartscreen.dart';
import 'package:swash/components/search_people.dart';
import 'package:swash/models/message_manager.dart';
import 'package:swash/object/send_chat.dart';
import 'package:web_socket_channel/io.dart';
import '../../models/models.dart' as m;
import '../../path.dart';

class ChatList extends StatefulWidget {
  final String userId;
  const ChatList({Key? key, required this.userId}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
//late Future<List<m.Conversation>> conversations;
  List<m.Conversation>? conversation;
  late IOWebSocketChannel channel;
  late Stream<dynamic> channelStream;

  @override
  void initState() {
    // conversations = getConversations(
    //    userId: Provider.of<m.ProfileManager>(context, listen: false).user!.id);
    channel = IOWebSocketChannel.connect(
        Uri.parse('ws://www.swashcompetition.com:8080'));
    // attempt to use 'register' event
    channel.sink
        .add(jsonEncode({"event": "register", "user_id": widget.userId}));
    // attempt to use 'connect' event
    channel.sink
        .add(jsonEncode({"event": "connect", "user_id": widget.userId}));

//channel = channel.changeStream((p0) => p0.asBroadcastStream());
    channelStream = channel.stream.asBroadcastStream();
    channelStream.listen((event) {
      //channel.sink.add('helooo from dart');
      print(event);
      print('11');
    });
    Provider.of<m.AppStateManager>(context, listen: false)
        .addStream(channel, channelStream);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ChatTheme.dark(),
        home: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await showSearch(
                    useRootNavigator: true,
                    context: context,
                    delegate: CustomSearch(hinttext: 'Search people'));
              },
              child: const Icon(Icons.message_outlined),
            ),
            appBar: AppBar(
              title: Row(
                children: [
                  const Text('Swash'),
                  const Spacer(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search))
                ],
              ),
            ),
            body: Padding(
                padding: const EdgeInsets.all(8),
                child: StreamBuilder<dynamic>(
                    stream: channelStream,
                    builder: (context, snapshot) {
                      List<m.Conversation> c = [];
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('${snapshot.data}'),
                        );
                      } else if (snapshot.hasData) {
                        print(snapshot.data!);
                        Map<String, dynamic> data = jsonDecode(snapshot.data!);
                        // determine event
                        if (data['event'] == 'sendMessage') {
                          // attempt to use 'connect' event
                          channel.sink.add(jsonEncode(
                              {"event": "connect", "user_id": widget.userId}));
                        } else if (data['event'] == 'connect') {
                          print('got uuuu');
                          print(data);
                          for (Map i in data['message']) {
                            c.add(m.Conversation.fromjson(i));
                          }
                          print(c is List<m.Conversation>);
                          conversation = c;
                        }

                        return ListView.builder(
                            itemCount: conversation!.length,
                            itemBuilder: (context, index) => Conversation(
                                  currentUserId: widget.userId,
                                  conversation: conversation![index],
                                ));
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }))));
  }
}

class Conversation extends StatefulWidget {
  final m.Conversation conversation;
  final String currentUserId;
  const Conversation({
    Key? key,
    required this.conversation,
    required this.currentUserId,
  }) : super(key: key);

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  @override
  Widget build(BuildContext context) {
    m.AppStateManager appStateManager =
        Provider.of<m.AppStateManager>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Provider.of<MessageManager>(context, listen: false)
            .add(widget.conversation);
        Provider.of<MessageManager>(context, listen: false)
            .addRecipient(getContactId());

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatArea()));
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 30,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getContact(),
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.conversation.message?.body ?? '',
                  // style: theme.textTheme.bodyText1,
                )
              ],
            ),
            const Spacer(),
            Text(
              '${DateTime.parse(widget.conversation.message?.createdAt ?? '2022-01-01T11:00').year}',
              // style: theme.textTheme.bodyText1,
            )
          ],
        ),
      ),
    );
  }

  String getContact() {
    // determine who is the contact in a conversation
    if (widget.conversation.userId1 == widget.currentUserId) {
      return widget.conversation.username2;
    }
    return widget.conversation.username;
  }

  String getContactId() {
    // determine who is the contact in a conversation
    if (widget.conversation.userId1 == widget.currentUserId) {
      return widget.conversation.userId2;
    }
    return widget.conversation.userId1;
  }
}

class ChatTheme {
  static TextTheme darkTheme = TextTheme(
    bodyText1: GoogleFonts.acme(
        color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w700),
    headline1: GoogleFonts.openSans(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline2: GoogleFonts.openSans(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline3: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headline6: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.green,
      ),
      textTheme: darkTheme,
    );
  }
}
