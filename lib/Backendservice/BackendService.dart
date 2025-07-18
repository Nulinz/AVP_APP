// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart';

// class Backendservice {
//   static Future<Map<String, dynamic>> UploadFiles(
//       Map<String, dynamic> login, String url, String method) async {
//     print(url);
//     var request = http.MultipartRequest(method, Uri.parse(url));
//     // Add headers
//     request.headers.addAll({
//       'Content-Type': 'multipart/form-data',
//       "Cache-Control": "no-cache",
//     });

//     // Add other form fields
//     login.forEach((key, value) {
//       if (key != 'file') {
//         request.fields[key] = value.toString();
//       }
//     });

//     // Attach file if present
//     if (login.containsKey('file') && login['file'] is String) {
//       String filePath = login['file'];
//       File file = File(filePath);

//       if (await file.exists()) {
//         request.files.add(
//           await http.MultipartFile.fromPath(
//             'file',
//             file.path,
//             filename: file.uri.pathSegments.last,
//           ),
//         );
//       }
//     }

//     // Send request
//     var streamedResponse = await request.send();
//     var response = await http.Response.fromStream(streamedResponse);

//     print(response.body);

//     if (response.statusCode == 400) {
//       return {
//         'notregistered': true,
//         'data': 'user not registered',
//       };
//     } else if (response.statusCode == 200) {
//       var jsonData = jsonDecode(response.body);
//       return {
//         'success': true,
//         'data': jsonData['data'],
//       };
//     } else if (response.statusCode == 404 || response.statusCode == 401) {
//       return {
//         'notregistered': true,
//         'data': 'user not registered',
//       };
//     } else {
//       print(response.statusCode);
//       return {
//         'success': false,
//         'notregistered': false,
//       };
//     }
//   }
// static Future<Map<String, dynamic>> function(
//   Map<String, dynamic> data,
//   String url,
//   String method, {
//   bool isFormData = false,
// }) async {
//   if (isFormData) {
//     var request = http.MultipartRequest(method, Uri.parse(url));

//     request.headers.addAll({
//       'Accept': 'application/json',
//       'Content-Type': 'multipart/form-data',
//     });

//     data.forEach((key, value) {
//       request.fields[key] = value.toString();
//     });

//     var streamedResponse = await request.send();
//     var response = await http.Response.fromStream(streamedResponse);

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       return {
//         'success': false,
//         'message': 'Error: ${response.statusCode}',
//         'body': response.body,
//       };
//     }
//   } else {
//     // JSON body (for other cases)
//     final response = await Dio().request(
//       url,
//       data: data,
//       options: Options(
//         method: method,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       ),
//     );

//     dynamic jsonData = response.data;

//     if (jsonData is String) {
//       try {
//         jsonData = json.decode(jsonData);
//       } catch (e) {
//         throw Exception("Invalid JSON response");
//       }
//     }

//     if (jsonData is Map<String, dynamic>) {
//       return jsonData;
//     } else {
//       throw Exception("Unexpected response format");
//     }
//   }
// }
// }

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Backendservice {
  // Upload files with optional token
  static Future<Map<String, dynamic>> UploadFiles(
      Map<String, dynamic> login, String url, String method) async {
    print("Uploading to URL: $url");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    var request = http.MultipartRequest(method, Uri.parse(url));

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
      'Cache-Control': 'no-cache',
    });

    login.forEach((key, value) {
      if (key != 'file') {
        request.fields[key] = value.toString();
      }
    });

    // Attach file if present
    if (login.containsKey('file') && login['file'] is String) {
      String filePath = login['file'];
      File file = File(filePath);

      if (await file.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
            filename: file.uri.pathSegments.last,
          ),
        );
      }
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print(response.body);

    if (response.statusCode == 400) {
      return {
        'notregistered': true,
        'data': 'user not registered',
      };
    } else if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return {
        'success': true,
        'data': jsonData['data'],
      };
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      return {
        'notregistered': true,
        'data': 'user not registered',
      };
    } else {
      print("Error ${response.statusCode}");
      return {
        'success': false,
        'notregistered': false,
      };
    }
  }

  // Generic request function
  static Future<Map<String, dynamic>> function(
    Map<String, dynamic> data,
    String url,
    String method, {
    bool isFormData = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (isFormData) {
      var request = http.MultipartRequest(method, Uri.parse(url));

      request.headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      });

      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Error: ${response.statusCode}',
          'body': response.body,
        };
      }
    } else {
      try {
        final response = await Dio().request(
          url,
          data: data,
          options: Options(
            method: method,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            validateStatus: (status) => status! < 500, 
          ),
        );

        dynamic jsonData = response.data;

        if (jsonData is String) {
          try {
            jsonData = json.decode(jsonData);
          } catch (e) {
            throw Exception("Invalid JSON response");
          }
        }

        if (jsonData is Map<String, dynamic>) {
          return jsonData;
        } else {
          throw Exception("Unexpected response format");
        }
      } on DioError catch (e) {
        print("❌ Dio error: ${e.response?.statusCode} - ${e.response?.data}");

        if (e.response?.statusCode == 401) {
          throw Exception(
              "Unauthorized (401): Token may be missing or expired");
        }

        throw Exception("Network or server error: ${e.message}");
      }
    }
  }
}
