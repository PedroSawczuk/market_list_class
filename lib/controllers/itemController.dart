import 'package:get/get.dart';
import 'package:market_list_project/db/databaseHelper.dart';
import 'package:market_list_project/models/itemModel.dart';

class ItemController extends GetxController {
  var items = <ItemModel>[].obs;

  Future<void> loadItems() async {
    final dbItems =
        await DatabaseHelper.instance.getItems(status: 'Não Comprado');
    items.value = dbItems;
  }

  Future<void> addItem(String name, int quantity) async {
    final newItem = ItemModel(
      name: name,
      quantity: quantity,
      status: 'Não Comprado',
    );
    final id = await DatabaseHelper.instance.insertItem(newItem);
    items.add(newItem.copyWith(id: id));
  }

  Future<void> deleteItem(int id) async {
    await DatabaseHelper.instance.deleteItem(id);
    items.removeWhere((item) => item.id == id);
  }

  Future<void> toggleStatus(ItemModel item) async {
    final newStatus =
        item.status == 'Não Comprado' ? 'Comprado' : 'Não Comprado';
    await DatabaseHelper.instance.updateItemStatus(item.id!, newStatus);
    items.removeWhere((i) => i.id == item.id);
  }
}
