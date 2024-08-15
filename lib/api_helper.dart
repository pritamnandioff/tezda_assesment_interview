import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:tezda/const/api_const.dart';
import 'package:tezda/utils/exceptions.dart';

// ignore: constant_identifier_names
enum RequestType { GET, POST, PUT, DELETE, PATCH }

class ApiResponse {
  final http.Response response;
  final int statusCode;
  ApiResponse(this.response, this.statusCode);
}

class ApiProvider {
  final box = GetStorage();

  static String baseUrl = '${ApiConstants.baseURL}/api/v1/';
  static String accessTokenKey = "accessToken";
  static String refreshTokenKey = "RefreshToken";

  static Future<ApiResponse> request(
      RequestType type, String endpoint, dynamic data,
      {Map<String, dynamic>? pathVariables,
      Map<String, dynamic>? queryParams,
      Map<String, File>? files}) async {
    final url = _buildUrl(baseUrl, endpoint, pathVariables, queryParams);
    final token = await _getAccessToken();
    final response = await _sendRequest(type, url, token, data, files);

    _printRequestInfo(
      type,
      url,
      response.statusCode,
      response.body,
      requestBody: data,
    );
    _handleResponse(response);
    return ApiResponse(response, response.statusCode);
  }

  static String _buildUrl(
      String baseUrl, String endpoint, Map<String, dynamic>? pathVariables,
      [Map<String, dynamic>? queryParams]) {
    var url = '$baseUrl$endpoint';
    if (pathVariables != null && pathVariables.isNotEmpty) {
      pathVariables.forEach((key, value) {
        url = url.replaceAll('{$key}', value.toString());
      });
    }
    if (queryParams != null && queryParams.isNotEmpty) {
      final queryString = Uri(queryParameters: queryParams).query;
      url += '?$queryString';
    }
    return url;
  }

  static Future<String> _getAccessToken() async {
    final box = GetStorage();
    await box.initStorage;

    return box.read(accessTokenKey) ?? "";
  }

  static Future<http.Response> _sendRequest(
      RequestType type, String url, String token, dynamic data,
      [Map<String, File>? files]) async {
    if (files != null && files.isNotEmpty) {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(_getHeaders(token));
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });
      for (var entry in files.entries) {
        request.files.add(await http.MultipartFile.fromPath(
          entry.key,
          entry.value.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }
      var streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } else {
      switch (type) {
        case RequestType.GET:
          return http.get(Uri.parse(url), headers: _getHeaders(token));
        case RequestType.POST:
          return http.post(Uri.parse(url),
              headers: _getHeaders(token), body: jsonEncode(data));
        case RequestType.PUT:
          return http.put(Uri.parse(url),
              headers: _getHeaders(token), body: jsonEncode(data));
        case RequestType.DELETE:
          return http.delete(Uri.parse(url),
              headers: _getHeaders(token), body: jsonEncode(data));
        case RequestType.PATCH:
          return http.patch(Uri.parse(url),
              headers: _getHeaders(token), body: jsonEncode(data));
      }
    }
  }

  static Map<String, String> _getHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      // 'Access-Control-Allow-Origin': baseUrl,
      'Access-Control-Allow-Origin': "*",

