# Melos Project

This is a melos-managed monorepo for Dart/Flutter projects.

## Getting Started

1. Install dependencies:
   ```bash
   dart pub get
   ```

2. Bootstrap the workspace:
   ```bash
   melos bootstrap
   ```

## Available Scripts

- `melos analyze` - Run dart analyze on all packages
- `melos test` - Run tests for all packages
- `melos format` - Format all Dart code
- `melos clean` - Clean all packages
- `melos pub-get` - Run pub get in all packages

## Project Structure

- `packages/` - Shared packages/libraries
- `apps/` - Applications (Flutter apps, CLI tools, etc.)

## Adding New Packages

Create new packages in the `packages/` directory:

```bash
cd packages
dart create my_package
```

Create new apps in the `apps/` directory:

```bash
cd apps
flutter create my_app
```

After adding new packages or apps, run:

```bash
melos bootstrap
```
