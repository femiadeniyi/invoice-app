class InvoiceItem {
  String description;
  String shift;
  double units;
  double rate;

  InvoiceItem(this.description, this.shift, this.units, this.rate);

  InvoiceItem.fromJson(Map<String, dynamic> json)
      : description = json["description"],
        shift = json["shift"],
        rate = json["rate"],
        units = json["units"];

  Map<String, dynamic> toJson() =>
      {
        'description': description,
        'shift': shift,
        'rate': rate,
        'units': units,
      };

  String toString() {
    return "{description:$description,shift:$shift,unitOrRate:$units,rate:$rate}";
  }
}
