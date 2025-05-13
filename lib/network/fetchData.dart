import 'package:blog_client/network/proto.dart';
import 'package:blog_client/network/requests.dart';

class FetchData {
  static Future<List<FileInfo>> getFileInfo(String path) async {
    try {
      final fileInfo = await Request.getFileInfo(path);
      return fileInfo;
    } catch (e) {
      print(e);
      return [];
    }
  }
}