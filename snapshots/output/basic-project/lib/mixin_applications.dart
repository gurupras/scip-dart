  class Engine {
// definition scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/
//      ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#
    final int power;
//        ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//            ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#power.
    final String label;
//        ^^^^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`string.dart`/String#
//               ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#label.
    Engine(this.power, {this.label = ''});
//  ^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#`<constructor>`().
//              ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#power.
//              ^^^^^ definition local 0
//                           ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#label.
//                           ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#`<constructor>`().(label)
    Engine.electric({int volts = 0}) : power = volts, label = 'electric';
//         ^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#electric().
//                   ^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//                       ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#electric().(volts)
//                                     ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#power.
//                                             ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#electric().(volts)
//                                                    ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#label.
  }
  
  mixin Quiet {}
//      ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Quiet#
  
  class QuietEngine = Engine with Quiet;
//      ^^^^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/QuietEngine#
//      relationship scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine# implementation
//      relationship scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Quiet# implementation
//                    ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#
//                                ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Quiet#
  
  class Turbo extends QuietEngine {
//      ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Turbo#
//      relationship scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine# implementation
//      relationship scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Quiet# implementation
//      relationship scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/QuietEngine# implementation
//                    ^^^^^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/QuietEngine#
    Turbo(super.power, {super.label});
//  ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Turbo#`<constructor>`().
//              ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#power.
//              ^^^^^ definition local 1
//                            ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#`<constructor>`().(label)
//                            ^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Turbo#`<constructor>`().(label)
  }
  
  int rate() =>
//^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//    ^^^^ definition scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/rate().
      QuietEngine(1, label: 'q').power +
//    ^^^^^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#`<constructor>`().
//                   ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#`<constructor>`().(label)
//                               ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#power.
      QuietEngine.electric(volts: 2).power +
//    ^^^^^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/QuietEngine#
//                ^^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#electric().
//                         ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#electric().(volts)
//                                   ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#power.
      Turbo(3, label: 't').power;
//    ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Turbo#`<constructor>`().
//             ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Turbo#`<constructor>`().(label)
//                         ^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`mixin_applications.dart`/Engine#power.
  
