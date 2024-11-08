import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:market_list_project/controllers/itemController.dart';
import 'package:market_list_project/services/pdfServices.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemController itemController = Get.put(ItemController());
    final PdfService pdfService = PdfService();

    itemController.loadItems();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await pdfService.generateShoppingListPdf(itemController.items);
            },
            icon: Icon(
              color: Color(0xFFFDFBD4),
              Icons.picture_as_pdf,
            ),
          ),
        ],
        backgroundColor: Color(0xFF00aa46),
        title: Text(
          'Market List',
          style: TextStyle(
            color: Color(0xFFFDFBD4),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (itemController.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Lista vazia :(',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 500,
                  height: 500,
                  child: RiveAnimation.asset(
                    'assets/animations/empty.riv',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: itemController.items.length,
            itemBuilder: (context, index) {
              final item = itemController.items[index];
              return ListTile(
                title: Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                    'Quantidade: ${item.quantity}, Status: ${item.status}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: item.status == 'Comprado',
                      onChanged: (value) {
                        Get.snackbar(
                          backgroundColor: Color(0xFF00aa46),
                          colorText: Color(0xFFFDFBD4),
                          'Opa! Item comprado :)',
                          'Você comprou o item ${item.name}!',
                          snackPosition: SnackPosition.TOP,
                          boxShadows: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        );
                        itemController.toggleStatus(item);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Get.snackbar(
                          backgroundColor: Color(0xFF00aa46),
                          colorText: Color(0xFFFDFBD4),
                          'Item excluído',
                          'Você excluiu o item ${item.name}!',
                          snackPosition: SnackPosition.TOP,
                          boxShadows: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        );

                        itemController.deleteItem(item.id!);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF00aa46),
        onPressed: () {
          _dialogAddItem(context, itemController);
        },
        child: Icon(
          Icons.add_shopping_cart_rounded,
          color: Color(0xFFFDFBD4),
        ),
      ),
    );
  }

  void _dialogAddItem(BuildContext context, ItemController itemController) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantidade',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Color(0xFFFDFBD4),
              ),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
              ),
              onPressed: () {
                final String name = _nameController.text;
                final int quantity =
                    int.tryParse(_quantityController.text) ?? 1;

                if (name.isEmpty) {
                  Get.snackbar(
                    'Erro',
                    'O nome do item não pode estar vazio',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    borderRadius: 8,
                    margin: const EdgeInsets.all(10),
                    boxShadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  );
                  return;
                } else {
                  itemController.addItem(name, quantity);
                  Navigator.of(context).pop();
                }

                Get.snackbar(
                  backgroundColor: Color(0xFF00aa46),
                  colorText: Color(0xFFFDFBD4),
                  'Item adicionado!',
                  'Você adicionou o item ${name}!',
                  boxShadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  snackPosition: SnackPosition.TOP,
                );
              },
              child: Text(
                'Adicionar',
                style: TextStyle(
                  color: Color(0xFFFDFBD4),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
