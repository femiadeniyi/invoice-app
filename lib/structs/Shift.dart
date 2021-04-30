class Shift {
  String name;
  double rate;

  Shift(this.name, this.rate);

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
