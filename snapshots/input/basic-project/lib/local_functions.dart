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
