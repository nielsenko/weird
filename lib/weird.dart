import 'dart:ffi';
import 'dart:io';

import 'weird_bindings_generated.dart';

const String _libName = 'weird';

/// The dynamic library in which the symbols for [WeirdBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS) {
    try {
      return DynamicLibrary.open('lib$_libName.dylib');
    } catch (_) {
      return DynamicLibrary.open('$_libName.framework/$_libName');
    }
  } else if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  } else {
    throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
  }
}();

/// The bindings to the native functions in [_dylib].
final WeirdBindings bindings = WeirdBindings(_dylib);

final _nativeFinalizer = NativeFinalizer(bindings.addresses.deletePoint.cast());

class PointHandle implements Finalizable {
  final Pointer<Point> _point;

  PointHandle(int x, int y) : _point = bindings.createPoint(x, y) {
    _nativeFinalizer.attach(this, _point.cast(), detach: this, externalSize: 16);
  }

  int get x => _point.ref.x;
  int get y => _point.ref.y;

  void release() {
    _nativeFinalizer.detach(this);
    bindings.deletePoint(_point);
  }
}
