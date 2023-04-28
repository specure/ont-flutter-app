import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/core/widgets/basic.bottom-sheet.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/error.widget.dart';
import 'package:nt_flutter_standalone/core/wrappers/url-launcher-wrapper.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.cubit.dart';
import 'package:nt_flutter_standalone/modules/measurement-result/store/measurement-result.state.dart';

class ResultBottomSheet extends DraggableScrollableSheet {
  static String _pageUrl = "";
  static String? _pageContent;
  static double _estimateMaxHeight(
      BuildContext context, MeasurementResultState state) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return 1;
    }
    return 0.8;
  }

  static double _contentSize(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.8;
  }

  static double _estimateMinHeight(
      BuildContext context, MeasurementResultState state) {
    return min(0.2, ResultBottomSheet._estimateMaxHeight(context, state) - 0.1);
  }

  static Widget _build(_, controller) {
    GetIt.I
        .get<MeasurementResultCubit>()
        .getPage(_pageUrl, pageContent: _pageContent);
    return BasicBottomSheet(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: BlocBuilder<MeasurementResultCubit, MeasurementResultState>(
          builder: (context, state) {
        return Scaffold(
          // This is a workaround that makes snack bars appear _above_
          // the bottom sheet. Floating snackbars are shown above FABs,
          // so we just create an invisible, zero-size FAB here.
          floatingActionButton: const SizedBox(height: 1),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConditionalContent(
                  conditional: !state.loading,
                  truthyBuilder: () => state.error != null
                      ? NTErrorWidget(state.errorMessage!)
                      : Container(
                          height: _contentSize(context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: _contentSize(context) - 130,
                                child: Markdown(
                                  shrinkWrap: true,
                                  data: state.staticPageContent,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  _launchURL(
                                    context,
                                    Uri.parse(state.staticPageUrl),
                                  );
                                },
                                child: Text(
                                  "Read more on our website".translated,
                                  style: TextStyle(
                                    color: NTColors.primary,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              )
                            ],
                          ),
                        ),
                  falsyBuilder: () => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: NTColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  static _launchURL(BuildContext context, Uri url) async {
    var urlLauncherWrapper = GetIt.I.get<UrlLauncherWrapper>();
    try {
      if (await urlLauncherWrapper.canLaunch(url)) {
        await urlLauncherWrapper.launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (_) {
      final snackBar = SnackBar(
        content: const Text('Unable to open the page.'),
        behavior: SnackBarBehavior.floating,
        elevation: 1000,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  ResultBottomSheet(context, state, {String pageUrl = "", String? pageContent})
      : super(
          initialChildSize:
              ResultBottomSheet._estimateMaxHeight(context, state),
          minChildSize: ResultBottomSheet._estimateMinHeight(context, state),
          maxChildSize: ResultBottomSheet._estimateMaxHeight(context, state),
          expand: false,
          builder: ResultBottomSheet._build,
        ) {
    _pageUrl = pageUrl;
    _pageContent = pageContent;
  }
}
