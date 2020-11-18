import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:process_run/shell.dart';

var shell_node = Shell();
var shell = Shell();

class ShellExecuter {
  Future<void> startServer() async {
    shell_node.run("sh Scripts/proxy_node_start.sh");
  }

  Future<void> stopServer() async {
    shell.run("sh Scripts/proxy_node_stop.sh");
  }

  Future<void> connectToProxy() async {
    shell.run("sh Scripts/proxy_setup.sh");
  }

  Future<void> disconnectFromProxy() async {
    shell.run("sh Scripts/proxy_off_system.sh");
  }
}