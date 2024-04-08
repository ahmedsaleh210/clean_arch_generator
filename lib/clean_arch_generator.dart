library clean_arch_generator;

import 'dart:developer';
import 'dart:io';

extension StringExtension on String {
  String getUpperCamelCase() {
    return split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join();
  }

  String getLowerCamelCase() {
    final upperCamelCase = getUpperCamelCase();
    return upperCamelCase[0].toLowerCase() + upperCamelCase.substring(1);
  }
}

class FeatureGenerator {
  late String upperCamelCaseFeatureName;
  late String lowerCamelCaseFeatureName;
  Future<void> generateCleanFiles(String featureName) async {
    upperCamelCaseFeatureName = featureName.getUpperCamelCase();
    lowerCamelCaseFeatureName = featureName.getLowerCamelCase();
    final baseDir = 'lib/src/features/$featureName';

    if (!Directory(baseDir).existsSync()) {
      Directory(baseDir).createSync(recursive: true);
    }

    _createAndWriteFile(
      '$baseDir/domain/entities/${featureName}_entity.dart',
      _getEntityContent(featureName),
    );

    _createAndWriteFile(
      '$baseDir/domain/use_case/fetch_${featureName}_use_case.dart',
      _getUseCaseContent(featureName),
    );

    _createAndWriteFile(
      '$baseDir/domain/imports/domain_imports.dart',
      _getDomainImportsContent(featureName),
    );

    _createAndWriteFile(
      '$baseDir/data/models/${featureName}_model.dart',
      _getModelContent(featureName),
    );

    _createAndWriteFile(
      '$baseDir/data/repositories/${featureName}_repository.dart',
      _getRepositoryContent(featureName),
    );

    _createAndWriteFile(
      '$baseDir/data/data_sources/${featureName}_data_source.dart',
      _getDataSourceContent(featureName),
    );
    _createAndWriteFile(
      '$baseDir/data/di/${featureName}_di.dart',
      _getServiceLocatorContent(featureName),
    );
    _createAndWriteFile(
      '$baseDir/data/imports/data_imports.dart',
      _getDataImportsContent(featureName),
    );
    _createAndWriteFile(
      '$baseDir/presentation/cubit/${featureName}_cubit.dart',
      _getBlocContent(featureName),
    );
    _createAndWriteFile(
      '$baseDir/presentation/cubit/${featureName}_state.dart',
      _getBlocStateContent(featureName),
    );
    _createAndWriteFile(
        '$baseDir/presentation/imports/presentation_imports.dart',
        _getPresentationImportsContent(featureName));
    _createAndWriteFile(
        '$baseDir/presentation/screens/${featureName}_screen.dart',
        _getPresentationScreenContent(featureName));
    _createAndWriteFile(
        '$baseDir/presentation/widgets/${featureName}_widget.dart',
        _getPresentationWidgetContent(featureName));
  }

  Future<File> _createAndWriteFile(String path, String content) async {
    final file = await File(path).create(recursive: true);
    file.writeAsStringSync(content);
    log('Created file: ${file.path}');
    return file;
  }

  String _getEntityContent(String featureName) {
    return """
part of '../imports/domain_imports.dart';
class ${upperCamelCaseFeatureName}Entity {
  final int id;
  final String name;

  ${upperCamelCaseFeatureName}Entity({required this.id, required this.name});
}
  """;
  }

  String _getUseCaseContent(String featureName) {
    return """
part of '../imports/domain_imports.dart';

class Fetch${upperCamelCaseFeatureName}UseCase extends UseCase<List<${upperCamelCaseFeatureName}Entity>, String> {
  final ${upperCamelCaseFeatureName}Repository ${lowerCamelCaseFeatureName}Repository;

  Fetch${upperCamelCaseFeatureName}UseCase({required this.${lowerCamelCaseFeatureName}Repository});
  @override
  Future<Result<List<${upperCamelCaseFeatureName}Entity>, Failure>> call([String? param]) {
    return ${lowerCamelCaseFeatureName}Repository.get$upperCamelCaseFeatureName();
  }
}
""";
  }

