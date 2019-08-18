import 'dart:io';

import 'package:flutter/foundation.dart';
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
          child: Text(''),
        ),
        shortcuts: {
          [ShortcutKeys.CTRL_LEFT, ShortcutKeys.S]: () {
            print('保存');
          },
          [ShortcutKeys.CTRL_LEFT, ShortcutKeys.C]: () {
            print('复制');
          },
          [ShortcutKeys.CTRL_LEFT, ShortcutKeys.ALT_LEFT, ShortcutKeys.L]: () {
            print('格式化');
          },
          [ShortcutKeys.CTRL_LEFT, ShortcutKeys.MOUSE_SCROLL]: (event) {
            print('滚动:$event');
          },
        },
      ),
    );
  }
}
