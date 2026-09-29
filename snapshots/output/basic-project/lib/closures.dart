  // Anonymous functions: each gets its own descriptor, ranked among its siblings.
// definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/
  part 'closures_part.dart';
  
  void call(void Function({int body}) f) => f(body: 1);
//     ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/call().
//                         ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                                    ^ definition local 0
//                                          ^ reference local 0
  
  void twoClosures() {
//     ^^^^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/twoClosures().
    call(({int body = 0}) {});
//  ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/call().
//         ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//             ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/twoClosures().`<anonymous>`(1).(body)
    call(({int body = 0}) {});
//  ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/call().
//         ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//             ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/twoClosures().`<anonymous>`(2).(body)
  }
  
  void nested() {
//     ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/nested().
    call(({int body = 0}) {
//  ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/call().
//         ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//             ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/nested().`<anonymous>`(1).(body)
      call(({int body = 0}) {});
//    ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/call().
//           ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//               ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/nested().`<anonymous>`(1).`<anonymous>`(1).(body)
    });
    call(({int body = 0}) {});
//  ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/call().
//         ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//             ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/nested().`<anonymous>`(2).(body)
  }
  
  void generics() {
//     ^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/generics().
    final g1 = <T>(T x) => x;
//        ^^ definition local 1
//              ^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/generics().`<anonymous>`(1).[T]
//                 ^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/generics().`<anonymous>`(1).[T]
//                   ^ definition local 2
//                         ^ reference local 2
    final g2 = <T>(T y) => y;
//        ^^ definition local 3
//              ^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/generics().`<anonymous>`(2).[T]
//                 ^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/generics().`<anonymous>`(2).[T]
//                   ^ definition local 4
//                         ^ reference local 4
    g1(1);
//  ^^ reference local 1
    g2(2);
//  ^^ reference local 3
  }
  
  final stored = ({int body = 0}) => body;
//      ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/stored.
//                 ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                     ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/stored.`<anonymous>`(1).(body)
//                                   ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/stored.`<anonymous>`(1).(body)
  
  class Holder {
//      ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/Holder#
    final cb = ({int body = 0}) => body;
//        ^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/Holder#cb.
//               ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                   ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/Holder#cb.`<anonymous>`(1).(body)
//                                 ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/Holder#cb.`<anonymous>`(1).(body)
  }
  
  extension on int {
// definition local 5
//             ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
    void go() => call(({int body = 0}) {});
//       ^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/`<extension on int>(1)`#go().
//       diagnostic Warning:
//       > The declaration 'go' isn't referenced.
//               ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/call().
//                      ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                          ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/`<extension on int>(1)`#go().`<anonymous>`(1).(body)
  }
  
  extension on String {
// definition local 6
//             ^^^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`string.dart`/String#
    void go() => call(({int body = 0}) {});
//       ^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/`<extension on String>(1)`#go().
//       diagnostic Warning:
//       > The declaration 'go' isn't referenced.
//               ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/call().
//                      ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                          ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures.dart`/`<extension on String>(1)`#go().`<anonymous>`(1).(body)
  }
  
