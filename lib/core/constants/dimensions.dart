import 'package:nt_flutter_standalone/core/constants/environment.dart';

class NTDimensions {
  static final textXL = 18.0 * factor;
  static final textL = 16.0 * factor;
  static final textM = 14.0 * factor;
  static final textS = 12.0 * factor;
  static final textXS = 11.0 * factor;
  static final textXXS = 10.0 * factor;
  static final textXXXS = 8.0 * factor;
  static final title = 24.0 * factor;

  static final factor = Environment.appSuffix == '.no' ? 1.1 : 1;

  NTDimensions._();
}
