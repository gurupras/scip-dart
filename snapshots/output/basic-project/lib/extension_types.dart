  // @dart=3.3
// definition scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/
  extension type Meters(double value) {
//               ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Meters#
//               ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Meters#`<constructor>`().
//                      ^^^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`double.dart`/double#
//                             ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Meters#value.
//                             ^^^^^ definition local 0
    Meters twice() => Meters(value * 2);
//  ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Meters#
//         ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Meters#twice().
//                    ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Meters#`<constructor>`().
//                           ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Meters#value.
  }
  
  extension type const Token._(String text) {
//                     ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Token#
//                           ^ definition scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Token#_().
//                             ^^^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`string.dart`/String#
//                                    ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Token#text.
//                                    ^^^^ definition local 1
    factory Token.of(String text) => Token._(text.trim());
//                ^^ definition scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Token#of().
//                   ^^^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`string.dart`/String#
//                          ^^^^ definition local 2
//                                   ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Token#
//                                         ^ reference scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Token#_().
//                                           ^^^^ reference local 2
//                                                ^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`string.dart`/String#trim().
  }
  
  double total(Meters a, Token t) => a.twice().value + t.text.length;
//^^^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`double.dart`/double#
//       ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/total().
//             ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Meters#
//                    ^ definition local 3
//                       ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Token#
//                             ^ definition local 4
//                                   ^ reference local 3
//                                     ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Meters#twice().
//                                             ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Meters#value.
//                                                     ^ reference local 4
//                                                       ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`extension_types.dart`/Token#text.
//                                                            ^^^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`string.dart`/String#`<get>length`.
  
