import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/mixins/error-state.mixin.dart';

class HomeHeroImage extends StatelessWidget {
  const HomeHeroImage({
    Key? key,
    required this.state,
    this.width,
    this.height,
    this.imagePath,
  }) : super(key: key);

  final ErrorState state;
  final double? width;
  final double? height;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          imagePath ?? _getImageByConnectivity(state),
          key: Key('home-screen-hero'),
        ),
      ),
    );
  }

  String _getImageByConnectivity(ErrorState state) {
    switch (state.connectivity) {
      case ConnectivityResult.mobile:
        return 'config/${Environment.appSuffix}/images/home-screen-hero-mobile.svg';
      case ConnectivityResult.wifi:
        return 'config/${Environment.appSuffix}/images/home-screen-hero-wifi.svg';
      case ConnectivityResult.ethernet:
        return 'config/${Environment.appSuffix}/images/home-screen-hero-ethernet.svg';
      default:
        return 'config/${Environment.appSuffix}/images/home-screen-hero-no-internet.svg';
    }
  }
}
