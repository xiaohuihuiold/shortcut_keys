import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shortcut_keys/shortcut_keys.dart';

void main() {
  _setTargetPlatformForDesktop();
  runApp(MyApp());
}

void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FocusNode _node = FocusNode();

  double _x = 0;
  double _y = 0;

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_node);
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: ShortcutKeysListener(
        focusNode: _node,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Text('x:$_x,y:$_y'),
        ),
        shortcutData: [
          ShortcutData(
            shortcuts: [
              ShortcutKeys.CTRL_LEFT,
              ShortcutKeys.S,
            ],
            trigger: () {
              print('保存');
            },
          ),
          ShortcutData(
            shortcuts: [
              ShortcutKeys.CTRL_LEFT,
              ShortcutKeys.C,
            ],
            trigger: () {
              print('复制');
            },
          ),
          ShortcutData(
            shortcuts: [
              ShortcutKeys.CTRL_LEFT,
              ShortcutKeys.ALT_LEFT,
              ShortcutKeys.L,
            ],
            trigger: () {
              print('格式化');
            },
          ),
          ShortcutData(
            shortcuts: [
              ShortcutKeys.CTRL_LEFT,
              ShortcutKeys.ALT_LEFT,
              ShortcutKeys.MOUSE_REGION,
            ],
            trigger: (event) {
              PointerHoverEvent point = event;
              setState(() {
                _x = point.position.dx;
                _y = point.position.dy;
              });
            },
          ),
        ],
      ),
    );
  }
}
