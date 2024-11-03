import 'dart:convert';

import 'package:flutter/services.dart';

class AssetService {

  AssetService();

  Future<Map<String, dynamic>> getList(String assetPath) async {
    final response = await rootBundle.loadString(assetPath);
    return jsonDecode(response).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getObject(String assetPath) async {
    final response = await rootBundle.loadString(assetPath);
    return jsonDecode(response);
  }


}