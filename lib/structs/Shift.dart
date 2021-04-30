class Shift {
  String name;
  double rate;

  Shift(this.name, this.rate);

  static List<Shift> defaultValues() {
    return [
      Shift("Domil 30", 5.00),
      Shift("Domil 45", 7.00),
      Shift("Domil 60", 9.00),
      Shift("Long Shift", 108.00),
      Shift("Waking Night", 9.00),
      Shift("Live in Weekly", 85.71),
      Shift("Live in Daily", 150),
    ];
  }

  Shift.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        rate = json["rate"];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'rate': rate,
      };

  String toString() {
    return "{name:$name,rate:$rate}";
  }
}
