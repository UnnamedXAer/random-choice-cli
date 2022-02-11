import 'dart:io';

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

const words = [
  'Parses',
  'raw',
  'command-line',
  'arguments',
  'into',
  'a',
  'set',
  'of',
  'options',
  'and',
  'values'
];

void main(List<String> arguments) {
  exitCode = 0;
  final stepTime = 100;

  var print = stdout.write;

  var i = 0;
  print(format(1)); // bold

  printAndScheduleNext() {
    print(moveTopLeft(1));
    print("${c(i % 8)} ${words[i]}");
    i++;
    if (i < words.length) {
      return Future.delayed(
          Duration(milliseconds: stepTime), printAndScheduleNext);
    }
    print('${c(C.reset)}\nfinishing');
  }

  Future(printAndScheduleNext).then((_) {
    print(c(C.reset, true) + c(C.reset));
    print(format(6) + '\ndone');
  });

  print('\nwork started');

  Future.delayed(Duration(seconds: 2), (() {
    print(format(0));
  })).then((value) => print('\nexiting'));
}

String c(int n, [bool bg = false]) => '\x1b[${bg ? '4' : '3'}${n}m';
String format(int n, [bool bg = false]) => '\x1b[${n}m';
String moveTopLeft(int n, [bool bg = false]) => '\x1b[0;0H';
