part of 'clean_arch_generator.dart';

class _RepositoryArchitectureGenerator {
  final String upperCamelCaseFeatureName;
  final String lowerCamelCaseFeatureName;
  final String featureName;
  _RepositoryArchitectureGenerator(this.featureName)
      : assert(featureName.isNotEmpty),
        upperCamelCaseFeatureName = featureName.getUpperCamelCase(),
        lowerCamelCaseFeatureName = featureName.getLowerCamelCase();
  // [Presentation Content]
  String getBlocContent() {
    final repositoryName = '${upperCamelCaseFeatureName}Repository';
    return """
part of '../imports/presentation_imports.dart';

class ${upperCamelCaseFeatureName}Cubit extends Cubit<${upperCamelCaseFeatureName}State> {
  final $repositoryName ${lowerCamelCaseFeatureName}Repository;
  ${upperCamelCaseFeatureName}Cubit(this.${lowerCamelCaseFeatureName}Repository) : super(${upperCamelCaseFeatureName}State.initial());

  void fetch$upperCamelCaseFeatureName() async {
    final result = await ${lowerCamelCaseFeatureName}Repository.get$upperCamelCaseFeatureName();
    result.when(
      ($lowerCamelCaseFeatureName) => emit(
        state.copyWith(
          baseStatus: BaseStatus.success,
          $lowerCamelCaseFeatureName: $lowerCamelCaseFeatureName,
        ),
      ),
      (error) => emit(
        state.copyWith(
          baseStatus: baseStatus.error,
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
  final BaseStatus baseStatus;
  final List<${upperCamelCaseFeatureName}Model> $lowerCamelCaseFeatureName;
  final String errorMessage;

  const ${upperCamelCaseFeatureName}State({
    required this.baseStatus,
    required this.$lowerCamelCaseFeatureName,
    this.errorMessage = ConstantManager.emptyText,
  });

  factory ${upperCamelCaseFeatureName}State.initial() {
    return const ${upperCamelCaseFeatureName}State(
      baseStatus: BaseStatus.initial,
      $lowerCamelCaseFeatureName: [],
    );
  }

  ${upperCamelCaseFeatureName}State copyWith({
    BaseStatus? baseStatus,
    List<${upperCamelCaseFeatureName}Model>? $lowerCamelCaseFeatureName,
    String? errorMessage,
  }) {
    return ${upperCamelCaseFeatureName}State(
      baseStatus: baseStatus ?? this.baseStatus,
      $lowerCamelCaseFeatureName: $lowerCamelCaseFeatureName ?? this.$lowerCamelCaseFeatureName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [$lowerCamelCaseFeatureName,baseStatus, errorMessage];
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
        ${upperCamelCaseFeatureName}Repository(),
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
import '../../data/imports/data_imports.dart';
import 'package:flutter_base/src/config/res/color_manager.dart';

part '../cubit/${featureName}_cubit.dart';
part '../cubit/${featureName}_state.dart';
part '../screens/${featureName}_screen.dart';
part '../widgets/${featureName}_widget.dart';
    """;
  }

  //[Data Content]
  String getModelContent() {
    return """
part of '../imports/data_imports.dart';
class ${upperCamelCaseFeatureName}Model {
  final int id;
  final String name;
  
  ${upperCamelCaseFeatureName}Model({
    required this.id,
    required this.name,
  });
}
""";
  }

  String getRepositoryContent() {
    return """
part of '../imports/data_imports.dart';

class ${upperCamelCaseFeatureName}Repository {
  Future<Result<List<${upperCamelCaseFeatureName}Model>, Failure>> get$upperCamelCaseFeatureName() async {
    return await Future.value([
      ${upperCamelCaseFeatureName}Model(id: 1, name: 'First $upperCamelCaseFeatureName'),
      ${upperCamelCaseFeatureName}Model(id: 2, name: 'Second $upperCamelCaseFeatureName'),
      ${upperCamelCaseFeatureName}Model(id: 3, name: 'Third $upperCamelCaseFeatureName'),
    ]).handleCallbackWithFailure();
  }
}
  """;
  }

  String getDataImports() {
    return """
import 'package:flutter_base/src/core/extensions/error_handler_extension.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:flutter_base/src/core/error/failure.dart';

import '../../../../config/res/constants_manager.dart';
part '../repositories/product_details_repository.dart';
part '../models/product_details_model.dart';
    """;
  }

}
