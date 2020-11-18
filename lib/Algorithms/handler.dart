import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:process_run/shell.dart';
import 'package:security_scaner/Algorithms/shellExecuter.dart';

String url = 'http://localhost:9010';
  http.Response response;
  String responseBody = '';
  //List<String> responseBodyList = new List();
  bool isRestarted = true;
  ThemeData themeData ;
  //var shell = Shell();
  //List<Color> col_text = new List();
  //List<Color> col_indicator = new List();
  //Map<String, int> count_section = {"POST" : 0, "GET" : 0, "OPTIONS" : 0, "ALL" : 0};

class Handler {

    Future<void> getLogs(List<Color> col_text, List<Color> col_indicator, Map<String, int> count_section, List<String> responseBodyList, BuildContext context) async{ //TODO: write logs to the local txt file and be able to send it.
    themeData = Theme.of(context);
    response = await http.get(url);
      responseBody = response.body;
    fillResponseList(col_text, col_indicator, count_section, responseBodyList);
  }

  void fillResponseList(List<Color> col_text, List<Color> col_indicator, Map<String, int> count_section, List<String> responseBodyList){ 

    int j = 0;
    String strToPush = '';
    int numOfReqs = 0;

    for (int i = 1; i < responseBody.length - 1; i++) { // TODO: start from the last stopped element: for(i=k;;){...} k = i, where k is global
      if(responseBody[i] == ',' && j < responseBody.length - 1 && i < responseBody.length - 1){
          try{
          strToPush = responseBody.substring(j + 2, i - 1);
          }catch(e){
            strToPush = 'ERROR ERROR ERROR';
          }
          j = i;
          numOfReqs++;
        if(numOfReqs >= responseBodyList.length){
          responseBodyList.add(strToPush);
          col_text.add(themeData.brightness == Brightness.light ? Colors.black : Colors.white);
          col_indicator.add(themeData.brightness == Brightness.light ? Colors.black : Colors.white);
          isRestarted = false;
        }
      }
    }
     if(numOfReqs < responseBodyList.length){
          responseBodyList.clear();
          col_text.clear();
          col_indicator.clear();
          fillResponseList(col_text, col_indicator, count_section, responseBodyList);
      }

    clearExtra(col_text, col_indicator, count_section, responseBodyList);
    handlePOST(col_text, col_indicator, count_section, responseBodyList);
    handleGET(col_text, col_indicator, count_section, responseBodyList);
    handleOPTIONS(col_text, col_indicator, count_section, responseBodyList);
    handleSeverity(col_text, col_indicator, count_section, responseBodyList);

    count_section["ALL"] = numOfReqs;
  }

  void clearExtra(List<Color> col_text, List<Color> col_indicator, Map<String, int> count_section, List<String> responseBodyList){
    List<String> _backupArr = responseBodyList;


    for(int i = 0; i < responseBodyList.length; i++){
      if(!(responseBodyList[i].contains("GET") || responseBodyList[i].contains("POST") || responseBodyList[i].contains("OPTIONS"))){
        _backupArr.remove(responseBody[i]);
      }
    }
    //responseBodyList.clear();
    responseBodyList = _backupArr;
  }

   void handlePOST(List<Color> col_text, List<Color> col_indicator, Map<String, int> count_section, List<String> responseBodyList){
    //TODO: handle POST request - DATA SNIIF may occur here

    for (int i = 0; i < responseBodyList.length; i++){
      if(responseBodyList[i].contains('POST')){
        count_section["POST"]++;
        col_text[i] = Colors.red;
      }
    }
  }

   void handleGET(List<Color> col_text, List<Color> col_indicator, Map<String, int> count_section, List<String> responseBodyList){
    //TODO: handle and check GET request
    for (int i = 0; i < responseBodyList.length; i++){
      if(responseBodyList[i].contains('GET')){
        count_section["GET"]++;
        //col_text[i] = Colors.black;
      }
    }
  }

  void handleOPTIONS(List<Color> col_text, List<Color> col_indicator, Map<String, int> count_section, List<String> responseBodyList){
    //TODO: handle and check GET request
    for (int i = 0; i < responseBodyList.length; i++){
      if(responseBodyList[i].contains('OPTIONS')){
        count_section["OPTIONS"]++;
        col_text[i] = Colors.amber;
      }
    }
  }

  void handleSeverity(List<Color> col_text, List<Color> col_indicator, Map<String, int> count_section, List<String> responseBodyList){
    for (int i = 0; i < responseBodyList.length; i++){
      if(responseBodyList[i].contains('analytics') 
      || responseBodyList[i].contains("metrika")
      || (responseBodyList[i].contains("collect") && !(responseBodyList.contains("collection")))
      || responseBodyList[i].contains('activity') 
      || responseBodyList[i].contains("location")
      || responseBodyList[i].contains("doubleclick")
      || (responseBodyList[i].contains("upload") && !responseBodyList[i].contains("load"))){
        col_indicator[i] = Colors.red;
      }
    else if(responseBodyList.contains("metric")){
        col_indicator[i] = Colors.amber;
    }
    if(responseBodyList[i].contains("160")){
      //TODO: extract this part then check if is it timestamp(year == from 2020 to 2023), then Colors.red
      int startInd = responseBodyList[i].indexOf("160");
      int k = startInd;
      for(k = startInd; k < responseBodyList[i].length; k++){
        if(!responseBodyList[i][k].contains(new RegExp("[0-9]"))){
          break;
        }
      }
      int _timeStamp = int.parse(responseBodyList[i].substring(startInd, k));
      var dateTimeSec = DateTime.fromMillisecondsSinceEpoch(_timeStamp*1000);
      var dateTimeMSec = DateTime.fromMillisecondsSinceEpoch(_timeStamp);
      if((dateTimeSec.year >= 2020 && dateTimeSec.year <= 2023) || (dateTimeMSec.year >= 2020 && dateTimeMSec.year <= 2023)){
        col_indicator[i] = Colors.blue;
      }
    }
    if(responseBodyList[i].contains('favicon.ico')){
      col_indicator[i] = themeData.brightness == Brightness.light ? Colors.black : Colors.white;
    }
    }
  }




  void handleOthers(){
    //TODO: handle other requests
  }

  Future<void> clearAll(List<Color> col_text, List<Color> col_indicator, Map<String, int> count_section, List<String> responseBodyList) async{
    col_text.clear();
    col_indicator.clear();
    count_section.clear();
    responseBodyList.clear();
    await ShellExecuter().stopServer();
    await ShellExecuter().startServer();
    await ShellExecuter().connectToProxy();
  }
}