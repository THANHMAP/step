import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/shared/SPref.dart';

import 'custom_exception.dart';

class APIManager {
  static var client = http.Client();

  static Future<dynamic> postAPICallNoNeedToken(String url, dynamic param) async {
    print("Calling API: $url");
    print("Calling parameters: $param");

    var responseJson;
    try {
      var response = await client.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: param,
      ).timeout(const Duration(seconds: 15),onTimeout : () {
        throw TimeoutException('The connection has timed out, Please try again!');
      });
      responseJson = responseCode(response);
      if (kDebugMode) {
        print(responseJson);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  static Future<dynamic> getAPICallNoNeedToken(String url) async {
    print("Calling API: $url");
    var responseJson;
    try {
      var response = await client.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15),onTimeout : () {
        throw TimeoutException('The connection has timed out, Please try again!');
      });
      responseJson = responseCode(response);
      if (kDebugMode) {
        print(responseJson);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  static Future<dynamic> postAPICallNeedToken(String url, dynamic param) async {
    print("Calling API: $url");
    print("Calling parameters: $param");
    var token = await SPref.instance.get("token");
    var responseJson;
    try {
      var response = await client.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: param,
      ).timeout(const Duration(seconds: 15),onTimeout : () {
        throw TimeoutException('The connection has timed out, Please try again!');
      });
      responseJson = responseCode(response);
      if (kDebugMode) {
        print(responseJson);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  static Future<dynamic> getAPICallNeedToken(String url) async {
    print("Calling API: $url");
    var token = await SPref.instance.get("token");
    var responseJson;
    try {
      var response = await client.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15),onTimeout : () {
        throw TimeoutException('The connection has timed out, Please try again!');
      });
      responseJson = responseCode(response);
      if (kDebugMode) {
        print(responseJson);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  static Future<dynamic> uploadImageHTTP(file, String url) async {
    print("Calling uploadImageHTTP: $url");
    var responseJson;
    var token = await SPref.instance.get("token");
    Map<String, String> headers = {'Authorization': 'Bearer $token'};
    try {
      var request =
      http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      request.files.add(await http.MultipartFile.fromPath('avatar', file.path));
      var response = await http.Response.fromStream(await request.send());

      responseJson = responseCode(response);
      if (kDebugMode) {
        print(responseJson);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  static Future<dynamic> uploadImageHTTPWithParam(File file, String name, String nd, String url) async {
    print("Calling uploadImageHTTP: $url");
    var responseJson;
    var token = await SPref.instance.get("token");
    Map<String, String> headers = {'Authorization': 'Bearer $token'};
    try {
      var request =
      http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      request.fields['name'] = name;
      request.fields['content'] = nd;
      request.files.add(await http.MultipartFile.fromPath('error_image', file.path));
      var response = await http.Response.fromStream(await request.send());

      responseJson = responseCode(response);
      if (kDebugMode) {
        print(responseJson);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  static dynamic responseCode(http.Response response) async {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 201:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
      await SPref.instance.set("token", "");
      await SPref.instance.set("info_login", "");
      Get.offAllNamed("/login"
          "");
        throw UnauthorisedException(response.body.toString());
      case 500:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}
