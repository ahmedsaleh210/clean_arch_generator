library clean_arch_generator;

import 'dart:developer';
import 'dart:io';
part 'clean_architecture_content.dart';
part 'repository_architecture_generator.dart';
part 'utils.dart';

class FeatureGenerator {
  final String upperCamelCaseFeatureName;
  final String lowerCamelCaseFeatureName;
  final String featureName;
  late final String baseDir;

  FeatureGenerator(this.featureName)
      : assert(featureName.isNotEmpty),
        upperCamelCaseFeatureName = featureName.getUpperCamelCase(),
        lowerCamelCaseFeatureName = featureName.getLowerCamelCase(),
        baseDir = 'lib/src/features/$featureName' {
    if (!Directory(baseDir).existsSync()) {
      Directory(baseDir).createSync(recursive: true);
    }
  }

  Future<void> generateCleanFiles() async {
    final cleanArchtectureContent = _CleanArchtectureContent(featureName);
    final fileMap = {
      '$baseDir/domain/entities/${featureName}_entity.dart':
          cleanArchtectureContent.getEntityContent,
      '$baseDir/domain/use_case/fetch_${featureName}_use_case.dart':
          cleanArchtectureContent.getUseCaseContent,
      '$baseDir/domain/imports/domain_imports.dart':
          cleanArchtectureContent.getDomainImportsContent,
      '$baseDir/data/models/${featureName}_model.dart':
          cleanArchtectureContent.getModelContent,
      '$baseDir/data/repositories/${featureName}_repository.dart':
          cleanArchtectureContent.getRepositoryContent,
      '$baseDir/data/data_sources/${featureName}_data_source.dart':
          cleanArchtectureContent.getDataSourceContent,
      '$baseDir/data/di/${featureName}_di.dart':
          cleanArchtectureContent.getServiceLocatorContent,
      '$baseDir/data/imports/data_imports.dart':
          cleanArchtectureContent.getDataImportsContent,
      '$baseDir/presentation/cubit/${featureName}_cubit.dart':
          cleanArchtectureContent.getBlocContent,
      '$baseDir/presentation/cubit/${featureName}_state.dart':
          cleanArchtectureContent.getBlocStateContent,
      '$baseDir/presentation/imports/presentation_imports.dart':
          cleanArchtectureContent.getPresentationImportsContent,
      '$baseDir/presentation/screens/${featureName}_screen.dart':
          cleanArchtectureContent.getPresentationScreenContent,
      '$baseDir/presentation/widgets/${featureName}_widget.dart':
          cleanArchtectureContent.getPresentationWidgetContent,
    };

    for (final entry in fileMap.entries) {
      _createAndWriteFile(entry.key, entry.value());
    }
  }

  Future<void> generateRepositoryFiles() async {
    final repositoryArchitectureGenerator =
        _RepositoryArchitectureGenerator(featureName);
    final fileMap = {
      '$baseDir/data/models/${featureName}_model.dart':
          repositoryArchitectureGenerator.getModelContent,
      '$baseDir/data/repositories/${featureName}_repository.dart':
          repositoryArchitectureGenerator.getRepositoryContent,
      '$baseDir/data/imports/data_imports.dart':
          repositoryArchitectureGenerator.getDataImports,
      '$baseDir/data/di/${featureName}_di.dart':
          repositoryArchitectureGenerator.getServiceLocatorContent,
      '$baseDir/presentation/cubit/${featureName}_cubit.dart':
          repositoryArchitectureGenerator.getBlocContent,
      '$baseDir/presentation/cubit/${featureName}_state.dart':
          repositoryArchitectureGenerator.getBlocStateContent,
      '$baseDir/presentation/imports/presentation_imports.dart':
          repositoryArchitectureGenerator.getPresentationImportsContent,
      '$baseDir/presentation/screens/${featureName}_screen.dart':
          repositoryArchitectureGenerator.getPresentationScreenContent,
      '$baseDir/presentation/widgets/${featureName}_widget.dart':
          repositoryArchitectureGenerator.getPresentationWidgetContent,
    };

    for (final entry in fileMap.entries) {
      _createAndWriteFile(entry.key, entry.value());
    }
  }

  Future<File> _createAndWriteFile(String path, String content) async {
    final file = await File(path).create(recursive: true);
    file.writeAsStringSync(content);
    log('Created file: ${file.path}');
    return file;
  }
}
