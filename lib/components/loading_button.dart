import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final Future<void> Function()? function;
  final ButtonStyle? style;
  final Widget child;
  const LoadingButton(
      {Key? key, this.function, this.style, required this.child})
      : super(key: key);

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: !_loading
            ? () async {
                setState(() {
                  _loading = true;
                });

                await widget.function!();

                setState(() {
                  _loading = false;
                });
              }
            : null,
        style: widget.style, //widget.style,
        child: !_loading
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: widget.child,
              )
            : const CircularProgressIndicator(
                backgroundColor: Colors.white,
              ));
  }
}
