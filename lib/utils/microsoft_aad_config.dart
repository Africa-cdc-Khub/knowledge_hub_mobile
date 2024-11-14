import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';
import 'package:khub_mobile/api/config/env_config.dart';
import 'package:khub_mobile/ui/elements/loading_view.dart';

class MicrosoftAadConfig {
  static const microsoftScope = 'openid profile offline_access';
  static const microsoftRedirectUri =
      'https://khub.africacdc.org/auth/microsoft/callback';

  static Config microsoftConfig(GlobalKey<NavigatorState> navigatorKey) {
    return Config(
      tenant: "common", // Set this to "common" for multi-tenant apps
      clientId: EnvConfig.microsoftClientId,
      scope: microsoftScope,
      clientSecret: EnvConfig.microsoftClientSecret,
      navigatorKey: navigatorKey,
      redirectUri: microsoftRedirectUri,
      loader: Center(child: LoadingView()),
    );
  }
}
