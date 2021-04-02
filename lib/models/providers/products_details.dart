import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/providers/product.dart';

class ProductInfo with ChangeNotifier {
  List<Product> _products = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl: 'https://beautifull.cc/wp-content/uploads/2018/07/3835.jpg',
    ),
    Product(
        id: 'p5',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl: 'https://beautifull.cc/wp-content/uploads/2018/07/3835.jpg'),
    Product(
        id: 'p2',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl: 'https://beautifull.cc/wp-content/uploads/2018/07/3835.jpg'),
    Product(
        id: 'p3',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl: 'https://beautifull.cc/wp-content/uploads/2018/07/3835.jpg'),
    Product(
        id: 'p4',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl: 'https://beautifull.cc/wp-content/uploads/2018/07/3835.jpg'),
  ];

  List<Product> get productItems {
    return _products;
  }

  List<Product> get faviorteProduct {
    return _products.where((product) => product.isFaviourte).toList();
  }

  addProduct(Product product) {
    final newProduct = Product(
        id: DateTime.now().toString(),
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price);
    _products.add(newProduct);
    notifyListeners();
  }

  Product findById(String id) {
    return productItems.where((product) => product.id == id).first;
  }

  updateProduct(String id, Product newProduct) {
    print(id);
    assert(id.isNotEmpty, "Empty Id");
    if (id.isNotEmpty) {
      final index = _products.indexWhere((element) => element.id == id);
      if (index >= 0) {
        _products[index] = newProduct;
        notifyListeners();
      } else {
        print('No index');
      }
    }
  }

  deleteProduct(String id) {
    if (id.isNotEmpty) {
      _products.removeWhere((prod) => prod.id == id);
      notifyListeners();
    }
  }
}
