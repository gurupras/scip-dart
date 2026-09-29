  // Local functions: named under their parent, ranked among same-named siblings.
// definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/
  int helper() => 0;
//^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//    ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/helper().
  
  int first() {
//^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//    ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/first().
    int helper() => 1;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//      ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/first().helper(1).
    return helper();
//         ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/first().helper(1).
  }
  
  int second() {
//^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//    ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/second().
    int helper() => 2;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//      ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/second().helper(1).
    return helper();
//         ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/second().helper(1).
  }
  
  void blocks(bool b) {
//     ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/blocks().
//            ^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`bool.dart`/bool#
//                 ^ definition local 0
    if (b) {
//      ^ reference local 0
      T helper<T>(T v, {int body = 0}) => v;
//    ^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/blocks().helper(1).[T]
//      ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/blocks().helper(1).
//             ^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/blocks().helper(1).[T]
//                ^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/blocks().helper(1).[T]
//                  ^ definition local 1
//                      ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                          ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/blocks().helper(1).(body)
//                                        ^ reference local 1
      helper(1, body: 1);
//    ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/blocks().helper(1).
//              ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/blocks().helper(1).(body)
    } else {
      T helper<T>(T v, {int body = 0}) => v;
//    ^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/blocks().helper(2).[T]
//      ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/blocks().helper(2).
//             ^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/blocks().helper(2).[T]
//                ^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/blocks().helper(2).[T]
//                  ^ definition local 2
//                      ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                          ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/blocks().helper(2).(body)
//                                        ^ reference local 2
      helper(2, body: 2);
//    ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/blocks().helper(2).
//              ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/blocks().helper(2).(body)
    }
  }
  
  void call(void Function() f) => f();
//     ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/call().
//                          ^ definition local 3
//                                ^ reference local 3
  
  // A local function nested in a local function is named under it.
  void nest() {
//     ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/nest().
    int outer() {
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//      ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/nest().outer(1).
      int deep() => 4;
//    ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//        ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/nest().outer(1).deep(1).
      return deep();
//           ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/nest().outer(1).deep(1).
    }
    outer();
//  ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/nest().outer(1).
  }
  
  // A closure inside a local function is not named under it; a local function
  // inside that closure is named under the closure.
  void mix() {
//     ^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/mix().
    void outer2() {
//       ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/mix().outer2(1).
      call(() {
//    ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/call().
        int d() => 1;
//      ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//          ^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/mix().`<anonymous>`(1).d(1).
        d();
//      ^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/mix().`<anonymous>`(1).d(1).
      });
    }
    outer2();
//  ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/mix().outer2(1).
  }
  
  // A local function escaping through an inferred type keeps its name when its
  // named parameter is used from another file (see local_functions_use.dart).
  final escaped = () {
//      ^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/escaped.
    int h({int body = 0}) => body;
//  ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//      ^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/escaped.`<anonymous>`(1).h(1).
//         ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//             ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/escaped.`<anonymous>`(1).h(1).(body)
//                           ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/escaped.`<anonymous>`(1).h(1).(body)
    return h;
//         ^ reference scip-dart pub dart_test 1.0.0 lib/`local_functions.dart`/escaped.`<anonymous>`(1).h(1).
  }();
  
