import 'private_overrides.dart';

// These do not override PrivateBase's members: a private name is scoped to
// its library.
class OtherLibrary extends PrivateBase {
  int _tick() => 2;
  int _count = 0;
  int get _label => _count;
}
