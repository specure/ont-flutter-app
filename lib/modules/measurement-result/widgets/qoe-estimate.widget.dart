import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/constants/measurement-quality-category.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/constants/measurement-quality-estimate.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class QoeEstimate extends StatelessWidget {
  final String category;
  final String quality;

  static const Map<String, IconData> iconData = {
    MeasurementQualityCategory.socialMedia: Icons.contacts,
    MeasurementQualityCategory.onlineGaming: Icons.gamepad_rounded,
    MeasurementQualityCategory.videoStreaming: Icons.videocam_rounded,
    MeasurementQualityCategory.email: Icons.email,
    MeasurementQualityCategory.webBrowsing: Icons.language,
    MeasurementQualityCategory.voip: Icons.phone,
  };

  static const Map<String, String> categoryTitle = {
    MeasurementQualityCategory.socialMedia: "Social Media",
    MeasurementQualityCategory.onlineGaming: "Online Gaming",
    MeasurementQualityCategory.videoStreaming: "Video Streaming",
    MeasurementQualityCategory.email: "Email / Messaging",
    MeasurementQualityCategory.webBrowsing: "Web Browsing",
    MeasurementQualityCategory.voip: "VOIP",
  };

  const QoeEstimate({required this.category, required this.quality});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                _buildEstimateIcon(),
                Container(width: 20),
                Flexible(
                  child: Text(
                    categoryTitle[category] != null
                        ? categoryTitle[category]!.translated
                        : "",
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: NTDimensions.textL),
                  ),
                )
              ],
            ),
          ),
          QualityBadge(quality: quality)
        ],
      ),
    );
  }

  Widget _buildEstimateIcon() {
    return CircleAvatar(
      backgroundColor: NTColors.pale.withOpacity(0.05),
      radius: 24,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 19,
        child: Container(
          height: 24,
          width: 24,
          child: Icon(iconData[category], color: Colors.black),
        ),
      ),
    );
  }
}

class QualityBadge extends StatelessWidget {
  static const Map<String, Color> qualityColor = {
    MeasurementQualityEstimate.excellent: Color.fromARGB(255, 1, 146, 20),
    MeasurementQualityEstimate.good: Color(0xFF6DD400),
    MeasurementQualityEstimate.moderate: Color(0xFFF7B500),
    MeasurementQualityEstimate.poor: Color(0xFFFA6400),
    MeasurementQualityEstimate.bad: Color(0xFFE02020),
  };

  static const Map<String, String> qualityTitle = {
    MeasurementQualityEstimate.excellent: "Excellent",
    MeasurementQualityEstimate.good: "Good",
    MeasurementQualityEstimate.moderate: "Moderate",
    MeasurementQualityEstimate.poor: "Poor",
    MeasurementQualityEstimate.bad: "Bad",
  };

  const QualityBadge({
    Key? key,
    required this.quality,
  }) : super(key: key);

  final String quality;

  bool get shouldShowIcon => quality == MeasurementQualityEstimate.excellent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24 * MediaQuery.of(context).textScaleFactor,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(12 * MediaQuery.of(context).textScaleFactor),
        color: qualityColor[quality] != null
            ? qualityColor[quality]
            : NTColors.pale,
      ),
      padding: EdgeInsets.fromLTRB(12, 5, shouldShowIcon ? 6 : 12, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            qualityTitle[quality] != null
                ? qualityTitle[quality]!.translated
                : "",
            style: TextStyle(color: Colors.white, fontSize: NTDimensions.textS),
          ),
          ConditionalContent(
            conditional: shouldShowIcon,
            truthyBuilder: () => Container(
              margin: EdgeInsets.only(left: 6),
              child: Icon(Icons.check_circle, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}
