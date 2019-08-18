import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../shortcut_keys.dart';

/// 快捷键监听部件
class ShortcutKeysListener extends StatefulWidget {
  /// 设置当前焦点
  final FocusNode focusNode;

  /// 接收到键盘事件的回调
  final ValueChanged<RawKeyEvent> onKey;

  /// 接收到键盘事件按下的回调
  final ValueChanged<ShortcutKeys> onKeyDown;

  /// 接收到键盘事件抬起的回调
  final ValueChanged<ShortcutKeys> onKeyUp;

  /// 鼠标移动到子组件区域时
  final PointerEnterEventListener onMouseEnter;

  /// 鼠标在子组件内部移动时
  final PointerHoverEventListener onMouseHover;

  /// 鼠标离开子组件区域时
  final PointerExitEventListener onMouseExit;

  /// 鼠标/手指按下
  final PointerDownEventListener onPointerDown;

  /// 鼠标/手指后移动
  final PointerMoveEventListener onPointerMove;

  /// 鼠标/手指抬起
  final PointerUpEventListener onPointerUp;

  /// 鼠标/手指取消
  final PointerCancelEventListener onPointerCancel;

  /// 鼠标滚轮信号
  final PointerSignalEventListener onPointerSignal;

  /// 快捷键设置
  final Map<List<ShortcutKeys>, Function> shortcuts;

  /// 子组件
  final Widget child;

  const ShortcutKeysListener({
    Key key,
    @required this.focusNode,
    @required this.child,
    this.onKey,
    this.onKeyDown,
    this.onKeyUp,
    this.shortcuts,
    this.onMouseEnter,
    this.onMouseHover,
    this.onMouseExit,
    this.onPointerDown,
    this.onPointerMove,
    this.onPointerUp,
    this.onPointerCancel,
    this.onPointerSignal,
  }) : super(key: key);

  @override
  _ShortcutKeysListenerState createState() => _ShortcutKeysListenerState();
}

class _ShortcutKeysListenerState extends State<ShortcutKeysListener> {
  Set<ShortcutKeys> _keyEvent = Set();

  /// 键盘事件回调
  void _onKey(RawKeyEvent event) {
    if (widget.onKey != null) {
      // 除快捷键外还是会回调原始的键盘数据
      widget.onKey(event);
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return;
    }
    if (event is RawKeyDownEvent) {
      // 键盘按下
      _onKeyDown(event);
    } else if (event is RawKeyUpEvent) {
      // 键盘抬起
      _onKeyUp(event);
    } else {
      // 其它特殊情况
      return;
    }
  }

  /// 键盘按下事件
  void _onKeyDown(RawKeyEvent event) {
    RawKeyEventDataAndroid rawKeyEventDataAndroid = event.data;
    // 取得正确的按下的按键
    ShortcutKeys key = ShortcutKey.getKey(rawKeyEventDataAndroid.keyCode);
    if (widget.onKeyDown != null) {
      // 同时回调
      widget.onKeyDown(key);
    }
    // 添加当前按键到已按下的按键中
    _keyEvent.add(key);
    // 循环遍历快捷键调用
    List<List<ShortcutKeys>> keys = widget.shortcuts?.keys?.toList() ?? List();
    for (int i = 0; i < keys.length; i++) {
      Function callback = widget.shortcuts[keys[i]];
      if (callback is! VoidCallback) {
        // 如果不是空参数的Function则证明是有鼠标操作的快捷键,不需要在这里处理
        continue;
      }
      bool equal = true;
      if (_keyEvent.length != keys[i].length) {
        continue;
      }
      for (int j = 0; j < keys[i].length; j++) {
        equal = _keyEvent.contains(keys[i][j]);
        if (!equal) {
          // 当有一个不匹配时就跳过
          break;
        }
      }
      // 快捷键完全匹配则回调
      if (equal && callback != null) {
        callback();
        break;
      }
    }
  }

