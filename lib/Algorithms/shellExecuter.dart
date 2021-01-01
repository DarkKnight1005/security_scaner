import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:process_run/shell.dart';
import 'package:flutter/services.dart';
import 'dart:io';

var shell_node = Shell();
var shell = Shell();
//AssetBundle().loadS

Future<String> _loadAsset(String strPath) async {
  return await rootBundle.loadString(strPath);
}

class ShellExecuter {
  Future<void> startServer() async {
    //String strPath = await _loadAsset("sh Scripts/proxy_node_start.sh");
    
    shell_node.run("sh ${Directory.current.path}/Scripts/proxy_node_start.sh");
  }

  Future<void> stopServer() async {
    //String strPath = await _loadAsset("sh Scripts/proxy_node_start.sh");
    await shell.run("sh ${Directory.current.path}/scripts/proxy_node_stop.sh");
  }

  Future<void> connectToProxy() async {
    //String strPath = await _loadAsset("sh Scripts/proxy_node_start.sh");
    await shell.run("sh ${Directory.current.path}/scripts/proxy_setup.sh");
  }

  Future<void> disconnectFromProxy() async {
    //String strPath = await _loadAsset("sh Scripts/proxy_node_star.sh");
    await shell.run("sh ${Directory.current.path}/scripts/proxy_off_system.sh");
  }

  Future<bool> checkIsServerUp() async{
    bool isUp = false;
    await shell.run("sh ${Directory.current.path}/scripts/check_is_server_up.sh")
    .then((value) { 
      int count = int.parse(value.outText);
      if(count >= 1){
        isUp = true;
      }else{
        isUp = false;
      }
      });
      return isUp;
  }

  Future<String> getLocalIPAdress() async {
    //String strPath = await _loadAsset("sh Scripts/proxy_node_star.sh");
    String _localIPAdsress;
    await shell.run("sh ${Directory.current.path}/scripts/grep_IP_address.sh").then((value) => _localIPAdsress = value.outText);
    return _localIPAdsress;
  }


  Future<void> testFunc() async {
    // await rootBundle.loadStructuredData("Scripts/proxy_node_stop.sh", (value) async{
    //   //print(value);
    //   String str = value;
    //   await shell.run(str);
    // });
    //print(some);
  }
}