  String _getDomainImportsContent(String featureName) {
    return """
import 'package:flutter_base/src/core/error/failure.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../core/standard/use_case.dart';
import '../../data/imports/data_imports.dart';
part '../use_case/fetch_${featureName}_use_case.dart';
part '../entities/${featureName}_entity.dart';
""";
  }

  String _getModelContent(String featureName) {
    return """
part of '../imports/data_imports.dart';
class ${upperCamelCaseFeatureName}Model extends ${upperCamelCaseFeatureName}Entity {
    ${upperCamelCaseFeatureName}Model({required id, name}) : super(id: id, name: name);
}
""";
  }

  String _getRepositoryContent(String featureName) {
    return """
part of '../imports/data_imports.dart';

abstract class ${upperCamelCaseFeatureName}Repository {
  Future<Result<List<${upperCamelCaseFeatureName}Entity>, Failure>> get$upperCamelCaseFeatureName();
}

class ${upperCamelCaseFeatureName}RepositoryImpl implements ${upperCamelCaseFeatureName}Repository {
  final ${upperCamelCaseFeatureName}DataSource dataSource;

  ${upperCamelCaseFeatureName}RepositoryImpl({required this.dataSource});
  @override
  Future<Result<List<${upperCamelCaseFeatureName}Entity>, Failure>> get$upperCamelCaseFeatureName() async {
    return await dataSource.fetch${upperCamelCaseFeatureName}Data().handleCallbackWithFailure();
  }
}
  """;
  }

  String _getDataSourceContent(String featureName) {
    return """
part  of '../imports/data_imports.dart';
abstract class ${upperCamelCaseFeatureName}DataSource {
  Future<List<${upperCamelCaseFeatureName}Model>> fetch${upperCamelCaseFeatureName}Data();
}

class ${upperCamelCaseFeatureName}DataSourceImpl implements ${upperCamelCaseFeatureName}DataSource {
  @override
  Future<List<${upperCamelCaseFeatureName}Model>> fetch${upperCamelCaseFeatureName}Data() {
    return Future.value([
      ${upperCamelCaseFeatureName}Model(id: 1, name: 'First $upperCamelCaseFeatureName'),
      ${upperCamelCaseFeatureName}Model(id: 2, name: 'Second $upperCamelCaseFeatureName'),
      ${upperCamelCaseFeatureName}Model(id: 3, name: 'Third $upperCamelCaseFeatureName'),
    ]);
  }
}
  """;
  }

  String _getServiceLocatorContent(String featureName) {
    return """
part of '../imports/data_imports.dart';
void setUp${upperCamelCaseFeatureName}Dependencies() {
  ConstantManager.serviceLocator
      .registerLazySingleton<Fetch${upperCamelCaseFeatureName}UseCase>(
    () => Fetch${upperCamelCaseFeatureName}UseCase(
        ${lowerCamelCaseFeatureName}Repository: ConstantManager.serviceLocator<${upperCamelCaseFeatureName}Repository>()),
  );

  ConstantManager.serviceLocator.registerLazySingleton<${upperCamelCaseFeatureName}Repository>(
    () => ${upperCamelCaseFeatureName}RepositoryImpl(
      dataSource: ConstantManager.serviceLocator<${upperCamelCaseFeatureName}DataSource>(),
    ),
  );

  ConstantManager.serviceLocator.registerLazySingleton<${upperCamelCaseFeatureName}DataSource>(
    () => ${upperCamelCaseFeatureName}DataSourceImpl(),
  );
}
""";
  }

  String _getDataImportsContent(String featureName) {
    return """
import 'package:flutter_base/src/core/error/failure.dart';
import 'package:flutter_base/src/core/extensions/error_handler_extension.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:flutter_base/src/config/res/constans_manager.dart';
import '../../domain/imports/domain_imports.dart';

part '../data_sources/${featureName}_data_source.dart';
part '../models/${featureName}_model.dart';
part '../repositories/${featureName}_repository.dart';
part '../di/${featureName}_di.dart';
""";
  }

