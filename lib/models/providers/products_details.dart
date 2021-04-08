import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/exception.dart';
import 'package:max_ecommerce/models/providers/product.dart';
import 'package:http/http.dart' as http;

class ProductInfo with ChangeNotifier {
  updateState(List<Product> _items, String? token, String? userId) {
    _products = _items;
    this.token = token;
    this.userId = userId;
    print(_products);
    print(token);
  }

  String? token;
  String? userId;
  bool isInit = true;
  List<Product> _products = [];

  List<Product>? get productItems {
    return _products;
  }

  List<Product> get faviorteProduct {
    return _products.where((product) => product.isFaviourte).toList();
  }

  Future<void> getProductWeb([bool filterByUser = false]) async {
    final String fetchFav =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://maxecommerce-fb341-default-rtdb.firebaseio.com/products.json?auth=$token$fetchFav"');
    final response = await http.get(url);
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<Product> _productsItems = [];

        final bodies = (await jsonDecode(response.body)) == null
            ? {}
            : (await jsonDecode(response.body) as Map<String, dynamic>);
        final urlFav = Uri.parse(
            'https://maxecommerce-fb341-default-rtdb.firebaseio.com/isFaviourte/$userId.json?auth=$token');
        final responseFav = await http.get(urlFav);
        final isFav = jsonDecode(responseFav.body);
        bodies.forEach((prodId, productInfo) async {
          _productsItems.add(Product(
              id: prodId,
              title: productInfo['title'],
              imageUrl: productInfo['imageUrl'],
              description: productInfo['description'],
              price: productInfo['price'],
              isFaviourte: isFav == null ? false : ((isFav[prodId]) ?? false)));
        });

        _products = _productsItems;
        if (isInit) notifyListeners();
        isInit = false;
      }
    } on Exception catch (e) {
      // TODO
      print(e);
      throw (e);
    }
  }

  Future<void> addProduct(Product product) {
    final url = Uri.parse(
        'https://maxecommerce-fb341-default-rtdb.firebaseio.com/products.json?auth=$token');
    return http
        .post(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'creatorId': userId
            }))
        .then((response) {
      print(json.decode(response.body));
      final newProduct = Product(
          id: json.decode(response.body)['name'].toString(),
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          userId: userId);
      _products.add(newProduct);
      print('');
      notifyListeners();
    }).catchError((error) => throw (error));
  }

  Product findById(String id) {
    return productItems!.where((product) => product.id == id).first;
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    print(id);
    assert(id.isNotEmpty, "Empty Id");
    if (id.isNotEmpty) {
      final index = _products.indexWhere((element) => element.id == id);
      if (index >= 0) {
        final url = Uri.parse(
            'https://maxecommerce-fb341-default-rtdb.firebaseio.com/products/$id.json?auth=$token');
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
            }));
        _products[index] = newProduct;
        notifyListeners();
      } else {
        print('No index');
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://maxecommerce-fb341-default-rtdb.firebaseio.com/products/$id.json?auth=$token');
    final int productIndex =
        _products.indexWhere((element) => element.id == id);
    Product? productItem = _products[productIndex];
    _products.remove(productItem);
    notifyListeners();

    final respose = await http.delete(url);
    if (respose.statusCode > 400) {
      _products.insert(productIndex, productItem);
      notifyListeners();
      print(respose.statusCode);
      throw (ExceptionHandle('Failed to delete product'));
    }
    productItem = null;
  }
}
