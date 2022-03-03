import 'package:flutter/material.dart';

class MegaSenaContainer extends StatelessWidget {

  final Widget child;

  MegaSenaContainer({ required this.child });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: child,
    );
  }
}
