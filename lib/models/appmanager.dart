import 'package:geolocator/geolocator.dart';
import 'package:swash/Screens/School/dashboard.dart';
import 'package:swash/Screens/community/dashboard.dart';
import 'package:swash/Screens/redirect.dart';
import 'package:swash/models/models.dart';

import 'package:flutter/material.dart';
import 'package:swash/models/prize.dart';
import 'package:web_socket_channel/io.dart';
import '../Screens/front_page.dart';
import '../Screens/auth/login_form.dart';
import '../Screens/auth/signin.dart';

class AppStateManager extends ChangeNotifier {
  final NavigationState _navigationState = NavigationState();
  Prize? _prize;
  int _currentTab = 0;

  bool _showComments = false;
  bool _isInitialised = false;
  int get currentTab => _currentTab;
  Position? _position;
  int? _expiringDuration;
  DateTime? _date;
  Prize? get prize => _prize;
  IOWebSocketChannel? _channel;
  Stream<dynamic>? _channelStream;

  IOWebSocketChannel? get channel => _channel;
  Stream<dynamic>? get channelStream => _channelStream;

  // an array of initial routes
  List<MaterialPage> pages = [FrontPage.page()];

  DateTime? get date => _date;

  bool get showComments => _showComments;
  bool get isInitialised => _isInitialised;
  Position? get position => _position;
  int? get duration => _expiringDuration;

  NavigationState get navigation => _navigationState;

  void toTab(int index) {
    _currentTab = index;
  }

  void addPrize(Prize value) {
    _prize = value;
  }

  void addStream(IOWebSocketChannel channel, Stream<dynamic> stream) {
    _channel = channel;
    _channelStream = stream;
  }

  void toComments(bool value) {
    _showComments = value;
    notifyListeners();
  }

  void addDuration(int value) {
    _expiringDuration = value;
  }

  void initiliase() {
    _isInitialised = true;
    notifyListeners();
  }

  void addDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  void goto(String route, bool value) {
    _navigationState.goto(route, value);

    notifyListeners();
  }

  void push(MaterialPage page) {
    pages.add(page);
    print(111);
    print(pages);
    notifyListeners();
  }

  void pop() {
    pages.removeLast();
    notifyListeners();
  }

  void to(MaterialPage page) {
    pages.takeWhile((item) => item != page);
    notifyListeners();
  }

  void addPosition(Position position) {
    _position = position;
    notifyListeners();
  }
}

class NavigationState {
  bool _home = true;
  bool _login = false;
  bool _school = false;
  bool _redirect = false;
  bool _voter = false;
  bool _community = false;
  bool _schoolForm = false;
  bool _challenge = false;
  bool _envDetails = false;
  bool _ward = false;
  bool _survey = false;
  bool _register = false;
  bool _eventform = false;
  bool _comment = false;

  bool get home => _home;
  bool get comment => _comment;
  bool get toeventform => _eventform;
  bool get login => _login;
  bool get school => _school;
  bool get schoolForm => _schoolForm;
  bool get redirect => _redirect;
  bool get register => _register;
  bool get voter => _voter;
  bool get community => _community;
  bool get challenge => _challenge;
  bool get envDetails => _envDetails;
  bool get ward => _ward;
  bool get survey => _survey;

  void goto(String route, bool value) {
    switchRoutes(route, value);
  }

  void switchRoutes(String route, value) {
    switch (route) {
      case MyPages.home:
        _home = value;
        break;
      case MyPages.login:
        _login = value;
        break;
      case MyPages.register:
        _register = value;
        break;
      case MyPages.redirect:
        print(_redirect);
        _redirect = value;
        break;
      case MyPages.ward:
        _ward = value;
        break;
      case MyPages.school:
        _school = value;
        break;
      case MyPages.schoolForm:
        _schoolForm = value;
        break;
      case MyPages.voter:
        _voter = value;
        break;
      case MyPages.challenge:
        _challenge = value;
        break;
      case MyPages.envDetails:
        _envDetails = value;
        break;
      case MyPages.community:
        _community = value;
        break;
      case MyPages.survey:
        _survey = value;
        break;
      case MyPages.eventform:
        _eventform = value;
        break;
      case MyPages.comments:
        _comment = value;
    }
  }
}

class ProfileManager extends ChangeNotifier {
  User? _user;

  bool _isLoggedIn = false;
  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  void updateprofile(Profile profile) {
    _user!.profile = profile;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
  }

  void addUser(User user) {
    _user = user;
    notifyListeners();
  }

  void loginUser() {
    _isLoggedIn = true;
    notifyListeners();
  }
}
