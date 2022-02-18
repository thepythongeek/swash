import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController passwordController;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hide = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _hide,
      controller: widget.passwordController,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(_hide ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _hide = !_hide;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(35)),
        labelText: 'Enter a password',
      ),
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 4) {
          return "Password with at least 4 character is allowed";
        }
        return null;
      },
    );
  }
}
