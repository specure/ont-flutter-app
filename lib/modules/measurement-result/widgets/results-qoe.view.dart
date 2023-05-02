import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/constants/urls.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/section-title.widget.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.state.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/qoe-estimate.widget.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/widgets/result-bottom-sheet.widget.dart';

class ResultsQoeView extends StatelessWidget {
  const ResultsQoeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasurementResultCubit, MeasurementResultState>(
      builder: (context, state) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    SectionTitle('Services'),
                    SizedBox(height: 16),
                    ...getMetrics(state),
                  ],
                ),
              ),
            ),
          ),
          ConditionalContent(
              conditional: state.project?.enableAppQoeResultExplanation == true,
              truthyBuilder: () => ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        isDismissible: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16),
                          ),
                        ),
                        builder: (context) => ResultBottomSheet(
                          context,
                          state,
                          pageUrl: NTUrls.cmsMethodologyQoeRoute,
                          pageContent: "qoe explanation".translated,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 32,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          topLeft: Radius.circular(16),
                        ),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            "Learn more about Quality of Experience".translated,
                            style: TextStyle(color: NTColors.primary),
                          )),
                          Icon(
                            Icons.info_outline,
                            color: NTColors.primary,
                          )
                        ],
                      ),
                    ),
                  )),
        ],
      ),
    );
  }

  List<Widget> getMetrics(MeasurementResultState state) {
    return state.result?.userExperienceMetrics != null
        ? state.result!.userExperienceMetrics
            .map(
              (e) => QoeEstimate(
                category: e.category,
                quality: e.quality,
              ),
            )
            .toList()
        : [];
  }
}
