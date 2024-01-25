// import 'package:flutter_test/flutter_test.dart';
// import 'package:htprotect/htprotect.dart';
// import 'package:htprotect/htprotect_platform_interface.dart';
// import 'package:htprotect/htprotect_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockHtprotectPlatform
//     with MockPlatformInterfaceMixin
//     implements HtprotectPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final HtprotectPlatform initialPlatform = HtprotectPlatform.instance;
//
//   test('$MethodChannelHtprotect is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelHtprotect>());
//   });
//
//   test('getPlatformVersion', () async {
//     Htprotect htprotectPlugin = Htprotect();
//     MockHtprotectPlatform fakePlatform = MockHtprotectPlatform();
//     HtprotectPlatform.instance = fakePlatform;
//
//     expect(await htprotectPlugin.getPlatformVersion(), '42');
//   });
// }
