class NetNeutralityType {
  static const WEB = 'WEB';
  static const DNS = 'DNS';
  static const UDP = 'UDP';
  static const TCP = 'TCP';
  static const VOP = 'VOP';
  static const UNM = 'UNM';
  static const TSP = 'TSP';
  static const TCR = 'TCR';
  static const UNKNOWN = 'UNKNOWN';
}

class NetNeutralityTestStatus {
  static const FAIL = 'FAIL';
  static const ERROR = 'ERROR';
  static const SUCCEED = 'SUCCEED';
}

class DnsTestFailReason {
  static const TIMEOUT = "timeout";
  static const BAD_STATUS = "badStatus";
  static const DIFFERENT_IP_ADDRESS = "diffIpAddress";
}

class DnsResultStatus {
  static const NOERROR = 0;

  /// Format error
  static const FORMERR = 1;

  /// Server failure
  static const SERVFAIL = 2;

  /// The name does not exist
  static const NXDOMAIN = 3;

  /// The operation requested is not implemented
  static const NOTIMP = 4;

  /// The operation was refused by the server
  static const REFUSED = 5;

  /// The name exists
  static const YXDOMAIN = 6;

  /// The RRset (name, type) exists
  static const YXRRSET = 7;

  /// The RRset (name, type) does not exist
  static const NXRRSET = 8;

  /// The requestor is not authorized to perform this operation
  static const NOTAUTH = 9;

  /// The zone specified is not a zone
  static const NOTZONE = 10;

  /// EDNS extended rcodes
  /// Unsupported EDNS level
  static const BADVERS = 16;

  /// TSIG/TKEY only rcodes
  /// The signature is invalid (TSIG/TKEY extended error)
  static const BADSIG = 16;

  /// The key is invalid (TSIG/TKEY extended error)
  static const BADKEY = 17;

  /// The time is out of range (TSIG/TKEY extended error)
  static const BADTIME = 18;

  /// The mode is invalid (TKEY extended error)
  static const BADMODE = 19;

  static String getAsString(int? status) {
    switch (status) {
      case NOERROR:
        return "NOERROR";
      case FORMERR:
        return "FORMERR";
      case SERVFAIL:
        return "SERVFAIL";
      case NXDOMAIN:
        return "NXDOMAIN";
      case NOTIMP:
        return "NOTIMP";
      case REFUSED:
        return "REFUSED";
      case YXDOMAIN:
        return "YXDOMAIN";
      case YXRRSET:
        return "YXRRSET";
      case NXRRSET:
        return "NXRRSET";
      case NOTAUTH:
        return "NOTAUTH";
      case NOTZONE:
        return "NOTZONE";
      case BADVERS:
        return "BADVERS";
      case BADSIG:
        return "BADSIG";
      case BADKEY:
        return "BADKEY";
      case BADTIME:
        return "BADTIME";
      case BADMODE:
        return "BADMODE";
      default:
        return "UNKNOWN";
    }
  }
}
