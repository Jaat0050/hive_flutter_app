import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

class APIvalue {
  static String url = 'https://lazeezbox.com/public/';

  //==========================================Authentication==================================================

  String getTokkenURL = "${url}api/authenticate";
  String getTokenURL = "https://lazeezbox.com/oauth/token";
  String sendotpURL = "${url}api/send-otp";
  String registerURL = "${url}api/register-user";

  String logoutURL = "https://lazeezbox.com/oauth/revoke";
  String refreshURL = "${url}api/refresh";
  String userDetailsURL = "${url}api/user";

  String getListOfAllUsersURL = "${url}api/chatlist";

  //==========================================Home Screen=======================================================================

  //==========================================Delivery Screen=======================================================================

  //==========================================Profile Screen==================================================================================

  final Dio _dio = Dio();

  Future<dynamic> gettoken(String number, String otp) async {
    try {
      dynamic data = {'phone': number, 'otp': otp};
      print('data=====$data');

      final response = await _dio.post(getTokkenURL,
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
          ),
          data: data);
      if (response.statusCode == 200) {
        final responseBody = response.data as Map<String, dynamic>;
        return responseBody;
      } else {
        print('Error sending OTP: ${response.data}');
        return {'error': 'Server responded with an error: ${response.data}'};
      }
    } catch (e, s) {
      print('Error: $e');
      print('Stacktrace: $s');
      return {'error': 'An error occurred while fetching the token: $e'};
    }
  }

  Future<bool> sendOtp(String number) async {
    try {
      dynamic data = {
        'phone': number,
      };
      print('data=====$data');

      final response = await _dio.post(sendotpURL,
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
          ),
          data: data);

      if (response.statusCode == 200) {
        final responseBody = response.data as Map<String, dynamic>;
        print('Response: $responseBody');
        return true;
      } else {
        print('Error sending OTP: ${response.data}');
        return false;
      }
    } catch (e, s) {
      print('Error: $e');
      print('Stacktrace: $s');
      return false;
    }
  }

  Future<dynamic> registerUser({
    required String token,
    required String name,
    required String dob,
    required String gender,
  }) async {
    try {
      dynamic data = {
        'name': name,
        'dateofbirth': dob,
        'gender': gender,
      };
      print('Sending data: $data');

      final response = await _dio.post(registerURL,
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              'Authorization': 'Bearer $token',
            },
          ),
          data: data);

      if (response.statusCode == 200) {
        final responseBody = response.data as Map<String, dynamic>;
        print('Response: $responseBody');
        return responseBody;
      } else {
        final responseBody = response.data as Map<String, dynamic>;
        print('Response: $responseBody');
        return responseBody;
      }
    } catch (e, s) {
      print('Error: $e');
      print('Stacktrace: $s');
      return false;
    }
  }

  Future<dynamic> logout(String token) async {
    try {
      final response = await _dio.post(logoutURL,
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              'Authorization': 'Bearer $token',
            },
          ));
      if (response.statusCode == 200) {
        final responseBody = response.data as Map<String, dynamic>;
        print('Response: $responseBody');

        return true;
      } else {
        print('Error registering user: ${response.data}');
        return false;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<dynamic> refresh(String token) async {
    try {
      final response = await _dio.post(refreshURL,
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              'Authorization': 'Bearer $token',
            },
          ));
      print('=================<<<<<<<<<<<<<<$token>>>>>>>>>>>>>>>>>>');
      if (response.statusCode == 200) {
        final responseBody = response.data as Map<String, dynamic>;
        return responseBody;
      } else {
        final responseBody = response.data as Map<String, dynamic>;
        return responseBody;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<dynamic> userDeatails(String token) async {
    try {
      final response = await _dio.get(userDetailsURL,
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              'Authorization': 'Bearer $token',
            },
          ));
      if (response.statusCode == 200) {
        final responseBody = response.data as Map<String, dynamic>;
        print('Response: $responseBody');
        return responseBody;
      } else {
        final responseBody = response.data as Map<String, dynamic>;
        print('Response: $responseBody');
        return responseBody;
      }
    } catch (e) {
      print('=================<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>');
      log(e.toString());
    }
  }

  Future<dynamic> getListOfAllUsers(String token) async {
    try {
      print('^^^^^^^^^^^^^^^^^^^^^^^^^^^6');
      final response = await _dio.get(getListOfAllUsersURL,
          options: Options(
            headers: {
              // HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.acceptHeader: "application/json",
              'Authorization': 'Bearer $token',
            },
          ));
      if (response.statusCode == 200) {
        final responseBody = response.data;
        print('Response: $responseBody');
        return responseBody;
      } else {
        final responseBody = response.data;
        print('Response: ===========$responseBody');
        return responseBody;
      }
    } catch (e) {
      log(e.toString());
      print('---------------00000000000000------------');
    }
  }

  Future<dynamic> gettokken(String code) async {
    try {
      final data = {
        'grant_type': 'authorization_code',
        'client_id': '6',
        'redirect_uri': 'http://example.com/callback',
        'code': code,
        // 'code_verifier': 'Dxbrh55Y8PUMF4Hulhq3GfW7ajV8FIOGTTB9PjjGXF4',
        'client_secret': '8LZmlHXszGeJHGeRE8LLtd9VsoYYBvBXTQEYkZp7',
        // Uncomment the below lines if needed.
        // 'refresh_token': 'YOUR_REFRESH_TOKEN',
        // 'username': 'wajahath',
        // 'password': '12345678',
        // 'scope': ''
      };
      print('=======q=q=q=q=qq======$data');

      final response = await _dio.post(getTokenURL, data: data);
      print('===============================R====$response');

      if (response.statusCode == 200) {
        print(response.data); // Print the response body
        return response.data;
      } else {
        print('Error with status code: ${response.statusCode}');
      }
    } catch (e, s) {
      print('Error: $e');
      print('Stacktrace: $s');
      return {'error': 'An error occurred while fetching the token: $e'};
    }
  }
}

APIvalue apiValue = APIvalue();
