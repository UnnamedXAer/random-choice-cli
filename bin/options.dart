import 'package:args/args.dart';

class Options {
  bool prettyPrint;

  Options._({this.prettyPrint = true});

  factory Options.fromArguments(List<String> arguments) {
    const prettyPrintName = 'pretty-print';

    final ArgParser parser = ArgParser()
      ..addFlag(prettyPrintName, abbr: 'p', defaultsTo: true, negatable: true);

    ArgResults argResults = parser.parse(arguments);

    final prettyPrint = argResults[prettyPrintName];

    return Options._(prettyPrint: prettyPrint);
  }
}
