part of 'clean_arch_generator.dart';
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
