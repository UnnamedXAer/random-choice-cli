import 'dart:io';

import 'data.dart';
import 'drawer.dart';
import 'options.dart';

void main(List<String> arguments) {
  exitCode = 0;

  Options options = Options.fromArguments(arguments);

  try {
    if (!stdout.supportsAnsiEscapes) {
      final defaultPrettyPring = options.prettyPrint;
      options.prettyPrint = false;
      if (defaultPrettyPring) {
        throw Exception('Ansi escapes not supported');
      }
    }
  } catch (err) {
    print(
        'Your terminal may not support some of features that we use\nto improve user expirience, but it should still yield correct results.');
  }

  final data = readDataFromStdin();

  final drawer = Drawer(
    prettyPrint: options.prettyPrint,
  );

  drawer.drawRandomElement(data);
}