import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swash/Screens/School/dashboard.dart';
import 'package:swash/exceptions/network.dart';
import 'package:swash/models/appmanager.dart';
import 'package:swash/object/add_school.dart';
import 'package:swash/utility/location.dart';

class SchoolRegister extends StatefulWidget {
  const SchoolRegister({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SchoolRegisterState();
}

class _SchoolRegisterState extends State<SchoolRegister> {
  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController radius = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    email.dispose();
    location.dispose();
    radius.dispose();
    address.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
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
                    controller: name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35)),
                      labelText: 'Full Name',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35)),
                      labelText: 'Phone number',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35)),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Consumer<AppStateManager>(
                      builder: (context, manager, child) {
                    return TextFormField(
                      controller: TextEditingController(
                          text: manager.position != null
                              ? manager.position.toString()
                              : ''),
                      readOnly: true,
                      onTap: () async {
                        getLocation().then((value) {
                          manager.addPosition(value);
                        }).catchError(
                          (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$error')));
                          },
                          test: (error) => error is LocationError,
                        );
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35)),
                        labelText: 'Location Address',
                      ),
                    );
                  }),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: radius,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35)),
                      labelText: 'Radius in km',
                      // errorText: 'Password is wrong',
                    ),
                    obscureText: isPasswordVisible,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: address,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35)),
                      labelText: 'Postal address',
                      // errorText: 'Password is not match',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35)),
                      labelText: 'Password',
                      // errorText: 'Password is not match',
                      suffixIcon: IconButton(
                        icon: isPasswordVisible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        onPressed: () => setState(
                            () => isPasswordVisible = !isPasswordVisible),
                      ),
                    ),
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
                      if (_formKey.currentState!.validate()) {
                        String lattitude =
                            Provider.of<AppStateManager>(context, listen: false)
                                .position!
                                .latitude
                                .toString();
                        String longitude =
                            Provider.of<AppStateManager>(context, listen: false)
                                .position!
                                .longitude
                                .toString();
                        addSchool(
                                name: name.text,
                                phone: phone.text,
                                email: email.text,
                                radius: radius.text,
                                password: password.text,
                                lattitude: lattitude,
                                addr: address.text,
                                longitude: longitude)
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 3),
                              content: Text(value)));
                        }).catchError(
                          (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$error')));
                          },
                          test: (error) => error is NetworkError,
                        );
                      }
                      /* Navigator.push(context,
                          MaterialPageRoute(builder: (context) => School()));*/
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
        ));
  }
}
