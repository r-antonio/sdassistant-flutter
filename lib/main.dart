import 'dart:async';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:sdassistant/model/servicehost.dart';
import 'package:sdassistant/services/sharing_service.dart';
import 'package:sdassistant/services/mdns_service.dart';

void main() => runApp(new FlutterGrpcApp());

class FlutterGrpcApp extends StatefulWidget {
  _FlutterGrpcAppState createState() => _FlutterGrpcAppState();
}

class _FlutterGrpcAppState extends State<FlutterGrpcApp> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();

  final GlobalKey<ScaffoldState> _scaffoldStateKey = new GlobalKey<ScaffoldState>();

  static const platform = const MethodChannel('app.channel.shared.data');
  Map<dynamic, dynamic> sharedData = Map();

  String res;
  List<ServiceHost> services;

  @override
  void initState() {
    res = "";
    services = List<ServiceHost>();
    super.initState();
    _initSharedHandler();
    _asyncGetServices();
  }

  _initSharedHandler() async {
    SystemChannels.lifecycle.setMessageHandler((msg) {
      if (msg.contains('resumed')) {
        _getSharedData().then((d) {
          if (d.isEmpty) return;
          setState(() {
            sharedData = d;
          });
        });
      }
    });

    var data = await _getSharedData();
    setState(() {
      sharedData = data;
    });
  }

  Future<Map> _getSharedData() async => await platform.invokeMethod('getSharedData');

  _asyncGetServices() async {
    List<ServiceHost> srvs = await MulticastDNSService.GetServices("_test._tcp.local");
    if (srvs.isEmpty) {
      _scaffoldStateKey.currentState.showSnackBar(new SnackBar(
          content: new Text("No services found")
      ));
    }
    setState(() {
      services = srvs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'SD Assistant',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        key: _scaffoldStateKey,
        appBar: AppBar(
          title: Text("SD + GRPC"),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(),
              ),
              Expanded(child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: () async => _asyncGetServices(),
                  child: ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return new ListTile(
                        leading: Icon(Icons.wifi_tethering),
                        title: Text(services[index].name),
                        subtitle: Text('${services[index].ip}:${services[index].port}'),
                        onTap: () async => _callGrpc(services[index]),
                        trailing: Text("$res"),
                      );
                    },
                  )
                )
              ),
            ],
          ),
        ),
      )
    );
  }

  _shareLink(ServiceHost service) async {
    var url = sharedData["text"];
    var status = await SharingService.ShareLink(service, url);
    setState(() {
      res = status.message;
    });
  }

  Future<void> _callGrpc(ServiceHost selectedService) async {
    print(sharedData);
    if (sharedData.containsKey("text")) {
      await _shareLink(selectedService);
    } else {
      String path;
      if (sharedData.isEmpty) {
        path = await FilePicker.getFilePath();
      } else if (sharedData.containsKey("path")) {
        path = sharedData["path"];
      }
      if (path == null) return;
      setState(() {
        res = "Uploading...";
      });
      try {
        var us = await SharingService.Upload(selectedService, path);
        setState(() {
          res = us.message;
        });
      } catch(e) {
        setState(() {
          print(e);
          res = "Error";
        });
      }
    }
    sharedData.clear();
  }
}
