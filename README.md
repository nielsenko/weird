# weird

A new FFI plugin project that illustrates an issue with native finalizers.

## Run with Dart
### Build
```
cmake -G Ninja -S src -B build
cmake --build build
cp build/libweird.dylib . # assuming macos
```
### Run
```
dart run lib/main.dart
```

## Run with Flutter

### Setup
```
# assuming macos
flutter create . --platform macos
cd example
flutter create . --platform macos 
```

### Run
```
flutter run -d macos # assuming macos
```
