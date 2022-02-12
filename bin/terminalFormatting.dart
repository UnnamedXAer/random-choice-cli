class C {
  static const int black = 0;
  static const int red = 1;
  static const int green = 2;
  static const int yellow = 3;
  static const int blue = 4;
  static const int magenta = 5;
  static const int cyan = 6;
  static const int white = 7;
  // static const int _ = 8;
  static const int reset = 9;
}

class F {
  static const int resetAllOptions = 0;
  static const int bold = 1;
  static const int rapidBlink = 6;
  static const int disableBlinking = 25;
}

String c(int n, [bool bg = false]) => '\x1b[${bg ? '4' : '3'}${n}m';

/// Formats text
///
/// Use `F` class to pick an option or provide custome value.
String formatText(int n) => '\x1b[${n}m';

/// Shows or hides cursor in the terminal.
String showCursor(bool show) => '\x1b[25${show ? 'h' : 'l'}';

/// Moves the cursor to row `n`, column `m`. The values are 1-based, and default to `1` (top left corner).
String moveToPosition([int n = 0, m = 0]) => '\x1b[$n;${m}H';

/// Moves cursor to beginning of the line n (default 1) lines up.
///
/// `n = 1` - move line up
String moveLineUp([int n = 1]) => '\x1b[${n}F';

/// Moves the cursor to column `n` (default `1`).
String setCursorPosition([int n = 1]) => '\x1b[${n}G';

/// Moves the cursor `n` (default `1`) cells in the given direction. If the cursor is already at the edge of the screen, this has no effect.
String moveCursorBack([int n = 1]) => '\x1b[${n}D';

///Erases part of the line.
/// * If `n` is `0`, clear from cursor to the end of the line.
/// * If `n` is `1`, clear from cursor to beginning of the line.
/// * If `n` is `2`(default), clear entire line. Cursor position does not change.
String clearLine([int n = 2]) => '\x1b[${n}K';
