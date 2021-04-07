import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  String? token;
  final String? userId;
  bool isFaviourte;
  _savFav(bool isFav) {
    isFaviourte = isFav;
    notifyListeners();
  }

  Product(
      {required this.id,
      this.userId,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFaviourte = false});
  Future<void> toggleIsFaviorteState(String? tokenId, String? userId) async {
    final oldFav = isFaviourte;
    isFaviourte = !isFaviourte;
    token = tokenId;
    notifyListeners();
    final url = Uri.parse(
        'https://maxecommerce-fb341-default-rtdb.firebaseio.com/isFaviourte/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(url, body: jsonEncode(isFaviourte));
      if (response.statusCode > 400) {
        _savFav(oldFav);
      }
    } on Exception catch (e) {
      _savFav(oldFav);

      // TODO
    }
  }
}
