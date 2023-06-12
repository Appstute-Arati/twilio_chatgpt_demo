import 'package:flutter/material.dart';

class DialogWithEditText extends StatefulWidget {
  final Function onPressed;

  const DialogWithEditText({
    super.key,
    required this.onPressed,
  });

  @override
  _DialogWithEditTextState createState() => _DialogWithEditTextState();
}

class _DialogWithEditTextState extends State<DialogWithEditText> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Text'),
      content: TextField(
        controller: _textFieldController,
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () {
            String enteredText = _textFieldController.text;
            // Do something with the entered text
            widget.onPressed(enteredText);
          },
        ),
      ],
    );
  }
}
