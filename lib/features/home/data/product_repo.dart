import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product_model.dart';

class ProductRepo {
  final _products = FirebaseFirestore.instance.collection('products');

  Future<List<ProductModel>> getProducts() async {
    final snapshot = await _products.get();
    return snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}