import 'package:flutter/material.dart';
import 'package:htprotect/htprotect.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _htprotectPlugin = Htprotect();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onCallBack(Map info) async {
    // String type = message['type'];
    // String info = message['info'];
    print("--------");
    // print("--------" +message);
    // print(message);
    // print(type);
    // print(info);

    Fluttertoast.showToast(
        msg: '_onInitCallBack: $info', gravity: ToastGravity.CENTER);
  }

  _addHTPCallback() {
    _htprotectPlugin.addMessageReceiver(onCallBack: _onCallBack);
  }

  Future<void> initHTP() async {

    String productId;
    if (Platform.isIOS) {
      productId = "YD00229728652121";
    } else {
      productId = "YD00983760250043";
    }

    Map<String,dynamic> params = {};
    params['serverType'] = 1;
    params['channel'] = 'test';
    params['gameKey'] = '8ef016947a1eeed4ac5b07c700e2b3f5';
    var map1 = {'aa': 'aaa', 'bb': 'bbb'};
    params['extData'] = map1;

    _htprotectPlugin.init(productId, params: params).then((initResult) {
      var code = initResult['code'];
      if (code == kHTPInitSuccessCode) {
        Fluttertoast.showToast(
            msg: "Init successfully", gravity: ToastGravity.CENTER);
      } else {
        String Msg = initResult['Msg'];
        Fluttertoast.showToast(
            msg: 'init failed, Msg is: $Msg',
            gravity: ToastGravity.CENTER);
      }
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future<void> setRoleInfo() async {
    String businessId = "31c9823e57b3b789341db4812c562ef1";
    String roleId = "wangzehuatroleId";
    String roleName = "wangzehuatroleName";
    String roleAccount = "wangzehuatroleAccount";
    String roleServer = "wangzehuatroleServer";
    int serverId = 123;
    String gameJson = "{'gameVersion': 'ccc', 'assetVersion': 'ddd'}";

    _htprotectPlugin.setRoleInfo(businessId, roleId, roleName, roleAccount, roleServer, serverId, gameJson).then((result) {
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future<void> logOut() async {
    _htprotectPlugin.logOut().then((result) {
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future<void> getToken() async {
    String businessId = "ab51b8dbadb6894192eeeaafd6973d0e";

    _htprotectPlugin.getToken(3000,businessId).then((result) {
      var code = result['code'];
      String token = result['token'];
      Fluttertoast.showToast(
          msg: 'code is $code, token is: $token',
          gravity: ToastGravity.CENTER);

    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future<void> ioctl() async {

    _htprotectPlugin.ioctl(3,"").then((result) {
      Fluttertoast.showToast(
          msg: 'result is: $result',
          gravity: ToastGravity.CENTER);

    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future<void> getDataSign(String inputData, int algIndex) async {

    _htprotectPlugin.getDataSign(inputData,algIndex).then((result) {
      Fluttertoast.showToast(
          msg: 'result is: $result',
          gravity: ToastGravity.CENTER);

    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future<void> safeCommToServer(int version, int alg, String input, bool isCrucial) async {

    _htprotectPlugin.safeCommToServer(version,alg,input,isCrucial).then((result) {
      Fluttertoast.showToast(
          msg: 'result is: $result',
          gravity: ToastGravity.CENTER);

    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future<void> safeCommFromServer(int alg, int timeout, String input) async {

    _htprotectPlugin.safeCommFromServer(alg,timeout,input).then((result) {
      Fluttertoast.showToast(
          msg: 'result is: $result',
          gravity: ToastGravity.CENTER);

    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future<void> registerTouchEvent(int gameplayId, int sceneId) async {
    _htprotectPlugin.registerTouchEvent(gameplayId,sceneId);
  }

  Future<void> unregisterTouchEvent() async {
    _htprotectPlugin.unregisterTouchEvent();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await initHTP();
                    setState(() {});
                  },
                  child: Text('初始化')),
              ElevatedButton(
                  onPressed: () async {
                    await setRoleInfo();
                    setState(() {});
                  },
                  child: Text('设置角色信息')),
              ElevatedButton(
                  onPressed: () async {
                    await logOut();
                    setState(() {});
                  },
                  child: Text('退出登陆')),
              ElevatedButton(
                  onPressed: () async {
                    await getToken();
                    setState(() {});
                  },
                  child: Text('获取token')),
              ElevatedButton(
                  onPressed: () async {
                    await ioctl();
                    setState(() {});
                  },
                  child: Text('ioctl交互接口')),
              ElevatedButton(
                  onPressed: () async {
                    await getDataSign("wangzehuaTest",1003);
                    setState(() {});
                  },
                  child: Text('数据校验接口')),
              ElevatedButton(
                  onPressed: () async {
                    await safeCommToServer(31,0x00010203,"wangzehuaTest",true);
                    setState(() {});
                  },
                  child: Text('安全通信加密接口')),
              ElevatedButton(
                  onPressed: () async {
                    await safeCommFromServer(0,0,"hAAAAAAAAAACAAAA+2FWVliUjcnkDstenJiGpDpRivCcYo4pA0lV89k/JjoMAAAAK9iDqNnZGtF0KtndIAAAABms7XM2G1ShsbkF1l9z/lvRk3sp8fEmG20ApJ6HDh/0IAAAAAXnnFPCJmghUp2XEE1LaN+u8T9ngVZKe+kpMUNpi2XgDzhN0ksW1BHQUtAH8CyPMg==");
                    setState(() {});
                  },
                  child: Text('安全通信解密接口')),
              ElevatedButton(
                  onPressed: () async {
                    await registerTouchEvent(31,24);
                    setState(() {});
                  },
                  child: Text('开始采集点击数据')),
              ElevatedButton(
                  onPressed: () async {
                    await unregisterTouchEvent();
                    setState(() {});
                  },
                  child: Text('停止采集点击数据')),
            ],
          ),
        ),
      ),
    );
  }
}