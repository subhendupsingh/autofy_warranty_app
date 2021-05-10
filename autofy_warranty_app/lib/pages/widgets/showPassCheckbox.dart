import 'package:flutter/material.dart';

class GetShowPassWidget extends StatelessWidget {
  final bool isVisible;
  final void Function(bool?) onChanged;
  GetShowPassWidget({required this.isVisible, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      dense: true,
      value: isVisible,
      onChanged: onChanged,
      title: Text("Show Password"),
      contentPadding: EdgeInsets.all(0),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
