import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import './inventory.dart';

class InventoryProvider with ChangeNotifier {
  List<Inventory> _items = [
    Inventory(
      id: 'p1',
      title: 'Test Shirt',
      description: 'A red shirt - it is pretty red!',
      count: 29,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Inventory(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      count: 59,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Inventory(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      count: 19,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Inventory(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      count: 49,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Inventory> get items {
    return [..._items];
  }

  Inventory findById(String id) {
    return _items.firstWhere((inventory) => inventory.id == id);
  }

  void addInventory(Inventory inventory) {
    final newInventory = Inventory(
      id: DateTime.now().toString(),
      title: inventory.title,
      count: inventory.count,
      description: inventory.description,
      imageUrl: inventory.imageUrl,
    );
    _items.insert(0, newInventory);
    notifyListeners();
  }

  void updateInventory(String id, Inventory newInventory) {
    final inventoryIndex = _items.indexWhere((inventory) => inventory.id == id);
    _items[inventoryIndex] = newInventory;
    notifyListeners();
  }

  void deleteInventory(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
