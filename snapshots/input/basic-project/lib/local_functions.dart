// Local functions: named under their parent, ranked among same-named siblings.
int helper() => 0;

int first() {
  int helper() => 1;
  return helper();
}

int second() {
  int helper() => 2;
  return helper();
}

void blocks(bool b) {
  if (b) {
    T helper<T>(T v, {int body = 0}) => v;
    helper(1, body: 1);
  } else {
    T helper<T>(T v, {int body = 0}) => v;
    helper(2, body: 2);
  }
}

void call(void Function() f) => f();

// A local function nested in a local function is named under it.
void nest() {
  int outer() {
    int deep() => 4;
    return deep();
  }
  outer();
}

// A closure inside a local function is not named under it; a local function
// inside that closure is named under the closure.
void mix() {
  void outer2() {
    call(() {
      int d() => 1;
      d();
    });
  }
  outer2();
}

// A local function escaping through an inferred type keeps its name when its
// named parameter is used from another file (see local_functions_use.dart).
final escaped = () {
  int h({int body = 0}) => body;
  return h;
}();
