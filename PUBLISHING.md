# Publishing Checklist

Use this checklist before publishing `base_app_kit` to pub.dev.

## Package Metadata

- `pubspec.yaml` has a clear package `description`.
- `version` matches the latest entry in `CHANGELOG.md`.
- `homepage`, `repository`, `issue_tracker`, and `documentation` point to public URLs.
- `topics` are relevant and no more than five items.
- `LICENSE` is a real license, not a placeholder.
- `README.md` explains installation, no-Riverpod usage, Riverpod usage, and the problem solved by the package.

## Package Scope

- Core package dependencies stay minimal. Riverpod belongs in the example app only.
- Do not include app-specific routing, network clients, storage, DI containers, generated files, secrets, or private assets.
- Keep the public export file at `lib/base_app_kit.dart` aligned with the intended API surface.

## Local Verification

Run these from the package root:

```bash
dart format .
flutter analyze
flutter test
flutter pub publish --dry-run
```

Run these from `example/`:

```bash
flutter pub get
flutter analyze
flutter test
```

## Final Publish

After the dry run is clean:

```bash
flutter pub publish
```
