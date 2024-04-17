import 'package:args/args.dart';
import 'package:clean_arch_generator/clean_arch_generator.dart';

void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addOption('name',
      abbr: 'f', help: 'Name for the repository pattern architecture feature');
  var parsedArgs = parser.parse(arguments);

  final featureName = parsedArgs['name'] as String;
  FeatureGenerator(featureName).generateRepositoryFiles();
}
