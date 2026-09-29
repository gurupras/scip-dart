  import 'closures.dart';
// definition scip-dart pub dart_test 1.0.0 lib/`closures_use.dart`/
  
  // Named arguments to stored closures from another file resolve to the
  // closures' own parameters.
  int useClosures() =>
//^^^ reference scip-dart pub dart:core 3.13.0 dart:core/`int.dart`/int#
//    ^^^^^^^^^^^ definition scip-dart pub dart_test 1.0.0 lib/`closures_use.dart`/useClosures().
      stored(body: 1) + Holder().cb(body: 2) + partStored(body: 3);
//    ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/stored.
//           ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/stored.`<anonymous>`(1).(body)
//                      ^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/Holder#`<constructor>`().
//                               ^^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/Holder#cb.
//                                  ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`closures.dart`/Holder#cb.`<anonymous>`(1).(body)
//                                             ^^^^^^^^^^ reference scip-dart pub dart_test 1.0.0 lib/`closures_part.dart`/partStored.
//                                                        ^^^^ reference scip-dart pub dart_test 1.0.0 lib/`closures_part.dart`/partStored.`<anonymous>`(1).(body)
  
