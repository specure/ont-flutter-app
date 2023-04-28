import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/error.snackbar.dart';
import 'package:nt_flutter_standalone/core/widgets/orientation-builder.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/primary.button.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/constants/measurement-quality-category.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-quality.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/advanced-results.screen.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/measurement-result/impl/measurement-result-landscape-config.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/measurement-result/impl/measurement-result-portrait-config.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/screens/measurement-result/measurement-result-config.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.state.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/qoe-estimate.widget.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

class MeasurementResultScreen extends StatefulWidget {
  static const route = 'measurements/result';
  static const argumentTestUuid = 'testUuid';
  static const argumentResult = 'result';

  const MeasurementResultScreen({Key? key}) : super(key: key);

  @override
  State<MeasurementResultScreen> createState() =>
      _MeasurementResultScreenState();
}

class _MeasurementResultScreenState extends State<MeasurementResultScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    GetIt.I.get<MeasurementResultCubit>().init(
          result: arguments[MeasurementResultScreen.argumentResult],
          testUuid: arguments[MeasurementResultScreen.argumentTestUuid],
        );
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return BlocConsumer<MeasurementResultCubit, MeasurementResultState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null &&
          current.errorMessage!.isNotEmpty &&
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
            .showSnackBar(NTErrorSnackbar(state.errorMessage!));
      },
      builder: (context, state) => Scaffold(
        appBar: NTAppBar(
          actions: [
            ConditionalContent(
              conditional: state.project?.enableAppResultsSharing == true,
              truthyBuilder: () => IconButton(
                onPressed: () {},
                icon: Icon(Icons.share, color: NTColors.primary),
              ),
            ),
          ],
          leading: IconButton(
            onPressed: () => GetIt.I.get<NavigationService>().goBack(),
            icon: Icon(Icons.arrow_back, color: NTColors.primary),
          ),
          titleText: "Measurement details",
        ),
        body: SafeArea(
          child: ConditionalContent(
            conditional: state.loading == false,
            truthyBuilder: () => SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(28, 36, 28, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDownloadSection(state.result),
                    _buildServicesSection(state.result?.userExperienceMetrics),
                    SizedBox(height: 32),
                    _buildBasicMetadataSection(state.result),
                    SizedBox(height: 64),
                    ConditionalContent(
                        conditional: isPortrait,
                        truthyBuilder: () => Container(
                            margin: EdgeInsets.only(bottom: 16),
                            alignment: Alignment.center,
                            child: _buildAdvancedButton()))
                  ],
                ),
              ),
            ),
            falsyBuilder: () => Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: NTColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  NTOrientationBuilder<MeasurementResultConfig> _buildDownloadSection(
      MeasurementHistoryResult? result) {
    return NTOrientationBuilder<MeasurementResultConfig>(
        portraitConfig: MeasurementResultPortraitConfig(result),
        landscapeConfig: MeasurementResultLandscapeConfig(result),
        builder: (config) => config.buildDownloadSection());
  }

  Widget _buildServicesSection(
      List<MeasurementQuality>? userExperienceMetrics) {
    return ConditionalContent(
      conditional:
          userExperienceMetrics != null && userExperienceMetrics.length > 0,
      truthyBuilder: () => _Section(
          sectionTitle: "Most Popular Services",
          child: Container(
            margin: EdgeInsets.only(top: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: userExperienceMetrics!
                  .map((e) => QoeEstimate(
                        category: e.category,
                        quality: e.quality,
                      ))
                  .toList()
                ..retainWhere((e) =>
                    e.category == MeasurementQualityCategory.socialMedia ||
                    e.category == MeasurementQualityCategory.onlineGaming ||
                    e.category == MeasurementQualityCategory.videoStreaming),
            ),
          )),
    );
  }

  NTOrientationBuilder<MeasurementResultConfig> _buildBasicMetadataSection(
      MeasurementHistoryResult? result) {
    return NTOrientationBuilder<MeasurementResultConfig>(
        portraitConfig: MeasurementResultPortraitConfig(result),
        landscapeConfig: MeasurementResultLandscapeConfig(result),
        builder: (config) => config.buildBasicMetadataSection());
  }

  Widget _buildAdvancedButton() {
    return PrimaryButton(
      title: 'Switch to Advanced Results'.translated,
      onPressed: () => GetIt.I
          .get<NavigationService>()
          .pushNamed(AdvancedResultsScreen.route),
      width: 255,
    );
  }
}

class _Section extends StatelessWidget {
  final String sectionTitle;
  final Widget child;

  const _Section({required this.sectionTitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [SectionTitle(sectionTitle), child],
    );
  }
}
