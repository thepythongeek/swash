import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swash/object/change_password.dart';

Future<ChangePassword> createChangePassword(String userId, String password) async {
  final response = await http.post(
    Uri.parse('http://trueapps.org/swash/apis/change_password.php'),
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    encoding: Encoding.getByName('utf-8'),
    body: { "user_id": userId, "password": password }
  );

  if (response.statusCode == 201) {
    return ChangePassword.fromJson(jsonDecode(response.body));
  } else { throw Exception('Failed to change password.'); }
}

class Recovery extends StatelessWidget {
  const Recovery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'swash',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Recover Password'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(
                Icons.loop,
                color: Colors.blue,
                size: 100,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  margin: const EdgeInsets.only(bottom: 60.0),
                  child: const Text(
                    'Enter email address associated with your SWASH account',
                    softWrap: true, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),
                  )),
              Form(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter email',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35)))),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(const EdgeInsets.only(
                                top: 20, right: 140, left: 140, bottom: 20)),
                            shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(35)))),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey[400])),
                        onPressed: null,
                        child: const Text('check', style: TextStyle(color: Colors.black))),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
