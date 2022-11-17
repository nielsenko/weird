import 'dart:ffi';
import 'dart:io';

import 'weird_bindings_generated.dart';

const String _libName = 'weird';

/// The dynamic library in which the symbols for [WeirdBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS) {
    return DynamicLibrary.open('lib$_libName.dylib');
  } else if (Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  } else {
    throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
  }
}();

/// The bindings to the native functions in [_dylib].
final WeirdBindings _bindings = WeirdBindings(_dylib);

final _nativeFinalizer = NativeFinalizer(_bindings.addresses.deletePoint.cast());

class PointHandle implements Finalizable {
  final Pointer<Point> _point;

  PointHandle(int x, int y) : _point = _bindings.createPoint(x, y) {
    _nativeFinalizer.attach(this, _point.cast(), detach: this, externalSize: 16);
  }

  int get x => _point.ref.x;
  int get y => _point.ref.y;

  void release() {
    _nativeFinalizer.detach(this);
    _bindings.deletePoint(_point);
  }
}

extension on int {
  String pad(int length) => toString().padLeft(length);
}

Future<void> main() async {
  const count = 1000 * 1000 * 1000; // 1 billion
  const chunk = 1000;

  // final garbage = <PointHandle>[];
  final all = Stopwatch()..start();
  final lap = Stopwatch()..start();
  for (int i = 0; i < count; i += chunk) {
    List.generate(chunk, (j) => PointHandle(j, j)); // leave as garbage
    print('${i.pad(12)} all: ${all.elapsed}, lap: ${lap.elapsedMilliseconds.pad(6)}ms, live points: ${_bindings.getPointCount().pad(12)}');
    lap.reset();
  }

  assert(_bindings.getPointCount() == count);
  while (_bindings.getPointCount() > 0) {
    await Future.delayed(const Duration(seconds: 1));
    print(_bindings.getPointCount());
  }
  assert(_bindings.getPointCount() == 0);
}
