
// [
//         {
//             "Filename": "十九",
//             "Size": 4096,
//             "Path": "/十九/",
//             "Dir": true,
//             "Timestamp": 1736821906
//         },
// ]

class FileInfo {
  final String filename;
  final int size;
  final String path;
  final bool dir;
  final int timestamp;

  FileInfo({required this.filename, required this.size, required this.path, required this.dir, required this.timestamp});

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      filename: json['Filename'],
      size: json['Size'],
      path: json['Path'],
      dir: json['Dir'],
      timestamp: json['Timestamp'],
    );
  }
}

