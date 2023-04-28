import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/colors.dart';
import 'package:nt_flutter_standalone/core/services/navigation.service.dart';
import 'package:nt_flutter_standalone/core/widgets/app-bar.widget.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.cubit.dart';
import 'package:nt_flutter_standalone/modules/settings/store/settings.state.dart';

import '../../../core/constants/dimensions.dart';
import '../models/language.dart';

class LanguagesScreen extends StatelessWidget {
  static const route = 'settings/languages';
  static final closeButtonKey = UniqueKey();

  const LanguagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: NTAppBar(
        titleText: "Language",
        actions: [
          IconButton(
            key: closeButtonKey,
            onPressed: () {
              GetIt.I.get<NavigationService>().goBack();
            },
            icon: Icon(
              Icons.close,
              color: NTColors.primary,
            ),
          ),
        ],
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) => ListView.builder(
              itemCount: state.supportedLanguages?.length ?? 0,
              itemBuilder: (context, index) {
                final language = state.supportedLanguages?[index];
                return ConditionalContent(
                  conditional: language != null,
                  truthyBuilder: () => _Language(language: language!),
                );
              })),
    );
  }
}

class _Language extends StatelessWidget {
  const _Language({
    Key? key,
    required this.language,
  }) : super(key: key);

  final Language language;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) => InkWell(
              onTap: () async {
                GetIt.I.get<SettingsCubit>().setLanguage(language);
                GetIt.I.get<NavigationService>().goBack();
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 22, 26, 22),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: NTColors.lightBackground,
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            language.nativeName,
                            style: TextStyle(fontSize: NTDimensions.textM),
                          ),
                        ),
                      ),
                      ConditionalContent(
                        conditional: (language.languageCode ==
                                state.selectedLanguage?.languageCode &&
                            language.scriptCode ==
                                state.selectedLanguage?.scriptCode || (state.selectedLanguage == null && language.languageCode == 'Default')),
                        truthyBuilder: () => Container(
                          height: 14,
                          width: 18,
                          margin:
                              EdgeInsets.only(left: 26, bottom: 10, right: 7),
                          child: Icon(
                            Icons.check,
                            color: NTColors.primary,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
