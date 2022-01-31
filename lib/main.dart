import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
// import 'package:swash/Screens/Chat/chartscreen.dart';
// import 'package:swash/Screens/School/dashboard.dart';
import 'package:swash/Screens/front_page.dart';
import 'package:swash/models/appmanager.dart';
import 'package:swash/models/competition_manager.dart';
import 'package:swash/models/message_manager.dart';
import 'package:swash/models/models.dart';
import 'package:swash/models/themes.dart';
import 'package:swash/navigation/app_router.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'path.dart';
// import 'Screens/community/challengedetail.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final RouteManager routeManager;

  final FileManager fileManager = FileManager();
  final AppStateManager appStateManager = AppStateManager();
  final Postmanager postmanager = Postmanager();
  final ThemeManager themeManager = ThemeManager();
  final CommentManager commentManager = CommentManager();
  final ProfileManager profileManager = ProfileManager();
  late IOWebSocketChannel channel;
  late Stream<dynamic> channelStream;

  @override
  void initState() {
    routeManager = RouteManager(
        commentManager: commentManager,
        profileManager: profileManager,
        appStateManager: appStateManager,
        fileManager: fileManager,
        postmanager: postmanager,
        themeManager: themeManager);
    channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.1.191:8080'));
    //'ws://www.swashcompetition.com:8080'));
    channelStream = channel.stream.asBroadcastStream();
    appStateManager.addStream(channel, channelStream);
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => appStateManager),
        ChangeNotifierProvider(create: (context) => profileManager),
        ChangeNotifierProvider(create: (context) => fileManager),
        ChangeNotifierProvider(create: (context) => CompetitionManager()),
        ChangeNotifierProvider(create: (context) => MessageManager()),
        ChangeNotifierProvider(create: (context) => ConversationList()),
        ChangeNotifierProvider(
          create: (context) => postmanager,
        ),
        ChangeNotifierProvider(create: (context) => themeManager),
        ChangeNotifierProvider(create: (context) => commentManager),
        ChangeNotifierProvider(create: (context) => EnvironmentManager())
      ],
      child: MaterialApp(
        restorationScopeId: 'asasfdsfsd',
        title: 'Swash',
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: const [Locale('en', ''), Locale('sw', '')],
        theme: ThemeData(
            // This is the theme of your application.

            primarySwatch: Colors.blue,
            brightness: Brightness.light),
        home: Router(
          routerDelegate: routeManager,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
