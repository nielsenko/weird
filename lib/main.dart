import 'weird.dart';

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
    print('${i.pad(12)} all: ${all.elapsed}, lap: ${lap.elapsedMilliseconds.pad(6)}ms, live points: ${bindings.getPointCount().pad(12)}');
    lap.reset();
  }
}
