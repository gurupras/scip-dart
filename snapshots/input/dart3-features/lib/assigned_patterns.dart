int swapped() {
  var first = 1, second = 2;
  (first, second) = (second, first);
  return first - second;
}
