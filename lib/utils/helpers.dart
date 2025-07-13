import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';
import 'package:khub_mobile/injection_container.dart';

class Helpers {
  static String getCurrentDateTime() {
    DateTime now = DateTime.now();
    return now.toIso8601String();
  }

  static DateTime parseDate(String date) {
    try {
      return DateTime.parse(date);
    } catch (e) {
      return DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    }
  }

  static String formatDateTime(String date) {
    try {
      /// Convert into local date format.
      var localDate = DateTime.parse(date).toLocal();

      var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      var inputDate = inputFormat.parse(localDate.toString());

      var outputFormat = DateFormat('dd/MM/yyyy HH:mm');
      var outputDate = outputFormat.format(inputDate);

      return outputDate.toString();
    } on Exception {
      return date;
    }
  }

  static String formatDate(String date) {
    try {
      /// Convert into local date format.
      var localDate = DateTime.parse(date).toLocal();

      var inputFormat = DateFormat("yyyy-MM-dd");
      var inputDate = inputFormat.parse(localDate.toString());

      var outputFormat = DateFormat('dd/MM/yyyy');
      var outputDate = outputFormat.format(inputDate);

      return outputDate.toString();
    } on Exception {
      return date;
    }
  }

  static String formatCreditCardNumber(
      {required String cardNumber, bool mask = false}) {
    // Remove any existing spaces from the input
    cardNumber = cardNumber.replaceAll(' ', '');

    // Check if the card number is valid
    if (cardNumber.length < 16) {
      return '';
    }

    String maskedNumber = cardNumber;
    if (mask) {
      // Mask all but the last 4 digits
      maskedNumber = cardNumber.replaceRange(
          0, cardNumber.length - 4, '*' * (cardNumber.length - 4));
    }

    // Split the card number into groups of 4 digits and join them with a space
    final formatted = maskedNumber
        .replaceAllMapped(RegExp(r".{1,4}"), (match) => "${match.group(0)} ")
        .trim();

    return formatted;
  }

  static String maskCreditCardNumber(String cardNumber) {
    // Remove any existing spaces from the input
    cardNumber = cardNumber.replaceAll(' ', '');

    // Check if the card number is valid
    if (cardNumber.length < 16) {
      return '';
    }

    // Mask all but the last 4 digits
    String maskedNumber = cardNumber.replaceRange(
        0, cardNumber.length - 4, '*' * (cardNumber.length - 4));

    // Format the masked number with spaces every 4 digits
    final formatted = maskedNumber
        .replaceAllMapped(RegExp(r".{1,4}"), (match) => "${match.group(0)} ")
        .trim();

    return formatted;
  }

  static Map<String, String> extractNames(String fullName) {
    // Split the full name into parts
    List<String> nameParts = fullName.split(" ");

    // Extract the first name
    String firstName = nameParts.isNotEmpty ? nameParts[0] : "";

    // Combine the remaining parts as the last name
    String lastName =
        nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";

    return {
      "firstName": firstName,
      "lastName": lastName,
    };
  }

  static String resolveError(DioException? error) {
    String data = "";
    if (error == null) {
      data = 'Network error';
      return data;
    }

    // print(error.response);
    // debugPrint(error.requestOptions.toString());

    if (error.response != null) {
      final response = error.response;

      try {
        if (response != null && response.data != null) {
          final Map<String, dynamic> responseData =
              error.response?.data as Map<String, dynamic>;
          LOGGER.e(responseData);
          data = buildErrorMessage(responseData);
        }
      } catch (e) {
        data = 'Network error';
      }
    } else {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          data = 'Request timeout';
          break;
        case DioExceptionType.badCertificate:
          data = 'Bad certificate';
          break;
        case DioExceptionType.connectionError:
          data = 'No Internet Connection';
          break;
        default:
          data = 'Unable to process request.';
          break;
      }
    }

    return data;
  }

  static String buildErrorMessage(Map<String, dynamic> responseData) {
    if (responseData.containsKey('errors') &&
        responseData['errors'] is Map<String, dynamic>) {
      final errors = responseData['errors'] as Map<String, dynamic>;
      final errorMessages = errors.entries.map((entry) {
        final field = entry.key;
        final messages = entry.value as List;
        return '$field: ${messages.join(', ')}';
      }).join('\n');
      return errorMessages;
    } else if (responseData.containsKey('message')) {
      return responseData['message'] as String;
    }
    return 'An unknown error occurred';
  }

  static List<Color> generateShades(Color color) {
    List<Color> shades = [];
    // Generate shades by adjusting brightness
    for (int i = 1; i <= 9; i++) {
      double factor = i * 0.1;
      shades.add(Color.lerp(color, Colors.black, factor)!);
    }
    return shades;
  }

  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static List<T> pickNItems<T>(List<T> items, int n) {
    if (items.length <= n) {
      return items;
    }
    return items.sublist(0, n);
  }

  static String truncateHtmlText(String html, int maxLines) {
    if (html.isEmpty) return html;

    dom.Document document = html_parser.parse(html);
    StringBuffer buffer = StringBuffer();
    int linesCount = 0;

    // Function to recursively extract text from nodes
    void extractText(dom.Node node) {
      if (linesCount >= maxLines) return;

      if (node is dom.Element) {
        for (var child in node.nodes) {
          extractText(child);
          if (linesCount >= maxLines) break;
        }
      } else if (node is dom.Text) {
        List<String> lines = node.text.split('\n');
        for (String line in lines) {
          buffer.writeln(line);
          linesCount++;
          if (linesCount >= maxLines) break;
        }
      }
    }

    extractText(document.body!);

    return buffer.toString();
  }

  static int getRandomNumber() {
    var random = Random();
    return random.nextInt(999999);
  }

  static String? formatPhoneNumber(String? text) {
    if (text == null || text.isEmpty) return text;

    // Remove any non-digit characters except '+'
    text = text.replaceAll(RegExp(r'[^\d+]'), '');

    // Ensure it starts with '+'
    if (!text.startsWith('+')) {
      text = '+$text';
    }

    // Add space after country code (assuming country codes are 1-3 digits)
    final match = RegExp(r'^\+\d{1,3}').firstMatch(text);
    if (match != null) {
      final countryCode = text.substring(0, match.end);
      final number = text.substring(match.end);
      text = '$countryCode $number';
    }

    return text;
  }
}
