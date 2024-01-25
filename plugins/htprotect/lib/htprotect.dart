import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const kHTPInitSuccessCode = "200";

typedef HTPCallback = Future<dynamic> Function(Map);

class Htprotect {
  @visibleForTesting
  final methodChannel = const MethodChannel('htprotect');

  Htprotect._internal();

  factory Htprotect() => _instance;

  static final Htprotect _instance = Htprotect._internal();

  //回调
  HTPCallback? _onCallBack;

  void addMessageReceiver({HTPCallback? onCallBack}) {
    _onCallBack = onCallBack;
    methodChannel.setMethodCallHandler(_methodCallHandler);
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onCallBack':
        return _onCallBack!(call.arguments);
    }
  }

  Future<Map<dynamic, dynamic>> init(String productId,
      {Map<String, dynamic>? params}) async {
    Map<dynamic, dynamic> initResult = await methodChannel
        .invokeMethod('init', {'productId': productId, 'params': params});
    return initResult;
  }

  Future<int> setRoleInfo(
      String businessId,
      String roleId,
      String roleName,
      String roleAccount,
      String roleServer,
      int serverId,
      String gameJson) async {
    var ret = await methodChannel.invokeMethod('setRoleInfo', {
      'businessId': businessId,
      'roleId': roleId,
      'roleName': roleName,
      'roleAccount': roleAccount,
      'roleServer': roleServer,
      'serverId': serverId,
      'gameJson': gameJson
    });
    return ret;
  }

  Future<void> logOut() async {
    await methodChannel.invokeMethod('logOut');
  }

  Future<Map<dynamic, dynamic>> getToken(int timeout, String businessId) async {
    Map<dynamic, dynamic> getTokenResult = await methodChannel.invokeMethod(
        'getToken', {'timeout': timeout, 'businessId': businessId});
    return getTokenResult;
  }

  Future<String> ioctl(int request, String data) async {
    String result = await methodChannel
        .invokeMethod('ioctl', {'request': request, 'data': data});
    return result;
  }

  Future<String> getDataSign(String inputData, int algIndex) async {
    String result = await methodChannel.invokeMethod(
        'getDataSign', {'inputData': inputData, 'algIndex': algIndex});
    return result;
  }

  Future<Map<dynamic, dynamic>> safeCommToServer(
      int version, int alg, String input, bool isCrucial) async {
    Map<dynamic, dynamic> result = await methodChannel.invokeMethod(
        'safeCommToServer', {
      'version': version,
      'alg': alg,
      'input': input,
      'isCrucial': isCrucial
    });
    return result;
  }

  Future<Map<dynamic, dynamic>> safeCommFromServer(
      int alg, int timeout, String input) async {
    Map<dynamic, dynamic> result = await methodChannel.invokeMethod(
        'safeCommFromServer', {
      'alg': alg,
      'timeout': timeout,
      'input': input
    });
    return result;
  }

  Future<void> registerTouchEvent(int gameplayId, int sceneId) async {
    await methodChannel.invokeMethod('registerTouchEvent', {'gameplayId': gameplayId, 'sceneId': sceneId});
  }

  Future<void> unregisterTouchEvent() async {
    await methodChannel.invokeMethod('unregisterTouchEvent');
  }
}
