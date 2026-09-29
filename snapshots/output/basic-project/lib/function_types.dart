  // Generic function types: their type parameters are namespaced under the
// definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/
  // declaration that holds the type, ranked among sibling function types.
  typedef Fn = T Function<T>(T x);
//        ^^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/Fn#
//             ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/Fn#`<function-type>`(1).[T]
//                        ^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/Fn#`<function-type>`(1).[T]
//                           ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/Fn#`<function-type>`(1).[T]
  
  class FunctionTypes {
//      ^^^^^^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/FunctionTypes#
    T Function<T>(T)? first;
//  ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/FunctionTypes#first.`<function-type>`(1).[T]
//             ^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/FunctionTypes#first.`<function-type>`(1).[T]
//                ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/FunctionTypes#first.`<function-type>`(1).[T]
//                    ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/FunctionTypes#first.
    T Function<T>(T)? second;
//  ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/FunctionTypes#second.`<function-type>`(1).[T]
//             ^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/FunctionTypes#second.`<function-type>`(1).[T]
//                ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/FunctionTypes#second.`<function-type>`(1).[T]
//                    ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/FunctionTypes#second.
  }
  
  T Function<T>(T) outer(T Function<T>(S Function<S>(S) g) h) => throw 0;
//^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/outer().`<function-type>`(1).[T]
//           ^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/outer().`<function-type>`(1).[T]
//              ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/outer().`<function-type>`(1).[T]
//                 ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/outer().
//                       ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/outer().`<function-type>`(2).[T]
//                                  ^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/outer().`<function-type>`(2).[T]
//                                     ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/outer().`<function-type>`(2).`<function-type>`(1).[S]
//                                                ^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/outer().`<function-type>`(2).`<function-type>`(1).[S]
//                                                   ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/outer().`<function-type>`(2).`<function-type>`(1).[S]
//                                                         ^ definition local 0
  
  // A non-generic function type takes no rank.
  void mixed(void Function() cb, T Function<T>(T) f) {}
//     ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/mixed().
//                           ^^ definition local 1
//                               ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/mixed().`<function-type>`(1).[T]
//                                          ^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/mixed().`<function-type>`(1).[T]
//                                             ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/mixed().`<function-type>`(1).[T]
//                                                ^ definition local 2
  
  // A function-typed parameter's type parameters.
  void functionTypedParameter(T g<T>(T x)) {}
//     ^^^^^^^^^^^^^^^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/functionTypedParameter().
//                            ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/functionTypedParameter().(g)[T]
//                              ^ definition local 3
//                                ^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/functionTypedParameter().(g)[T]
//                                   ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/functionTypedParameter().(g)[T]
//                                     ^ definition local 4
  
  // A bound, an extension type representation, an old-style typedef and a curried type.
  class Bounded<X extends T Function<T>(T)> {}
//      ^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/Bounded#
//              ^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/Bounded#[X]
//                        ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/Bounded#`<function-type>`(1).[T]
//                                   ^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/Bounded#`<function-type>`(1).[T]
//                                      ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/Bounded#`<function-type>`(1).[T]
  
  extension type Wrapper(T Function<T>(T) f) {}
  
  typedef R OldStyle<R>(R x);
//        ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/OldStyle#[R]
//          ^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/OldStyle#
//                   ^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/OldStyle#[R]
//                      ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/OldStyle#[R]
//                        ^ definition local 5
  
  int Function<T>(T) Function<S>(S) curried() => throw 0;
//^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//             ^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/curried().`<function-type>`(1).`<function-type>`(1).[T]
//                ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/curried().`<function-type>`(1).`<function-type>`(1).[T]
//                            ^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/curried().`<function-type>`(1).[S]
//                               ^ reference scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/curried().`<function-type>`(1).[S]
//                                  ^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`function_types.dart`/curried().
  
