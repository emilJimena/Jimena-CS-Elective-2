import 'package:cs_elective_2/pages/InheritedWidget.dart';
import 'package:flutter/material.dart';

class MiddleWidget extends StatelessWidget {
  const MiddleWidget({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return const ThemedButton();
  }
}
 
class ThemedButton extends StatelessWidget {
  const ThemedButton({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
 
    return ElevatedButton(
      onPressed: themeProvider?.toggleTheme,
      child: Text(
        'Current: ${themeProvider?.themeMode == ThemeMode.light ? "Light" : "Dark"}',
      ),
    );
  }
}
 