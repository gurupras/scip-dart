class PrivateBase {
  int _tick() => 0;
  int _count = 0;
  int get _label => _count;
}

class SameLibraryOverride extends PrivateBase {
  @override
  int _tick() => 1;
}
