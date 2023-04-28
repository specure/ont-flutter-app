import 'dart:io';

//Platform is wrapped in order to be able to mock its static fields
class PlatformWrapper {
  bool get isAndroid => Platform.isAndroid;
  bool get isIOS => Platform.isIOS;
  String get localeName => Platform.localeName;
}
