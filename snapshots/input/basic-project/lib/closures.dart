// Anonymous functions: each gets its own descriptor, ranked among its siblings.
part 'closures_part.dart';

void call(void Function({int body}) f) => f(body: 1);

void twoClosures() {
  call(({int body = 0}) {});
  call(({int body = 0}) {});
}

void nested() {
  call(({int body = 0}) {
    call(({int body = 0}) {});
  });
  call(({int body = 0}) {});
}

void generics() {
  final g1 = <T>(T x) => x;
  final g2 = <T>(T y) => y;
  g1(1);
  g2(2);
}

final stored = ({int body = 0}) => body;

class Holder {
  final cb = ({int body = 0}) => body;
}

extension on int {
  void go() => call(({int body = 0}) {});
}

extension on String {
  void go() => call(({int body = 0}) {});
}
