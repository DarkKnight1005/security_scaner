import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:security_scaner/wrapper.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_proxy/shelf_proxy.dart';
import 'package:desktop_window/desktop_window.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //await DesktopWindow.setMinWindowSize(Size(600,800));
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