// Generic function types: their type parameters are namespaced under the
// declaration that holds the type, ranked among sibling function types.
typedef Fn = T Function<T>(T x);

class FunctionTypes {
  T Function<T>(T)? first;
  T Function<T>(T)? second;
}

T Function<T>(T) outer(T Function<T>(S Function<S>(S) g) h) => throw 0;
