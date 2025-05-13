import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';


import 'package:blog_client/network/proto.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "https://tangthinker.com";

class Request {
  static Future<List<FileInfo>> getFileInfo(String path) async {
    final response = await http.post(Uri.parse('$baseUrl/api/v1/storage/ls'), body: {
      'path': path,
    });

    if (response.statusCode == 200) {
      final List<FileInfo> fileInfo = [];
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      for (var item in (json['data'] as List<dynamic>)) {
        fileInfo.add(FileInfo.fromJson(item));
      }
      return fileInfo;
    }

    throw Exception('Failed to load file info');
  }

  static Future<String> getFileContent(String path) async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/storage/get?filepath=$path'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      List<int> decodedBytes =  base64Decode(json['data'] as String);
      return utf8.decode(decodedBytes);
    }

    throw Exception('Failed to load file content');
  }
}