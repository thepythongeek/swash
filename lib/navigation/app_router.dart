import 'package:flutter/material.dart';
import 'package:swash/Screens/School/dashboard.dart';
import 'package:swash/Screens/Ward/dashboard.dart';
import 'package:swash/Screens/Ward/school.dart';
import 'package:swash/Screens/auth/auth.dart';
import 'package:swash/Screens/splash_screen.dart';
import 'package:swash/Screens/voter/addevent.dart';
import 'package:swash/components/challengedetail.dart';
import 'package:swash/Screens/community/dashboard.dart';
import 'package:swash/Screens/community/environmentdetails.dart';
import 'package:swash/Screens/front_page.dart';
import 'package:swash/Screens/redirect.dart';
import 'package:swash/Screens/voter/home.dart' as voter;
import 'package:swash/Screens/School/school.dart' as school;
import 'package:swash/models/themes.dart';
import '../models/models.dart';
import '../components/components.dart';

class RouteManager extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final AppStateManager appStateManager;
  final Postmanager postmanager;
  final ThemeManager themeManager;
  final FileManager fileManager;
  final CommentManager commentManager;
  final ProfileManager profileManager;
  static List roles = ['admin', 'voter'];
  @override
  GlobalKey<NavigatorState> navigatorKey;

  RouteManager(
      {Key? key,
      required this.fileManager,
      required this.profileManager,
      required this.appStateManager,
      required this.postmanager,
      required this.commentManager,
      required this.themeManager})
      : navigatorKey = GlobalKey<NavigatorState>() {
    fileManager.addListener(notifyListeners);
    appStateManager.addListener(notifyListeners);
    postmanager.addListener(notifyListeners);
    themeManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  @override
  Future<void> setNewRoutePath(configuration) async {}

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        onPopPage: (route, results) {
          if (!route.didPop(results)) {
            return false;
          }
          if (route.settings.name == MyPages.challenge) {
            appStateManager.goto(MyPages.challenge, false);
            // appStateManager.goto(MyPages.voter, true);
          }
          if (route.settings.name == MyPages.login) {
            appStateManager.goto(MyPages.login, false);
          }
          if (route.settings.name == MyPages.voter) {
            appStateManager.goto(MyPages.voter, false);
          }
          if (route.settings.name == MyPages.redirect) {
            appStateManager.goto(MyPages.redirect, false);
          }
          if (route.settings.name == MyPages.community) {
            appStateManager.goto(MyPages.community, false);
          }
          if (route.settings.name == MyPages.schoolForm) {
            appStateManager.goto(MyPages.schoolForm, false);
          }
          if (route.settings.name == MyPages.eventform) {
            fileManager.reset();
            appStateManager.goto(MyPages.eventform, false);
          }
          if (route.settings.name == MyPages.comments) {
            commentManager.reset();
            appStateManager.goto(MyPages.comments, false);
          }
          if (route.settings.name == MyPages.register) {
            appStateManager.goto(MyPages.register, false);
          }
          if (route.settings.name == MyPages.school) {
            appStateManager.goto(MyPages.school, false);
          }
          if (route.settings.name == MyPages.envDetails) {
            appStateManager.goto(MyPages.envDetails, false);
          }
          return true;
        },
        pages: [
          if (!appStateManager.isInitialised) SplashScreen.page(),
          if (appStateManager.navigation.home &&
              !profileManager.isLoggedIn &&
              appStateManager.isInitialised)
            FrontPage.page(),
          if (appStateManager.navigation.register) UserRegister.page(),
          if (appStateManager.navigation.redirect &&
              profileManager.user != null &&
              roles.contains(profileManager.user!.role))
            Dashboard.page(),
          if (appStateManager.navigation.voter &&
              profileManager.user != null &&
              roles.contains(profileManager.user!.role))
            voter.Voter.page(),
          if (appStateManager.navigation.login && !profileManager.isLoggedIn)
            LoginPage.page(),
          if (appStateManager.navigation.community &&
              profileManager.user != null &&
              roles.contains(profileManager.user!.role))
            Community.page(),

          if (appStateManager.navigation.envDetails &&
              profileManager.user != null &&
              roles.contains(profileManager.user!.role))
            EnvironmentDetails.page(),
          if (appStateManager.navigation.school &&
              profileManager.user != null &&
              profileManager.user!.role == 'teacher')
            School.page(),
          if (appStateManager.navigation.ward &&
              profileManager.user != null &&
              profileManager.user!.role == 'ward')
            Ward.page(),
          if (appStateManager.navigation.toeventform &&
              profileManager.user != null //&&
          // roles.contains(profileManager.user!.role)
          )
            EventForm.page(),
          // if (appStateManager.navigation.survey) Survey.page(),
          if (appStateManager.navigation.schoolForm)
            school.SchoolForm.page(postmanager.getPost),
          if (appStateManager.navigation.challenge) ChallengeDetail.page(),
          if (appStateManager.showComments && commentManager.postId != null)
            DraggableComments.page(commentManager.postId!)
        ]
        //pages: appStateManager.pages,
        );
  }
}
