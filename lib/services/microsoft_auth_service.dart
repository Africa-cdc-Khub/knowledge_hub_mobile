import 'package:aad_oauth/aad_oauth.dart';
import 'package:flutter/material.dart';
import 'package:khub_mobile/utils/microsoft_aad_config.dart';

class MicrosoftAuthService {
  static final MicrosoftAuthService _instance =
      MicrosoftAuthService._internal();
  late final AadOAuth oauth;

  factory MicrosoftAuthService() {
    return _instance;
  }

  MicrosoftAuthService._internal();

  void initialize(GlobalKey<NavigatorState> navigatorKey) {
    final config = MicrosoftAadConfig.microsoftConfig(navigatorKey);
    oauth = AadOAuth(config);
  }
}
