// Generic function types: their type parameters are namespaced under the
// declaration that holds the type, ranked among sibling function types.
typedef Fn = T Function<T>(T x);

class FunctionTypes {
  T Function<T>(T)? first;
  T Function<T>(T)? second;
}

T Function<T>(T) outer(T Function<T>(S Function<S>(S) g) h) => throw 0;

// A non-generic function type takes no rank.
void mixed(void Function() cb, T Function<T>(T) f) {}

// A function-typed parameter's type parameters.
void functionTypedParameter(T g<T>(T x)) {}

// A bound, an extension type representation, an old-style typedef and a curried type.
class Bounded<X extends T Function<T>(T)> {}

extension type Wrapper(T Function<T>(T) f) {}

typedef R OldStyle<R>(R x);

int Function<T>(T) Function<S>(S) curried() => throw 0;
