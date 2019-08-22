import 'dart:math';

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

  /// 设置是否需要焦点
  final bool needFocus;

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
  final List<ShortcutData> shortcutData;

  /// 子组件
  final Widget child;

  const ShortcutKeysListener({
    Key key,
    this.focusNode,
    this.needFocus = true,
    @required this.child,
    this.onKey,
    this.onKeyDown,
    this.onKeyUp,
    this.onMouseEnter,
    this.onMouseHover,
    this.onMouseExit,
    this.onPointerDown,
    this.onPointerMove,
    this.onPointerUp,
    this.onPointerCancel,
    this.onPointerSignal,
    this.shortcutData,
  }) : super(key: key);

  @override
  _ShortcutKeysListenerState createState() => _ShortcutKeysListenerState();
}

class _ShortcutKeysListenerState extends State<ShortcutKeysListener> {
  List<ShortcutKeys> _keyEvent = List();

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
    int keyCode;

    if (event.data is RawKeyEventDataAndroid) {
      RawKeyEventDataAndroid rawKeyEventData = event.data;
      keyCode = rawKeyEventData.keyCode;
    } else if (event.data is RawKeyEventDataLinux) {
      RawKeyEventDataLinux rawKeyEventData = event.data;
      keyCode = rawKeyEventData.keyCode;
    } else if (event.data is RawKeyEventDataMacOs) {
      RawKeyEventDataMacOs rawKeyEventData = event.data;
      keyCode = rawKeyEventData.keyCode;
    }

    // 取得正确的按下的按键
    ShortcutKeys key = ShortcutKey.getKey(keyCode);
    if (widget.onKeyDown != null) {
      // 同时回调
      widget.onKeyDown(key);
    }
    // 添加当前按键到已按下的按键中
    _keyEvent.add(key);
    // 循环遍历快捷键调用
    List<ShortcutData> shortcuts = widget.shortcutData ?? List();
    for (int i = 0; i < shortcuts.length; i++) {
      ShortcutData shortcutData = shortcuts[i];
      if (shortcutData.hasMouse()) {
        continue;
      }
      if (shortcutData.equalKey(_keyEvent)) {
        shortcutData.triggerEvent();
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
    List<ShortcutData> datas = widget.shortcutData ?? List();
    for (int i = 0; i < datas.length; i++) {
      ShortcutData shortcutData = datas[i];
      if (!shortcutData.hasMouse()) {
        continue;
      }
      if (shortcutData.equalKey(_keyEvent, shortcutKeys)) {
        shortcutData.triggerEvent(event);
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (!widget.needFocus) {
      RawKeyboard.instance.addListener(_onKey);
    }
  }

  @override
  void dispose() {
    _keyEvent.clear();
    RawKeyboard.instance.removeListener(_onKey);
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
        child: widget.needFocus
            ? RawKeyboardListener(
                focusNode: widget.focusNode,
                onKey: _onKey,
                child: widget.child,
              )
            : widget.child,
      ),
    );
  }
}
