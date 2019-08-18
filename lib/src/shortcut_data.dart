import 'dart:ui';

import 'package:meta/meta.dart';
import '../shortcut_keys.dart';

/// 快捷键数据
class ShortcutData {
  /// 按下的按键
  final List<ShortcutKeys> shortcuts;

  /// 快捷键触发
  final Function trigger;

  ShortcutData({
    @required this.shortcuts,
    @required this.trigger,
  })  : assert(() {
          int count = 0;
          if (shortcuts?.contains(ShortcutKeys.MOUSE_REGION) == true) {
            count++;
          }
          if (shortcuts?.contains(ShortcutKeys.MOUSE_LEFT) == true) {
            count++;
          }
          if (shortcuts?.contains(ShortcutKeys.MOUSE_SCROLL) == true) {
            count++;
          }
          return count <= 1;
        }()),
        assert(() {
          bool hasScroll = shortcuts?.contains(ShortcutKeys.MOUSE_SCROLL) ?? false;
          bool hasLeft = shortcuts?.contains(ShortcutKeys.MOUSE_LEFT) ?? false;
          bool hasRegion = shortcuts?.contains(ShortcutKeys.MOUSE_REGION) ?? false;
          if (hasScroll || hasLeft || hasRegion) {
            if (trigger is VoidCallback) {
              return false;
            }
            return true;
          } else {
            if (trigger is VoidCallback) {
              return true;
            }
            return false;
          }
        }());

  /// 触发函数
  void triggerEvent([event]) {
    if (trigger == null) {
      return;
    }
    if (event == null) {
      trigger();
    } else {
      trigger(event);
    }
  }

  /// 判断按下的按键是否匹配
  bool equalKey(Set<ShortcutKeys> keys, [ShortcutKeys ignore]) {
    if (keys == null || shortcuts == null) {
      return false;
    }
    if (hasMouse()) {
      if (keys.length != shortcuts.length - 1) {
        return false;
      }
    } else {
      if (keys.length != shortcuts.length) {
        return false;
      }
    }
    for (var i = 0; i < shortcuts.length; ++i) {
      ShortcutKeys shortcutKeys = shortcuts[i];
      if (shortcutKeys == ignore) {
        continue;
      }
      if (!keys.contains(shortcutKeys)) {
        return false;
      }
    }
    return true;
  }

  /// 判断是否含有鼠标快捷键
  bool hasMouse() {
    bool hasScroll = shortcuts?.contains(ShortcutKeys.MOUSE_SCROLL) ?? false;
    bool hasLeft = shortcuts?.contains(ShortcutKeys.MOUSE_LEFT) ?? false;
    bool hasRegion = shortcuts?.contains(ShortcutKeys.MOUSE_REGION) ?? false;
    return hasScroll || hasLeft || hasRegion;
  }
}
