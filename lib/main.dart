import 'dart:io';
import 'package:blog_client/network/requests.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog_client/network/proto.dart';
import 'package:blog_client/network/fetchData.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Tangthinker Blog',
      initialRoute: '/',
      routes: {
        '/': (context) => const OpenDrawerScreen(),
      },

    );
  }
}

class OpenDrawerScreen extends StatefulWidget {
  const OpenDrawerScreen({super.key});

  @override
  State<OpenDrawerScreen> createState() => _OpenDrawerScreenState();
}

class _OpenDrawerScreenState extends State<OpenDrawerScreen> {
  bool _drawerOpen = false;
  List<FileInfo> _fileInfo = [];
  final List<String> _path = [];
  String content = "# Welcome to Tangthinker Blog";

  double sidebarWidth() {
    if(checkPlatform()) {
      return 0.6;
    }
    return 0.3;
  }

  int sidebarContentTopPadding() {
    if (checkPlatform()) {
      if (Platform.isAndroid) {
        return 50;
      }
      return 80;
    }
    return 10;
  }

  bool checkPlatform() {
    if (kIsWeb) {
      return false;
    }
    if (Platform.isAndroid || Platform.isIOS) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _loadFileInfo();
  }

  void _loadFileContent(String path) async {
    final content = await FetchData.getFileContent(_getPath() + path);
    setState(() {
      this.content = content;
    });
  }

  void _loadFileInfo() async {
    final currentPath = _getPath();
    final files = await FetchData.getFileInfo(currentPath);
    setState(() {
      _fileInfo = files;
    });
  }

  void _toggleDrawer() {
    setState(() {
      _drawerOpen = !_drawerOpen;
    });
  }

  bool _isRootPath() {
    return _path.isEmpty;
  }

  String _getPath() {
    return "/${_path.join("/")}/";
  }

  void _goBack() {
    if(_path.isEmpty) {
      return;
    }
    setState(() {
      _path.removeLast();
    });
    _loadFileInfo();
  }

  void _goForward(String path) {
    setState(() {
      _path.add(path);
    });
    _loadFileInfo();
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Tangthinker Blog"),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _toggleDrawer,
          child: const Icon(CupertinoIcons.bars),
        ),
      ),
      child: Stack(
        children: [
           Container(
             padding: const EdgeInsets.only(top: 100, left: 10, right: 10),
               child: Markdown(
                data: content,
                sizedImageBuilder: (config) {
                  return Center(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Image.network(baseUrl + config.uri.toString())
                    ),
                  );
                },
                )
           ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 150),
            top: 0,
            bottom: 0,
            left: _drawerOpen ? 0 : -MediaQuery.of(context).size.width * sidebarWidth(),
            width: MediaQuery.of(context).size.width * sidebarWidth(),
            child: GestureDetector(
              onTap: () {},
              child: Material(
                color: Colors.transparent,
                child: Container(
                  color: CupertinoColors.systemGroupedBackground,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(height: 50,),
                      Container(
                        padding: EdgeInsets.only(top: sidebarContentTopPadding().toDouble(), left: 16, right: 16, bottom: 16),
                        child: const Text(
                          "Contents",
                          style: TextStyle(color: CupertinoColors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (!_isRootPath())
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 15, left: 20, right: 20),
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: CupertinoColors.activeBlue,
                                width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: _goBack,
                            child: const Text("Back", style: TextStyle(fontSize: 12, color: CupertinoColors.activeBlue),),
                          ),
                        ),
                      ),
                      ..._fileInfo.map((file) => SidebarItem(title: file.filename, isDir:  file.dir,
                          onPressed: () {
                            if (file.dir) {
                              _goForward(file.filename);
                            } else {
                              _loadFileContent(file.filename);
                            }
                      })),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {

  final void Function() onPressed;

  final String title;
  
  final bool isDir;

  const SidebarItem({super.key,  required this.title, required this.isDir, required this.onPressed});

  @override
  Widget build(BuildContext context) {

    final Widget icon = Padding(
      padding: const EdgeInsets.only(right: 5),
      child: isDir ? Icon(CupertinoIcons.folder, size: 15,) : Icon(CupertinoIcons.doc, size: 15,),
    );

    return SizedBox(
      height: 25,
      child: CupertinoListTile(
          padding: EdgeInsets.only(left: 10),
          title: Row(
            children: [
              icon,
              Text(title, style: const TextStyle(fontSize: 12),),
            ],
          ),
          onTap: onPressed,
      ),
    );
  }
}

