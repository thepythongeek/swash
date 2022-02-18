import 'package:swash/components/components.dart';
import 'package:swash/components/loading_button.dart';

import 'auth.dart';
import 'dart:async';
import 'dart:convert';
import 'package:swash/path.dart';
import 'package:swash/toasty.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swash/Screens/Ward/dashboard.dart';
import 'package:swash/Screens/School/dashboard.dart' as school;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'auth.dart';
import '../../models/models.dart';
import '../../object/get_profile.dart';

Future<dynamic> postSignin(String email, String password, String domain) async {
  var response = await http.post(
    Uri.parse('$domain/signin.php'),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    encoding: Encoding.getByName('utf-8'),
    body: {
      "email": email,
      "password": password,
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    Toasty().show("Failed to signin", Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
  }
}

class LoginPage extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
        key: ValueKey(MyPages.login),
        name: MyPages.login,
        child: const LoginPage());
  }

  const LoginPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var domain;
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    final ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    var platform = Theme.of(context).platform;
    TextEditingController userNameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
        appBar: AppBar(title: const Text('Sign In')),
        body: ListView(children: [
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35)),
                      labelText: 'Enter email or phone ',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter valid email or password";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: PasswordField(passwordController: passwordController),
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: LoadingButton(
                    function: () async {
                      if (_formKey.currentState!.validate()) {
                        var _response = await postSignin(
                            userNameController.text,
                            passwordController.text,
                            AppPath.domain);

                        if (_response['success']) {
                          // add a user
                          profileManager.addUser(User(
                              id: _response['message']['user_id'],
                              role: _response['message']['role']));
                          // login user
                          profileManager.loginUser();

                          // get user profile if he has one

                          var value = await getProfile(
                              _response['message']['user_id'], "null");

                          profileManager.updateprofile(value.profile);
                          print(profileManager.user!.profile!.name);

                          // store the user id and role
                          FlutterSecureStorage storage = FlutterSecureStorage();
                          storage.write(
                            key: 'id',
                            value: _response['message']['user_id'],
                          );
                          storage.write(
                              key: 'role', value: _response['message']['role']);

                          switch (_response['message']['role']) {
                            case "ward":
                              appStateManager.goto(MyPages.ward, true);
                              break;
                            case "voter":
                            case "admin":
                              appStateManager.goto(MyPages.voter, true);
                              appStateManager.goto(MyPages.login, false);

                              break;
                            case "teacher":
                              appStateManager.goto(MyPages.school, true);
                              break;
                          }
                        } else {
                          Toasty().show(_response['message'],
                              Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
                        }
                      }
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //TODO FORGOT PASSWORD SCREEN GOES HERE
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Recovery()));
                  },
                  child: const Text(
                    'Forgot Password? Help',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 130,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserRegister()));
                  },
                  child: const Text('Don`t have an Account? Register'),
                ),
              ],
            ),
          ),
        ]));
  }
}
