import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/services/localization.service.dart';

extension TranslatedString on String {
  String get translated => GetIt.I.get<LocalizationService>().translate(this);
}

extension HttpString on String {
  String get asCmsUrl {
    if (startsWith('https')) {
      return this;
    }
    if (startsWith('http')) {
      return this.replaceFirst('http', 'https');
    }
    return "https://${Environment.webpageUrl}$this";
  }
}

extension MarkdownReadyString on String {
  String get markdownReady {
    return this
        ._removingAnchors
        ._removingBreaks
        ._removingFigures
        ._removingFonts;
  }

  String get _removingAnchors {
    return replaceAllMapped(
        RegExp(r'<a.*?href="(.*?)".*?>(.*?)<\/a>'),
        (match) => match[1] != null && match[1]!.contains('javascript')
            ? ''
            : '[${match[2]}](${match[1]})');
  }

  String get _removingBreaks {
    return replaceAll(RegExp(r'<(h|b)r.*?>'), '');
  }

  String get _removingFigures {
    return replaceAll(RegExp(r'\[figure.*?\].*?\[/figure\]'), '');
  }

  String get _removingFonts {
    return replaceAllMapped(
        RegExp(r'<font(.*?)color="(.*?)"(.*?)>(.*?)</font>'),
        (match) => '<font${match[1]}${match[3]}>${match[4]}</font>');
  }

  String get formatMobileNetworkTypes {
    return this.replaceAll('(+', "\n").replaceAll('+(', "\n").replaceAll(')', "");
  }
}
