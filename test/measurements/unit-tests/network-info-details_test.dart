import 'package:flutter_test/flutter_test.dart';
import 'package:nt_flutter_standalone/modules/measurements/models/network-info-details.dart';

void main() {
  group('Network info details', () {
    test('green IPs', () {
      final details = NetworkInfoDetails(
        ipV4PrivateAddress: '',
        ipV4PublicAddress: '',
        ipV6PrivateAddress: '',
        ipV6PublicAddress: '',
      );
      expect(details.ipV4StatusColor, NetworkInfoDetails.green);
      expect(details.ipV6StatusColor, NetworkInfoDetails.green);
    });
    test('yellow IPs', () {
      final details = NetworkInfoDetails(
        ipV4PrivateAddress: '',
        ipV4PublicAddress: '1',
        ipV6PrivateAddress: '',
        ipV6PublicAddress: '1',
      );
      expect(details.ipV4StatusColor, NetworkInfoDetails.yellow);
      expect(details.ipV6StatusColor, NetworkInfoDetails.yellow);
    });
    test('red IPs', () {
      final details = NetworkInfoDetails(
        ipV4PrivateAddress: addressIsNotAvailable,
        ipV4PublicAddress: addressIsNotAvailable,
        ipV6PrivateAddress: addressIsNotAvailable,
        ipV6PublicAddress: '',
      );
      expect(details.ipV4StatusColor, NetworkInfoDetails.red);
      expect(details.ipV6StatusColor, NetworkInfoDetails.red);
    });
    test('toJson and copyWith', () {
      final details = NetworkInfoDetails(
        type: 'type',
        name: 'name',
        mobileNetworkGeneration: 'mng',
      );
      expect(details.toJson(), {'type': 'type', 'name': 'name'});
      expect(
        details.copyWith(
          type: 'type2',
          name: 'name2',
          mobileNetworkGeneration: 'mng2',
        ),
        NetworkInfoDetails(
          type: 'type2',
          name: 'name2',
          mobileNetworkGeneration: 'mng2',
        ),
      );
      expect(
        details.copyWith(),
        details,
      );
    });
  });
}
