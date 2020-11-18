import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:security_scaner/wrapper.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_proxy/shelf_proxy.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SecurityScanner());
}

class SecurityScanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: Wrapper(),
    );
  }
}