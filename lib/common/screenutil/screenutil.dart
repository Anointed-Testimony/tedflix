import 'dart:ui';

class ScreenUtil {
  static ScreenUtil? _instance;
  static const int defaultWidth = 414;
  static const int defaultHeight = 896;

  /// Size of the phone in UI Design, px
  num? uiWidthPx;
  num? uiHeightPx;

  /// Specifies whether fonts should scale to respect Text Size accessibility settings.
  bool allowFontScaling = false;

  static double? _screenWidth;
  static double? _screenHeight;
  static double? _pixelRatio;
  static double? _statusBarHeight;
  static double? _bottomBarHeight;
  static double? _textScaleFactor;

  ScreenUtil._();

  factory ScreenUtil() {
    _instance ??= ScreenUtil._();
    return _instance!;
  }

  static void init(
      {num width = defaultWidth,
      num height = defaultHeight,
      bool allowFontScaling = false}) {
    if (_instance == null) {
      _instance = ScreenUtil._();
    }
    _instance!.uiWidthPx = width;
    _instance!.uiHeightPx = height;
    _instance!.allowFontScaling = allowFontScaling;
    _pixelRatio = window.devicePixelRatio;
    _screenWidth = window.physicalSize.width;
    _screenHeight = window.physicalSize.height;
    _statusBarHeight = window.padding.top;
    _bottomBarHeight = window.padding.bottom;
    _textScaleFactor = window.textScaleFactor;
  }

  /// The number of font pixels for each logical pixel.
  static double get textScaleFactor => _textScaleFactor ?? 1;

  /// The size of the media in logical pixels (e.g., the size of the screen).
  static double get pixelRatio => _pixelRatio ?? 1;

  /// The horizontal extent of this size.
  static double get screenWidth => (_screenWidth ?? 0) / (_pixelRatio ?? 1);

  /// The vertical extent of this size in dp.
  static double get screenHeight => (_screenHeight ?? 0) / (_pixelRatio ?? 1);

  /// The vertical extent of this size in px.
  static double get screenWidthPx => _screenWidth ?? 0;

  /// The vertical extent of this size in px.
  static double get screenHeightPx => _screenHeight ?? 0;

  /// The offset from the top.
  static double get statusBarHeight => (_statusBarHeight ?? 0) / (_pixelRatio ?? 1);

  /// The offset from the top.
  static double get statusBarHeightPx => _statusBarHeight ?? 0;

  /// The offset from the bottom.
  static double get bottomBarHeight => _bottomBarHeight ?? 0;

  /// The ratio of the actual dp to the design draft px.
  double get scaleWidth => screenWidth / (uiWidthPx ?? defaultWidth);

  double get scaleHeight =>
      ((_screenHeight ?? 0) - (_statusBarHeight ?? 0) - (_bottomBarHeight ?? 0)) / (uiHeightPx ?? defaultHeight);

  double get scaleText => scaleWidth;

  /// Width function.
  num setWidth(num width) => width * scaleWidth;

  /// Height function.
  num setHeight(num height) => height * scaleHeight;

  /// FontSize function.
  num setSp(num fontSize, {bool allowFontScalingSelf = false}) =>
      allowFontScalingSelf
          ? (fontSize * scaleText)
          : ((fontSize * scaleText) / (_textScaleFactor ?? 1));
}
