import 'dart:convert';
import 'dart:io';
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
      );
      responseJson = _response(response);
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
      );
      responseJson = _response(response);
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
      );
      responseJson = _response(response);
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

      responseJson = _response(response);
      if (kDebugMode) {
        print(responseJson);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  static dynamic _response(http.Response response) {
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
        throw UnauthorisedException(response.body.toString());
      case 500:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}
