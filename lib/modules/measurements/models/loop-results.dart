class LoopResult {
  final String loopUuid;
  final int ping;
  final double speedDownload;
  final double speedUpload;
  final double? packetLoss;
  final int? jitter;

  LoopResult({
    required this.loopUuid,
    required this.speedDownload,
    required this.speedUpload,
    required this.ping,
    this.packetLoss,
    this.jitter
  });
}