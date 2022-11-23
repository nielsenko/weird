# weird

A new FFI plugin project that illustrates an issue with native finalizers.


## Build

cmake -G Ninja -S src -B build
cmake --build build
cp build/libweird.dylib .

## Run

dart run lib/main.dart
