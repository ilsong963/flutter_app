
class ItemBox {
  String name;
  int price;
  bool ischecked = false;

  ItemBox(String name, int price) {
    this.name = name;
    this.price = price;
  }

  @override
  String toString() {
    return 'ItemBox{name: $name, name: $price, ischecked: $ischecked}';
  }
}