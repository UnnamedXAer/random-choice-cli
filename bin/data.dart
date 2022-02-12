import 'dart:io';

List<String> readDataFromStdin() {
  if (Platform.environment["DART_ENV"] == "development") {
    print("DART_ENV: ${Platform.environment["DART_ENV"]}");
    print('using test data');

    final data = [
      'orange',
      'apple',
      'banana',
      'kiwi',
      'tomato',
      'other',
    ];

    return data;
  }

  var terminalWrite = stdout.write;

  List<String> data = [];
  print('\n Type your options, (enter empty line "" to finish adding).\n');
  do {
    do {
      terminalWrite("${data.length + 1} > ");
      final line = stdin.readLineSync();
      if (line == null || line.isEmpty) {
        break;
      }

      data.add(line);
    } while (true);

    if (data.isEmpty) {
      print('Enter some data or press "Ctrl + C" to exit.');
    }
  } while (data.isEmpty);

  return data;
}
