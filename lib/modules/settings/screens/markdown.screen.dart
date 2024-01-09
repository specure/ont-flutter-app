import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/core/widgets/error.widget.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:html/dom.dart' as dom;
import 'package:markdown/markdown.dart' show markdownToHtml;

class MarkdownScreen extends StatelessWidget {
  static const route = 'settings/markdown';

  const MarkdownScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: GetIt.I.get<SettingsCubit>(),
      builder: (context, state) => Scaffold(
        appBar: NTAppBar(
          titleText: state.staticPageTitle,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: NTColors.primary,
            onPressed: () => GetIt.I.get<NavigationService>().goBack(),
          ),
        ),
        body: ConditionalContent(
          conditional: !state.loading,
          truthyBuilder: () => state.error != null
              ? NTErrorWidget(state.errorMessage!)
              : Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
                  child: SingleChildScrollView(
                    child: Html(
                      data:
                          markdownToHtml(state.staticPageContent.markdownReady),
                      onLinkTap: (String? url, Map<String, String> attributes,
                          dom.Element? element) {
                        final fixedUrl = url?.asCmsUrl;
                        if (fixedUrl != null) {
                          launchUrlString(fixedUrl);
                        }
                      },
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
    );
  }
}
