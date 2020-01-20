import 'file:///C:/Users/Lenovo/Documents/admin_app/lib/utils/prefs.dart';
import 'package:flutter/material.dart';

class TandC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Prefs().retIOS() ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.white),
        ),
        title: Text('Terms and Conditions',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor:  Color(0xFF78EC6C),
      ),
    );
  }
}
