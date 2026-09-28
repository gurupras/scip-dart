// @dart=3.7
// Catch-clause parameters are definitions; a wildcard `_` (language 3.7 and
// later, set above for this library) is not a binding.
void mayThrow() {}

void catches() {
  try {
    mayThrow();
  } on StateError catch (e, st) {
    var x = 1;
    print(x);
    print(e);
    print(st);
  }
  try {
    mayThrow();
  } catch (_) {}
}