      'Access-Control-Allow-Methods':
          'OPTIONS, HEAD, GET, POST, PUT, DELETE, PATCH',
      // 'Access-Control-Allow-Headers':
      //     'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'
      // ,
      "Access-Control-Allow-Headers": "Content-Type",
      "Authorization"
          'X-Requested-With': '*',
    };
  }

  static dynamic _handleResponse(http.Response response) {
    final int statusCode = response.statusCode;
    final dynamic responseBody = json.decode(response.body);

    switch (statusCode) {
      case 200:
      case 201:
        return responseBody;
      case 400:
        throw BadRequest(responseBody['message']);
      case 401:
        throw UnauthorizedException(responseBody['message']);
      case 404:
        throw NotFoundException(responseBody['message']);
      case 409:
        throw UserAlreadyExists(responseBody['message']);
      case 410:
        return responseBody;
      case 426:
      case 440:
        // _showSessionExpiredDialog();
        throw LoginTimeOutException('Session expired. Please re-login.');
      case 500:
        throw InternalServerErrorException(responseBody['message']);

      case 503:
      default:
        throw Exception(
            'Failed to load data: $statusCode. URL: ${response.request!.url}');
    }
  }

  static void _printRequestInfo(
      RequestType method, String url, int statusCode, dynamic responseBody,
      {dynamic requestBody}) {
    bool isSuccess = statusCode == 200 || statusCode == 201;
    final colorEmoji = isSuccess ? '✅' : '❌';
    final urlColor = isSuccess
        ? '\x1B[32m'
        : '\x1B[31m'; // Green for success, red for failure
    final message = '$colorEmoji [$method|$statusCode] $urlColor$url\x1B[0m';
    if (!isSuccess) {
      debugPrint(
          '\n\x1B[33m┌───────────────────────────────────────────────┐\x1B[0m');
    }
    debugPrint(message);

    if (!isSuccess) {
      debugPrint(
          '\x1B[33m│\x1B[0m \x1B[33m===============================================\x1B[0m');
    }
    // Print request message
    if (!isSuccess) {
      if (method == RequestType.POST && requestBody != null && !isSuccess) {
        debugPrint('Request Body: $requestBody');
      }
    }
    if (!isSuccess) {
      debugPrint(
          '\x1B[33m│\x1B[0m \x1B[33m===============================================\x1B[0m');
    }

    if (!isSuccess) {
      if ((method == RequestType.GET || responseBody != null)) {
        if (kDebugMode) {
          debugPrint('Response Body: $responseBody');
        }
      }
    }
    if (!isSuccess) {
      debugPrint(
          '\x1B[33m└───────────────────────────────────────────────┘\x1B[0m');
    }
  }

  // static void _showSessionExpiredDialog() {
  //   // Use Get's dialog system to show the session expired dialog
  //   Get.dialog(
  //     AlertDialog(
  //       title: const Text('Session Expired'),
  //       content: const Text('Your session has expired. Please log in again.'),
  //       actions: [
  //         ElevatedButton(
  //           onPressed: () {
  //             // GetStorage().erase().then((value) => Get.toNamed(AppRoute.login));
  //           },
  //           child: const Text('Log In'),
  //         ),
  //       ],
  //     ),
  //     barrierDismissible: false,
  //   );
  // }

  // static Future<Uint8List> getImageData(String endpoint,
  //     {Map<String, dynamic>? pathVariables,
  //     Map<String, dynamic>? queryParams}) async {
  //   final url = _buildUrl(baseUrl, endpoint, pathVariables, queryParams);
  //   final token = await _getAccessToken();
  //   final response =
  //       await http.get(Uri.parse(url), headers: _getHeaders(token));

  //   _printRequestInfo(
  //     RequestType.GET,
  //     url,
  //     response.statusCode,
  //     response.body,
  //   );

  //   if (response.statusCode == 200) {
  //     return response.bodyBytes;
  //   } else {
  //     _handleResponse(response);
  //     return Uint8List(0); // Empty byte list in case of error
  //   }
  // }
}

void catchMatcher(dynamic e) {
  if (e is BadRequest) {
    Get.snackbar(
      'Bad Request',
      e.message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } else if (e is UnauthorizedException) {
    Get.snackbar(
      'Unauthorized',
      e.message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } else if (e is NotFoundException) {
    Get.snackbar(
      'Not Found',
      e.message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } else if (e is UserAlreadyExists) {
    Get.snackbar(
      'Error',
      e.message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } else if (e is LoginTimeOutException) {
    Get.snackbar(
      'Session Expired',
      e.message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } else if (e is InternalServerErrorException) {
    Get.snackbar(
      'Internal Server Error',
      e.message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } else {
    print(e.toString());
    Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
  }
}
