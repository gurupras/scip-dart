// @dart=3.13
class Point(final int x, var int y, {required final int z, final int _w = 0}) {
  this : assert(x >= 0);

  int get sum => x + y + z + _w;
}

class Pair.named(final int first, this.second) {
  final int second;
}

class Plain(int value) {
  final int doubled = 2;
}

class Shape {
  final int sides;
  Shape(this.sides);
}

class Square(final int size, super.sides) extends Shape;

enum Level(final int rank) { low(1), high(2) }

extension type Id.new(int raw) {}

extension type Opaque._(int _) {}

int useAll() =>
    Point(1, 2, z: 3, w: 4).sum +
    Pair.named(1, 2).first +
    Plain(1).doubled +
    Square(2, 4).size +
    Level.high.rank +
    Id(5).raw;
