import 'package:url_launcher/url_launcher.dart';

class UrlLauncherWrapper {

  Future<bool> canLaunch(Uri url) {
    return canLaunchUrl(url);
  }

  Future<bool> launch(Uri url) {
    return launchUrl(url);
  }
}