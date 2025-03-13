import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/models/error-handler.dart';
import 'package:nt_flutter_standalone/core/services/cms.service.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/models/measurement-history-result.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/services/measurement-result.service.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.state.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/measurement-history-results.dart';

class MeasurementResultCubit extends Cubit<MeasurementResultState>
    implements ErrorHandler {
  final MeasurementResultService _measurementResultService =
      GetIt.I.get<MeasurementResultService>();
  final CMSService _cmsService = GetIt.I.get<CMSService>();

  MeasurementResultCubit() : super(MeasurementResultState());

  Future init({
    required MeasurementHistoryResults? result,
    String? testUuid,
  }) async {
    emit(state.copyWith(loading: true));
    final packageInfo = await PackageInfo.fromPlatform();
    final project = _cmsService.project;
    MeasurementHistoryResult? fullResults;
    var loopResults = state.loopResult;
    if (result != null && result.isLoopMeasurement) {
      fullResults = result.tests.first;
      loopResults = result;
    } else {
      fullResults = await _measurementResultService.getResultWithSpeedCurves(
            testUuid!,
            result: result?.tests.first,
            errorHandler: this,
          ) ??
          result?.tests.first;
    }
    emit(state.copyWith(
        result: fullResults,
        loopResult: loopResults,
        project: project,
        loading: false,
        appVersion: packageInfo.buildNumber.isEmpty
            ? packageInfo.version
            : '${packageInfo.version} (${packageInfo.buildNumber})'));
  }

  getPage(
    String route, {
    String? pageContent,
  }) async {
    final pageUrl = _cmsService.getPageUrl(route);
    String? pageDescription;
    if (pageContent == null) {
      emit(state.copyWith(
        loading: true,
      ));
      pageDescription =
          await _cmsService.getDescription(route, errorHandler: this);
      if (state.error != null) {
        return;
      }
    }
    emit(state.copyWith(
      staticPageContent: pageContent ?? pageDescription,
      loading: false,
      staticPageUrl: pageUrl,
    ));
  }

  @override
  process(Exception? error) {
    if (error != null) {
      emit(state.copyWith(
        error: error,
        loading: false,
      ));
    }
  }
}
