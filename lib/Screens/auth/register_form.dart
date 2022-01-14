import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swash/models/models.dart';
import 'package:swash/object/register.dart';
import 'package:provider/provider.dart';
import '../../exceptions/network.dart';
import '../../object/get_profile.dart';

class UserRegister extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        key: ValueKey(MyPages.register),
        name: MyPages.register,
        child: UserRegister());
  }

  const UserRegister({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController locationcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController schoolcontroller = TextEditingController();

  @override
  void dispose() {
    phonecontroller.dispose();
    emailcontroller.dispose();
    namecontroller.dispose();
    locationcontroller.dispose();
    phonecontroller.dispose();
    schoolcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: ListView(children: [
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10.0),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Registration',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Basic Information',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (str) {
                      if (str == null || str.isEmpty) {
                        return 'Field cannot be empty';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    controller: namecontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35)),
                      labelText: 'Full Name',
                    ),
                  ),
                ),
                //phone number
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (str) {
                      if (str == null || str.isEmpty) {
                        return 'Field cannot be empty';
                      }
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(str)) {
                        return 'Invalid phone number';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    controller: phonecontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35)),
                      labelText: 'Phone number',
                    ),
                  ),
                ),
                // email
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (str) {
                      if (str == null || str.isEmpty) {
                        return 'Field cannot be empty';
                      }
                      if (!str.contains('@')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35)),
                      labelText: 'Email',
                    ),
                  ),
                ),
                // school
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (str) {
                      if (str == null || str.isEmpty) {
                        return 'Field cannot be empty';
                      }

                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    controller: schoolcontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35)),
                      labelText: 'Name of your primary school',
                    ),
                  ),
                ),
                //address
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (str) {
                      if (str == null || str.isEmpty) {
                        return 'Field cannot be empty';
                      }

                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    controller: locationcontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35)),
                      labelText: 'street address',
                    ),
                  ),
                ),
                //password
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (str) {
                      if (str == null || str.isEmpty) {
                        return 'Field cannot be empty';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35)),
                      labelText: ' Password',
                      suffixIcon: IconButton(
                        icon: isPasswordVisible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        onPressed: () => setState(
                            () => isPasswordVisible = !isPasswordVisible),
                      ),
                    ),
                    obscureText: isPasswordVisible,
                  ),
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () {
                      register(
                              phone: phonecontroller.text,
                              email: emailcontroller.text,
                              location: locationcontroller.text,
                              password: passwordcontroller.text,
                              fullName: namecontroller.text,
                              schoolName: schoolcontroller.text)
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Usajili umefanikiwa')));
                        // add user to the app state
                        Provider.of<ProfileManager>(context, listen: false)
                            .addUser(User(
                                role: value.role, id: value.userId.toString()));

                        /*getProfile(value.roleId, "null").then((value) {
                          Provider.of<AppStateManager>(context, listen: false)
                              .updateprofile(value.profile);
                          print(Provider.of<AppStateManager>(context,
                                  listen: false)
                              .user
                              .profile!
                              .name);
                          
                        });*/
                        Provider.of<AppStateManager>(context, listen: false)
                            .goto(MyPages.redirect, true);
                      });
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 130,
                )
              ],
            ),
          ),
        ]));
  }
}
