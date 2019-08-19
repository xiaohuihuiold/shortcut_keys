# shortcut_keys

[中文文档](README-CN.md)

适用与Flutter桌面程序自定义快捷键,支持104键以及鼠标滚轮和左键单击组合
`注:目前只有Windows和Linux平台能够完整支持,Android支持还不完整`

* 支持的平台
  * [x] Linux
  * [x] Windows
  * [x] Android(不完整)
  * [ ] iOS
  * [ ] macOS

## 使用方法

* 导入shortcut_keys.dart

```dart
import 'package:shortcut_keys/shortcut_keys.dart';
```

* 添加ShortcutKeysListener并使用FocusNode获得焦点
* shortcutData就是设置的快捷键
* 有鼠标的操作必须在方法里面加上接收event的参数
* 鼠标操作得在child范围内才行

```dart
  ShortcutKeysListener(
    focusNode: _node,
    child: .....,
    shortcutData: [
      // 无鼠标
      ShortcutData(
        shortcuts: [
          ShortcutKeys.CTRL_LEFT,
          ShortcutKeys.S,
        ],
        trigger: () {
          print('保存');
        },
      ),
      // 有鼠标
      ShortcutData(
        shortcuts: [
          ShortcutKeys.CTRL_LEFT,
          ShortcutKeys.ALT_LEFT,
          ShortcutKeys.MOUSE_REGION,
        ],
        trigger: (event) {
          print('滚动:$event');
        },
      ),
    ],
  );
```
