import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/widgets/header-with-logo.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/orientation-builder.widget.dart';
import 'package:nt_flutter_standalone/modules/onboarding/screens/welcome/impl/welcome-landscape.config.dart';
import 'package:nt_flutter_standalone/modules/onboarding/screens/welcome/impl/welcome-portrait.config.dart';
import 'package:nt_flutter_standalone/modules/onboarding/screens/welcome/welcome.config.dart';
import 'package:nt_flutter_standalone/modules/onboarding/store/wizard.cubit.dart';

class WelcomeScreen extends StatefulWidget {
  static const route = "onboarding/welcome";

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    GetIt.I.get<WizardCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return NTOrientationBuilder<WelcomeConfig>(
        portraitConfig: WelcomePortraitConfig(),
        landscapeConfig: WelcomeLandscapeConfig(),
        builder: (config) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: null,
            body: SafeArea(
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Positioned(
                    top: 28,
                    left: 20,
                    child: HeaderWithLogo(),
                  ),
                  Container(
                    width: size.width,
                    child: config.getContent(context),
                  )
                ],
              ),
            ),
          );
        });
  }
}
