import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proxy/flutter_proxy.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:security_scaner/Algorithms/handler.dart';
import 'package:security_scaner/Algorithms/shellExecuter.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String url = 'http://localhost:9010';
  http.Response response;
  //String responseBody = '';
  List<String> responseBodyList = new List();
  bool isRestarted = true;
  List<Color> col_text = new List();
  List<Color> col_indicator = new List();
  String filter = 'ALL';
  bool isButtonPressed = false;
  Map<String, int> count_section = {"POST" : 0, "GET" : 0, "OPTIONS" : 0, "ALL" : 0};
  bool isProccessing = false;
  bool isConnected = false;
  
  var state = FlutterVpnState.disconnected;
  var charonState = CharonErrorState.NO_ERROR;
  ScrollController _scrollController;

  // String vpn_host = 'localhost';
  // String vpn_port = '8090';

  @override
  void initState(){
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollJump);
    checkIsServerUp();
    //_scrollController.addListener(_scrollCurve);
    FlutterVpn.prepare();
    FlutterVpn.onStateChanged.listen((s) => setState(() => state = s));
    super.initState();
  }

  @override
  void dispose() { 
    _scrollController.dispose();
    super.dispose();
  }


  _scrollJump() {
    if(isButtonPressed){
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    setState(() {
      isButtonPressed = false;
    });
    }
  }

 _scrollCurve(){
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
 }

  Future<void> checkIsServerUp() async{
    isConnected = await ShellExecuter().checkIsServerUp();
    setState(() {
    });
  }

  bool getCond(String _response){
    switch (filter) {
      case "POST":
        return _response.contains("POST");
      case "GET":
        return _response.contains("GET");
      case "OPTIONS":
        return _response.contains("OPTIONS");
      default:
        return _response.contains("POST") || _response.contains("GET") || _response.contains("OPTIONS");
    }
  }

  Widget OptionButton(String _title, String _filter, BuildContext _context){
    return RaisedButton(
      child: Text(_title),
      onPressed: () async {
        setState(() {
          filter = _filter;
          count_section["POST"] = 0;
          count_section["GET"] = 0;
          count_section["OPTIONS"] = 0;
          count_section["ALL"] = 0;
          isProccessing = true;
          //isConnected = true;
        });
        await Handler().getLogs(col_text, col_indicator, count_section, responseBodyList, isConnected,_context);
        setState(() {
          isProccessing = false;
        });
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
    //var themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Security Scanner'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(count_section[filter].toString(), style: TextStyle(fontSize: 18),),
          )
        ],
      ),
      body: Container(
       child: Column(
              children: [
                Text("IsConnected: " + isConnected.toString()),
                //Text(charonState.index.toString()),
                SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OptionButton("POST", "POST", context),
                    OptionButton("GET", "GET", context),
                    OptionButton("OPTIONS", "OPTIONS", context),
                    OptionButton("ALL", "ALL", context),
                    
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                 // alignment: WrapAlignment.spaceBetween,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      child: Text('Connect'),
                      onPressed: isConnected ? null : () async {
                        setState(() {
                          isProccessing = true;
                        });
                        await ShellExecuter().startServer();
                        await ShellExecuter().connectToProxy();
                        setState(() {
                          isProccessing = false;
                          isConnected = true;
                        });                    
                      },
                    ),
                    RaisedButton(
                      child: Text('Disconnect'),
                      onPressed: !isConnected ? null : () async {
                        setState(() {
                          isProccessing = true;
                        });
                        await ShellExecuter().stopServer();
                        await ShellExecuter().disconnectFromProxy();                        
                        setState(() {
                          isProccessing = false;
                          isConnected = false;
                        });
                      },
                    ),
                    RaisedButton(
                      child: Text('Down'),
                      onPressed: () async {
                        setState(() {
                          isButtonPressed = true;
                        });
                        //await FlutterVpn.disconnect();
                        _scrollJump();
                      },
                    ),
                    RaisedButton(
                      child: Text('Clear'),
                      onPressed: () async {
                        setState(() {
                          isProccessing = true;
                        });
                        await Handler().clearAll(col_text, col_indicator, count_section, responseBodyList, isConnected);
                        setState(() {
                          isProccessing = false;
                        });
                      },
                    ),
                    // RaisedButton(
                    //   child: Text('Test'),
                    //   onPressed: () async {
                    //     setState(() {
                    //       isProccessing = true;
                    //     });
                    //     await ShellExecuter().testFunc();
                    //     setState(() {
                    //       isProccessing = false;
                    //     });
                    //   },
                    // ),
                  ],
                ),
                SizedBox(height: 10),
                isProccessing ? CircularProgressIndicator() : Container(),
                SizedBox(height: 10),
              Expanded(
                //width: double.infinity,
                //height: MediaQuery.of(context).size.height*0.8,
                child: ListView.builder(
                  //reverse: true,
                  controller: _scrollController,
                  itemCount: responseBodyList.length,
                  itemBuilder: (BuildContext context, int index) {
                  return getCond(responseBodyList[index]) ? Column(
                    children: [
                      Divider(color: Colors.grey,),
                      (col_indicator[index] != Colors.black) && (col_indicator[index] != Colors.white) ? Center(
                        child: Icon(RpgAwesome.skull, color: col_indicator[index],),
                      ) : Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SelectableText(responseBodyList[index], style: TextStyle(color: col_text[index]),),
                      ),
                      Divider(color: Colors.grey,),
                    ],
                  ) : Container();
                 },
                ),
              ),
              ],
           ),
      )
    );
  }
}

