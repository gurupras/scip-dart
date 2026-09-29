  // @dart=3.13
// definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/
  class Point(final int x, var int y, {required final int z, final int _w = 0}) {
//      ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#
//      ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#`<constructor>`().
//                  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                      ^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#x.
//                      ^ definition local 0
//                             ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                                 ^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#y.
//                                 ^ definition local 1
//                                                    ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                                                        ^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#z.
//                                                        ^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#`<constructor>`().(z)
//                                                                 ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                                                                     ^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#_w.
//                                                                     ^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#`<constructor>`().(w)
    this : assert(x >= 0);
//                ^ reference local 0
  
    int get sum => x + y + z + _w;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//          ^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#`<get>sum`.
//                 ^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#x.
//                     ^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#y.
//                         ^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#z.
//                             ^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#_w.
  }
  
  class Pair.named(final int first, this.second) {
//      ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Pair#
//           ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Pair#named().
//                       ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                           ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Pair#first.
//                           ^^^^^ definition local 2
//                                       ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Pair#second.
//                                       ^^^^^^ definition local 3
    final int second;
//        ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//            ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Pair#second.
  }
  
  class Plain(int value) {
//      ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Plain#
//      ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Plain#`<constructor>`().
//            ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                ^^^^^ definition local 4
    final int doubled = 2;
//        ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//            ^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Plain#doubled.
  }
  
  class Shape {
//      ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Shape#
    final int sides;
//        ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//            ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Shape#sides.
    Shape(this.sides);
//  ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Shape#`<constructor>`().
//             ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Shape#sides.
//             ^^^^^ definition local 5
  }
  
  class Square(final int size, super.sides) extends Shape;
//      ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Square#
//      relationship scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Shape# implementation
//      ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Square#`<constructor>`().
//                   ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                       ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Square#size.
//                       ^^^^ definition local 6
//                                   ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Shape#sides.
//                                   ^^^^^ definition local 7
//                                                  ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Shape#
  
  enum Level(final int rank) { low(1), high(2) }
//     ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Level#
//     ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Level#`<constructor>`().
//                 ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                     ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Level#rank.
//                     ^^^^ definition local 8
//                             ^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Level#low.
//                                     ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Level#high.
  
  extension type Id.new(int raw) {}
//               ^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Id#
//                  ^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Id#`<constructor>`().
//                      ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                          ^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Id#raw.
//                          ^^^ definition local 9
  
  extension type Opaque._(int _) {}
//               ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Opaque#
//                      ^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Opaque#_().
//                        ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                            ^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Opaque#_.
//                            ^ definition local 10
  
  int useAll() =>
//^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//    ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/useAll().
      Point(1, 2, z: 3, w: 4).sum +
//    ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#`<constructor>`().
//                ^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#`<constructor>`().(z)
//                      ^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#`<constructor>`().(w)
//                            ^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Point#`<get>sum`.
      Pair.named(1, 2).first +
//    ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Pair#
//         ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Pair#named().
//                     ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Pair#first.
      Plain(1).doubled +
//    ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Plain#`<constructor>`().
//             ^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Plain#doubled.
      Square(2, 4).size +
//    ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Square#`<constructor>`().
//                 ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Square#size.
      Level.high.rank +
//    ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Level#
//          ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Level#high.
//               ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Level#rank.
      Id(5).raw;
//    ^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Id#`<constructor>`().
//          ^^^ reference scip-dart pub dart_test 1.0.0 lib/`primary_constructors.dart`/Id#raw.
  
