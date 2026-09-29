class Engine {
  final int power;
  final String label;
  Engine(this.power, {this.label = ''});
  Engine.electric({int volts = 0}) : power = volts, label = 'electric';
}

mixin Quiet {}

class QuietEngine = Engine with Quiet;

class Turbo extends QuietEngine {
  Turbo(super.power, {super.label});
}

int rate() =>
    QuietEngine(1, label: 'q').power +
    QuietEngine.electric(volts: 2).power +
    Turbo(3, label: 't').power;
