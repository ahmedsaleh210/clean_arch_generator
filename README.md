### clean_arch_generator

A Dart package to generate clean architecture files for Flutter projects.

#### Usage

To use this package, run the following command in your terminal:

```bash
dart run clean_arch_generator:create --name <feature_name>
```

Replace `<feature_name>` with the name of the feature you want to generate files for.

#### Usage

Once you've installed the package and provided the feature name, it will generate the following files:

- **Domain:**
  - Entities
  - Use Cases
- **Data:**
  - Models
  - Repositories
  - Dependency Injection
- **Presentation:**
  - Cubit
  - Screens
  - Widgets
- **DI:**
  - Dependency Injection setup