  //presentation
  String _getBlocContent(String featureName) {
    final usecaseName = 'Fetch${upperCamelCaseFeatureName}UseCase';
    return """
part of '../imports/presentation_imports.dart';

class ${upperCamelCaseFeatureName}Cubit extends Cubit<${upperCamelCaseFeatureName}State> {
  final $usecaseName _fetch${upperCamelCaseFeatureName}UseCase;
  ${upperCamelCaseFeatureName}Cubit(this._fetch${upperCamelCaseFeatureName}UseCase) : super(${upperCamelCaseFeatureName}State.initial());

  void fetch$upperCamelCaseFeatureName() async {
    final result = await _fetch${upperCamelCaseFeatureName}UseCase.call();
    result.when(
      ($lowerCamelCaseFeatureName) => emit(
        state.copyWith(
          baseState: BaseState.success,
          $lowerCamelCaseFeatureName: $lowerCamelCaseFeatureName,
        ),
      ),
      (error) => emit(
        state.copyWith(
          baseState: BaseState.error,
          errorMessage: error.message,
        ),
      ),
    );
  }
}
""";
  }

  String _getBlocStateContent(String featureName) {
    return """
part of '../imports/presentation_imports.dart';
final class ${upperCamelCaseFeatureName}State extends Equatable {
  final BaseState baseState;
  final List<${upperCamelCaseFeatureName}Entity> $lowerCamelCaseFeatureName;
  final String errorMessage;

  const ${upperCamelCaseFeatureName}State({
    required this.baseState,
    required this.$lowerCamelCaseFeatureName,
    this.errorMessage = ConstantManager.emptyText,
  });

  factory ${upperCamelCaseFeatureName}State.initial() {
    return const ${upperCamelCaseFeatureName}State(
      baseState: BaseState.initial,
      $lowerCamelCaseFeatureName: [],
    );
  }

  ${upperCamelCaseFeatureName}State copyWith({
    BaseState? baseState,
    List<${upperCamelCaseFeatureName}Entity>? $lowerCamelCaseFeatureName,
    String? errorMessage,
  }) {
    return ${upperCamelCaseFeatureName}State(
      baseState: baseState ?? this.baseState,
      $lowerCamelCaseFeatureName: $lowerCamelCaseFeatureName ?? this.$lowerCamelCaseFeatureName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [$lowerCamelCaseFeatureName,baseState, errorMessage];
}
""";
  }

  String _getPresentationScreenContent(String featureName) {
    return '''
part of '../imports/presentation_imports.dart';

class ${upperCamelCaseFeatureName}Screen extends StatelessWidget {
  const ${upperCamelCaseFeatureName}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ${upperCamelCaseFeatureName}Cubit(
        ConstantManager.serviceLocator<Fetch${upperCamelCaseFeatureName}UseCase>(),
      )..fetch$upperCamelCaseFeatureName(),
      child: const _${upperCamelCaseFeatureName}View(),
    );
  }
}

class _${upperCamelCaseFeatureName}View extends StatelessWidget {
  const _${upperCamelCaseFeatureName}View();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorManager.scaffoldBackground,
      body: SizedBox(),
    );
  }
}
''';
  }

  String _getPresentationWidgetContent(String featureName) {
    return '''
part of '../imports/presentation_imports.dart';
''';
  }

  String _getPresentationImportsContent(String featureName) {
    return """
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/src/config/res/constans_manager.dart';
import 'package:flutter_base/src/core/shared/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/imports/domain_imports.dart';
import 'package:flutter_base/src/config/res/color_manager.dart';

part '../cubit/${featureName}_cubit.dart';
part '../cubit/${featureName}_state.dart';
part '../screens/${featureName}_screen.dart';
part '../widgets/${featureName}_widget.dart';
    """;
  }
}