  /// 键盘抬起事件
  void _onKeyUp(RawKeyEvent event) {
    RawKeyEventDataAndroid rawKeyEventDataAndroid = event.data;
    // 取得正确的按下的按键
    ShortcutKeys key = ShortcutKey.getKey(rawKeyEventDataAndroid.keyCode);
    if (widget.onKeyUp != null) {
      // 同时回调
      widget.onKeyUp(key);
    }
    // 移除按下的按键
    _keyEvent.remove(key);
  }

  /// 鼠标进入
  void _onEnter(event) {
    if (widget.onMouseEnter != null) {
      widget.onMouseEnter(event);
    }
    _onMouse(ShortcutKeys.MOUSE_REGION, event);
  }

  /// 鼠标悬浮
  void _onHover(event) {
    if (widget.onMouseHover != null) {
      widget.onMouseHover(event);
    }
    _onMouse(ShortcutKeys.MOUSE_REGION, event);
  }

  /// 鼠标离开
  void _onExit(event) {
    if (widget.onMouseExit != null) {
      widget.onMouseExit(event);
    }
    _onMouse(ShortcutKeys.MOUSE_REGION, event);
  }

  /// 鼠标滚轮滚动
  void _onPointerSignal(event) {
    if (widget.onPointerSignal != null) {
      widget.onPointerSignal(event);
    }
    _onMouse(ShortcutKeys.MOUSE_SCROLL, event);
  }

  /// 点击并移动
  void _onPointerMove(event) {
    if (widget.onPointerMove != null) {
      widget.onPointerMove(event);
    }
    _onMouse(ShortcutKeys.MOUSE_LEFT, event);
  }

  /// 按下
  void _onPointerDown(event) {
    if (widget.onPointerDown != null) {
      widget.onPointerDown(event);
    }
    _onMouse(ShortcutKeys.MOUSE_LEFT, event);
  }

  /// 抬起
  void _onPointerCancel(event) {
    if (widget.onPointerCancel != null) {
      widget.onPointerCancel(event);
    }
    _onMouse(ShortcutKeys.MOUSE_LEFT, event);
  }

  /// 取消
  void _onPointerUp(event) {
    if (widget.onPointerUp != null) {
      widget.onPointerUp(event);
    }
    _onMouse(ShortcutKeys.MOUSE_LEFT, event);
  }

  /// 鼠标快捷键事件处理
  void _onMouse(ShortcutKeys shortcutKeys, event) {
    // 循环遍历快捷键调用
    List<List<ShortcutKeys>> keys = widget.shortcuts?.keys?.toList() ?? List();
    for (int i = 0; i < keys.length; i++) {
      Function callback = widget.shortcuts[keys[i]];
      if (callback is VoidCallback || !keys[i].contains(shortcutKeys)) {
        // 如果是空参数的Function则可能只是按键操作的快捷键
        continue;
      }
      bool equal = true;
      if (_keyEvent.length != keys[i].length - 1) {
        continue;
      }
      for (int j = 0; j < keys[i].length; j++) {
        if (keys[i][j] == shortcutKeys) {
          continue;
        }
        equal = _keyEvent.contains(keys[i][j]);
        if (!equal) {
          // 当有一个不匹配时就跳过
          break;
        }
      }
      // 快捷键完全匹配则回调
      if (equal && callback != null) {
        callback(event);
        break;
      }
    }
  }

  @override
  void dispose() {
    _keyEvent.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onEnter: _onEnter,
      onExit: _onExit,
      child: Listener(
        onPointerSignal: _onPointerSignal,
        onPointerMove: _onPointerMove,
        onPointerDown: _onPointerDown,
        onPointerCancel: _onPointerCancel,
        onPointerUp: _onPointerUp,
        child: RawKeyboardListener(
          focusNode: widget.focusNode,
          onKey: _onKey,
          child: widget.child,
        ),
      ),
    );
  }
}
