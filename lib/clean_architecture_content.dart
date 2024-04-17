part of 'clean_arch_generator.dart';
class _CleanArchtectureContent {
  final String featureName;
  final String upperCamelCaseFeatureName;
  final String lowerCamelCaseFeatureName;

  _CleanArchtectureContent(this.featureName)
      : assert(featureName.isNotEmpty),
        upperCamelCaseFeatureName = featureName.getUpperCamelCase(),
        lowerCamelCaseFeatureName = featureName.getLowerCamelCase();
  String getEntityContent() {
    return """
import 'package:equatable/equatable.dart';
part of '../imports/domain_imports.dart';
class ${upperCamelCaseFeatureName}Entity extends Equatable {
  final int id;
  final String name;

  const ${upperCamelCaseFeatureName}Entity({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}
  """;
  }

  String getUseCaseContent() {
    return """
part of '../imports/domain_imports.dart';

class Fetch${upperCamelCaseFeatureName}UseCase extends UseCase<List<${upperCamelCaseFeatureName}Entity>, String> {
  final ${upperCamelCaseFeatureName}Repository ${lowerCamelCaseFeatureName}Repository;

  Fetch${upperCamelCaseFeatureName}UseCase({required this.${lowerCamelCaseFeatureName}Repository});
  @override
  Future<Result<List<${upperCamelCaseFeatureName}Entity>, Failure>> call([String? param]) async {
    return await ${lowerCamelCaseFeatureName}Repository.get$upperCamelCaseFeatureName();
  }
}
""";
  }

  String getDomainImportsContent() {
    return """
import 'package:flutter_base/src/core/error/failure.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../core/standard/use_case.dart';
import '../../data/imports/data_imports.dart';
part '../use_case/fetch_${featureName}_use_case.dart';
part '../entities/${featureName}_entity.dart';
""";
  }

  String getModelContent() {
    return """
part of '../imports/data_imports.dart';
class ${upperCamelCaseFeatureName}Model extends ${upperCamelCaseFeatureName}Entity {
    ${upperCamelCaseFeatureName}Model({required id, name}) : super(id: id, name: name);
}
""";
  }

  String getRepositoryContent() {
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

  String getDataSourceContent() {
    return """
part  of '../imports/data_imports.dart';
abstract class ${upperCamelCaseFeatureName}DataSource {
  Future<List<${upperCamelCaseFeatureName}Model>> fetch${upperCamelCaseFeatureName}Data();
}

class ${upperCamelCaseFeatureName}DataSourceImpl implements ${upperCamelCaseFeatureName}DataSource {
  @override
  Future<List<${upperCamelCaseFeatureName}Model>> fetch${upperCamelCaseFeatureName}Data() {
    return await Future.value([
      ${upperCamelCaseFeatureName}Model(id: 1, name: 'First $upperCamelCaseFeatureName'),
      ${upperCamelCaseFeatureName}Model(id: 2, name: 'Second $upperCamelCaseFeatureName'),
      ${upperCamelCaseFeatureName}Model(id: 3, name: 'Third $upperCamelCaseFeatureName'),
    ]);
  }
}
  """;
  }

  String getServiceLocatorContent() {
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

  String getDataImportsContent() {
    return """
import 'package:flutter_base/src/core/error/failure.dart';
import 'package:flutter_base/src/core/extensions/error_handler_extension.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:flutter_base/src/config/res/constants_manager.dart';
import '../../domain/imports/domain_imports.dart';

part '../data_sources/${featureName}_data_source.dart';
part '../models/${featureName}_model.dart';
part '../repositories/${featureName}_repository.dart';
part '../di/${featureName}_di.dart';
""";
  }

  // [Presentation Content]
  String getBlocContent() {
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

  String getBlocStateContent() {
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

  String getPresentationScreenContent() {
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

  String getPresentationWidgetContent() {
    return '''
part of '../imports/presentation_imports.dart';
''';
  }

  String getPresentationImportsContent() {
    return """
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/src/config/res/constants_manager.dart';
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
