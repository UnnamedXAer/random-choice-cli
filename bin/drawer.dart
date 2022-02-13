import 'dart:io';
import 'dart:math';

import 'terminalFormatting.dart';

class Drawer {
  final _terminalWrite = stdout.write;
  int dataRoundsNumber;
  bool prettyPrint;

  /// expressed in miliseconds
  int endStepTime;
  final int _startStepTime = 50;
  final int _backgroundColor = C.blue;

  Drawer({
    this.dataRoundsNumber = 3,
    this.prettyPrint = true,
    this.endStepTime = 300,
  });

  Future<void> drawRandomElement(List<String> data) {
    return _draw(data, prettyPrint, endStepTime).whenComplete(() {
      _resetTerminalAfterDraw();
    }).then((result) {
      _terminalWrite(formatText(F.resetAllOptions));
      _terminalWrite('\n\nYou Drawed: ');
      _terminalWrite(c(C.green));
      _terminalWrite('${formatText(F.rapidBlink)}${formatText(F.bold)}');
      _terminalWrite(result);
      _terminalWrite(formatText(F.resetAllOptions));
      _terminalWrite("\n"); // required to print result in some terminals
    });
  }

  Future<String> _draw(
      List<String> data, bool prettyPrint, int lastStepTime) async {
    if (!prettyPrint || data.length == 1) {
      final idx =
          Random(DateTime.now().microsecondsSinceEpoch).nextInt(data.length);
      return data[idx];
    }

    _setupTerminalForDraw();
    int maxOptionLength = _findMaxLength(data);
    int cursorPosition = _findCursorPositionforDrawing(maxOptionLength);
    var k = 0;
    final dataLen = data.length;
    var stepTimes = _calculateStepTimes(dataLen);
    var j = 0;
    for (var i = 0; i < stepTimes.length; i++) {
      j = i % dataLen;
      if (j == 0) {
        data.shuffle();
      }
      await Future.delayed(Duration(milliseconds: stepTimes[i]), () {
        k++;
        if (k == _backgroundColor) k++;
        _terminalWrite(clearLine());
        _terminalWrite(setCursorPosition(cursorPosition));
        _terminalWrite("${c(k % 8)} ${data[j]}");
      });
    }

    return data[j];
  }

  int calculateSteps(int elementsCnt) {
    if (elementsCnt < 5) {
      return 15;
    }
    if (elementsCnt < 10) {
      return (elementsCnt * 2.5).round();
    }

    return Random(DateTime.now().millisecondsSinceEpoch).nextInt(6) + 20;
  }

  List<int> _calculateStepTimes(int elementsCnt) {
    final maxTime = elementsCnt <= 5 ? 3000 : 5000;
    final totalSteps = calculateSteps(elementsCnt);
    final stepTime = ((maxTime * 1.15) / totalSteps).round();

    List<double> stepTimes = List.generate(
        totalSteps, (i) => (460 / (totalSteps - 2) * (i + 1)).clamp(50, 500));

    List<int> easedStepTimes = _easeSteps(stepTimes);
    return easedStepTimes;
  }

  List<int> _easeSteps(List<double> list) {
    final len = list.length;
    final List<int> interpolated = List.filled(len, 0);

    for (var i = 0; i < len; i++) {
      interpolated[i] = (list[i] * _easeInOutSine(list[i] / list.last))
          .round()
          .clamp(40, 550);
    }

    return interpolated;
  }

  double _easeInOutSine(double x) {
    double out = sin((x * pi) / (1.70)); // easeOutSine
    // double out = 1 - (1 - x) * (1 - x); // easeOutQuad
    // double out = -(cos(pi * x) - 1) / 2; // ease in out
    // double out = x < 0.5 ? 2 * x * x : 1 - pow(-2 * x + 2, 2) / 2;
    return out;
  }

  int _findMaxLength(List<String> arr) {
    var max = 0;
    for (var i = 0; i < arr.length; i++) {
      if (arr[i].length > max) {
        max = arr[i].length;
      }
    }

    return max;
  }

  void _setupTerminalForDraw() {
    _terminalWrite(showCursor(false));
    _terminalWrite(c(_backgroundColor, true));
    _terminalWrite("\n.\n.\n.");

    int? lines;

    try {
      lines = stdout.terminalLines;
      // _terminalWrite(lines);
    } catch (err) {
      //
    }

    if ((lines ?? 0) > 2) {
      _terminalWrite(moveLineUp(1));
    }
    _terminalWrite(formatText(F.bold));
  }

  void _resetTerminalAfterDraw() {
    _terminalWrite(c(C.reset, true) + c(C.reset));
    _terminalWrite(showCursor(true));
  }

  int _findCursorPositionforDrawing(int maxOptionLength) {
    int? cols;
    try {
      final cols = stdout.terminalColumns;
    } catch (e) {
      //
    }

    if (cols == null) {
      return 3;
    }

    if (cols == 0) {
      return 0;
    }

    if (cols < maxOptionLength) {
      return 1;
    }

    if (cols <= maxOptionLength + 10) {
      return ((cols - maxOptionLength) / 2).floor();
    }

    return 5;
  }
}
