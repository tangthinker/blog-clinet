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

  @override
  void initState() {
    super.initState();
    _loadFileInfo();
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

  String _getPath() {
    return "/${_path.join("/")}/";
  }

  void _goBack() {
    setState(() {
      _path.removeLast();
    });
  }

  void _goForward(String path) {
    setState(() {
      _path.add(path);
    });
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
          const Center(child: Text("Welcome to Tangthinker Blog")),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 150),
            top: 0,
            bottom: 0,
            left: _drawerOpen ? 0 : -MediaQuery.of(context).size.width * 0.3,
            width: MediaQuery.of(context).size.width * 0.3,
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
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          "Contents",
                          style: TextStyle(color: CupertinoColors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ..._fileInfo.map((file) => SidebarItem(title: file.filename, onPressed: () {
                        if (file.dir) {
                          _goForward(file.filename);
                          _loadFileInfo();
                          _toggleDrawer();
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

  const SidebarItem({super.key,  required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      child: CupertinoListTile(
        title: Text(title, style: const TextStyle(fontSize: 12),),
        onTap: onPressed,
      ),
    );
  }
}

