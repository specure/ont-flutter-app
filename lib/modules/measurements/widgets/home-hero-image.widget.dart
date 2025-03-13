import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/environment.dart';
import 'package:nt_flutter_standalone/core/store/core.cubit.dart';

class HomeHeroImage extends StatelessWidget {
  const HomeHeroImage({
    Key? key,
    this.width,
    this.height,
    this.imagePath,
  }) : super(key: key);

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
          imagePath ?? _getImageByConnectivity(),
          key: Key('home-screen-hero'),
        ),
      ),
    );
  }

  String _getImageByConnectivity() {
    final state = GetIt.I.get<CoreCubit>().state;
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
