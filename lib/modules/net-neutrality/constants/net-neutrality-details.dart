import 'package:equatable/equatable.dart';
import 'package:nt_flutter_standalone/modules/net-neutrality/constants/net-neutrality-server-constants.dart';

class NetNeutralityDetailsConfig with EquatableMixin {
  late final String information;
  late final List<String> columnTexts;
  late final List<int> columnWeights;
  late final String title;
  late final String type;

  NetNeutralityDetailsConfig({
    required this.information,
    required this.columnTexts,
    required this.columnWeights,
    required this.title,
    required this.type,
  });

  static NetNeutralityDetailsConfig webTestConfig = NetNeutralityDetailsConfig(
      information:
          "The website test downloads the most popular websites in your country. The test is successful if the page can be transferred.",
      columnTexts: ["Target", "Time", "Status"],
      columnWeights: [2, 1, 1],
      title: "Web page",
      type: NetNeutralityType.WEB);

  static NetNeutralityDetailsConfig dnsTestConfig = NetNeutralityDetailsConfig(
      information:
      "DNS is a fundamental Internet service. It is used to translate domain names to IP addresses. Depending on the test it is checked if the service is available, if the answers are correct and how fast the server responds.",
      columnTexts: ["Target", "Time", "IP address", "Status"],
      columnWeights: [2, 1, 2, 1],
      title: "DNS",
      type: NetNeutralityType.DNS);

  @override
  List<Object?> get props => [
    columnTexts,
    columnWeights,
    title,
    type,
    information,
  ];
}
