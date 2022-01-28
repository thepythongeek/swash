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
import 'path.dart';
// import 'Screens/community/challengedetail.dart';

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

  @override
  void initState() {
    routeManager = RouteManager(
        commentManager: commentManager,
        profileManager: profileManager,
        appStateManager: appStateManager,
        fileManager: fileManager,
        postmanager: postmanager,
        themeManager: themeManager);

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
        title: 'Swapp',
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
