
class ItemBox {
  final int id;
  final String name;
  final int price;

  ItemBox({this.id, this.name, this.price});

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'species': price,
  };
}
