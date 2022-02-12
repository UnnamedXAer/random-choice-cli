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

  void drawRandomElement(List<String> data) {
    _draw(data, prettyPrint, endStepTime).whenComplete(() {
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
      final idx = Random(DateTime.now().microsecondsSinceEpoch)
          .nextInt(data.length);
      return data[idx];
    }

    _setupTerminalForDraw();
    int maxOptionLength = _findMaxLength(data);
    int cursorPosition = _findCursorPositionforDrawing(maxOptionLength);
    var k = 0;
    final dataLen = data.length;
    var stepTimes = _calculateStepTimes(dataLen);
    for (var i = 0; i < dataRoundsNumber; i++) {
      data.shuffle();
      for (var j = 0; j < dataLen; j++) {
        await Future.delayed(Duration(milliseconds: stepTimes[i * dataLen + j]),
            () {
          k++;
          if (k == _backgroundColor) k++;
          _terminalWrite(clearLine());
          _terminalWrite(setCursorPosition(cursorPosition));
          _terminalWrite("${c(k % 8)} ${data[j]}");
        });
      }
    }

    return data.last;
  }

  List<int> _calculateStepTimes(int elementsCnt) {
    final totalSteps = elementsCnt * dataRoundsNumber;
    assert(totalSteps > 0, 'total number of steps must be positive');
    final stepTime = ((endStepTime - _startStepTime) / totalSteps).floor();

    List<int> stepTimes =
        List.generate(totalSteps, (i) => 50 + stepTime * (i + 1));

    stepTimes = _interpolate<int>(stepTimes, (value) => value);

    return stepTimes;
  }

  List<T> _interpolate<T>(List<T> values, T Function(T value) calculate) {
    return values.map(calculate).toList();
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
