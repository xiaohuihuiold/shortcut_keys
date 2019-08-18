import 'dart:io';

import 'package:flutter/foundation.dart';

/// 键盘按键加上鼠标左键的枚举
enum ShortcutKeys {
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K,
  L,
  M,
  N,
  O,
  P,
  Q,
  R,
  S,
  T,
  U,
  V,
  W,
  X,
  Y,
  Z,
  SEMICOLON, // ;
  MINUS, // -
  EQUAL, // =
  COMMA, // ,
  SLASH_AND_NUM_DIV, // /
  BACKSLASH, // \
  BRACKET_LEFT, // [
  BRACKET_RIGHT, // ]
  QUOTE, // '
  BACK_QUOTE, // `
  PERIOD, // .
  DIGIT0,
  DIGIT1,
  DIGIT2,
  DIGIT3,
  DIGIT4,
  DIGIT5,
  DIGIT6,
  DIGIT7,
  DIGIT8,
  DIGIT9,
  NUM0,
  NUM1,
  NUM2,
  NUM3,
  NUM4,
  NUM5,
  NUM6,
  NUM7,
  NUM8,
  NUM9,
  NUM_MUL, // *
  NUM_SUB, // -
  NUM_ADD, // +
  NUM_LOCK,
  F1,
  F2,
  F3,
  F4,
  F5,
  F6,
  F7,
  F8,
  F9,
  F10,
  F11,
  F12,
  ARROW_UP,
  ARROW_DOWN,
  ARROW_LEFT,
  ARROW_RIGHT,
  ALT_LEFT,
  ALT_RIGHT,
  CTRL_LEFT,
  CTRL_RIGHT,
  SHIFT_LEFT,
  SHIFT_RIGHT,
  CAPS_LOCK,
  SUPER,
  MENU,
  TAB,
  SPACE,
  ENTER_AND_NUM_ENTER,
  ESCAPE,
  BACKSPACE,
  PRINT,
  INSERT,
  DELETE,
  NUM_DECIMAL,
  HOME,
  END,
  PAGE_UP,
  PAGE_DOWN,
  MOUSE_LEFT,
  MOUSE_SCROLL,
  MOUSE_REGION,
}

/// 按键工具类
class ShortcutKey {
  /// linux的keycode对照
  static const keyLinux = {
    65: ShortcutKeys.A,
    66: ShortcutKeys.B,
    67: ShortcutKeys.C,
    68: ShortcutKeys.D,
    69: ShortcutKeys.E,
    70: ShortcutKeys.F,
    71: ShortcutKeys.G,
    72: ShortcutKeys.H,
    73: ShortcutKeys.I,
    74: ShortcutKeys.J,
    75: ShortcutKeys.K,
    76: ShortcutKeys.L,
    77: ShortcutKeys.M,
    78: ShortcutKeys.N,
    79: ShortcutKeys.O,
    80: ShortcutKeys.P,
    81: ShortcutKeys.Q,
    82: ShortcutKeys.R,
    83: ShortcutKeys.S,
    84: ShortcutKeys.T,
    85: ShortcutKeys.U,
    86: ShortcutKeys.V,
    87: ShortcutKeys.W,
    88: ShortcutKeys.X,
    89: ShortcutKeys.Y,
    90: ShortcutKeys.Z,
    59: ShortcutKeys.SEMICOLON, // ;
    45: ShortcutKeys.MINUS, // -
    61: ShortcutKeys.EQUAL, // =
    44: ShortcutKeys.COMMA, // ,
    47: ShortcutKeys.SLASH_AND_NUM_DIV, // /
    92: ShortcutKeys.BACKSLASH, // \
    91: ShortcutKeys.BRACKET_LEFT, // [
    93: ShortcutKeys.BRACKET_RIGHT, // ]
    39: ShortcutKeys.QUOTE, // '
    96: ShortcutKeys.BACK_QUOTE, // `
    46: ShortcutKeys.PERIOD, // .
    48: ShortcutKeys.DIGIT0,
    49: ShortcutKeys.DIGIT1,
    50: ShortcutKeys.DIGIT2,
    51: ShortcutKeys.DIGIT3,
    52: ShortcutKeys.DIGIT4,
    53: ShortcutKeys.DIGIT5,
    54: ShortcutKeys.DIGIT6,
    55: ShortcutKeys.DIGIT7,
    56: ShortcutKeys.DIGIT8,
    57: ShortcutKeys.DIGIT9,
    320: ShortcutKeys.NUM0,
    321: ShortcutKeys.NUM1,
    322: ShortcutKeys.NUM2,
    323: ShortcutKeys.NUM3,
    324: ShortcutKeys.NUM4,
    325: ShortcutKeys.NUM5,
    326: ShortcutKeys.NUM6,
    327: ShortcutKeys.NUM7,
    328: ShortcutKeys.NUM8,
    329: ShortcutKeys.NUM9,
    332: ShortcutKeys.NUM_MUL, // *
    333: ShortcutKeys.NUM_SUB, // -
    334: ShortcutKeys.NUM_ADD, // +
    282: ShortcutKeys.NUM_LOCK,
    290: ShortcutKeys.F1,
    291: ShortcutKeys.F2,
    292: ShortcutKeys.F3,
    293: ShortcutKeys.F4,
    294: ShortcutKeys.F5,
    295: ShortcutKeys.F6,
    296: ShortcutKeys.F7,
    297: ShortcutKeys.F8,
    298: ShortcutKeys.F9,
    299: ShortcutKeys.F10,
    300: ShortcutKeys.F11,
    301: ShortcutKeys.F12,
    265: ShortcutKeys.ARROW_UP,
    264: ShortcutKeys.ARROW_DOWN,
    263: ShortcutKeys.ARROW_LEFT,
    262: ShortcutKeys.ARROW_RIGHT,
    342: ShortcutKeys.ALT_LEFT,
    346: ShortcutKeys.ALT_RIGHT,
    341: ShortcutKeys.CTRL_LEFT,
    345: ShortcutKeys.CTRL_RIGHT,
    340: ShortcutKeys.SHIFT_LEFT,
    344: ShortcutKeys.SHIFT_RIGHT,
    280: ShortcutKeys.CAPS_LOCK,
    343: ShortcutKeys.SUPER,
    348: ShortcutKeys.MENU,
    258: ShortcutKeys.TAB,
    32: ShortcutKeys.SPACE,
    257: ShortcutKeys.ENTER_AND_NUM_ENTER,
    256: ShortcutKeys.ESCAPE,
    259: ShortcutKeys.BACKSPACE,
    283: ShortcutKeys.PRINT,
    260: ShortcutKeys.INSERT,
    261: ShortcutKeys.DELETE,
    330: ShortcutKeys.NUM_DECIMAL,
    268: ShortcutKeys.HOME,
    269: ShortcutKeys.END,
    266: ShortcutKeys.PAGE_UP,
    267: ShortcutKeys.PAGE_DOWN,
  };

  /// 根据keycode求得对应平台的按键
  static ShortcutKeys getKey(int keyCode) {
    if (Platform.isLinux) {
      // 当运行平台是linux时
      return keyLinux[keyCode];
    }
    // 其它不支持的平台
    throw FlutterError('Unsupported platform,keyboard code :$keyCode');
  }
}
