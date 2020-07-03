import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_getx/product/models/image.model.dart';

import './models/product.model.dart';

class ProductService {
  CollectionReference productsRef = Firestore.instance.collection("products");

  Stream<List<Product>> findAll() {
    return productsRef.getDocuments().then((value) {
      return value.documents.map((e) => Product.fromSnapshot(e)).toList();
    }).asStream();
  }

  Future<Product> findOne(String id) async {
    var result = await productsRef.document(id).get();
    return Product.fromSnapshot(result);
  }

  Future<Product> addOne({
    String userId,
    String username,
    String name,
    String desc,
    double price,
    int quantity,
  }) async {
    var result = await productsRef.add({
      "user_id": userId,
      "username": username,
      "name": name,
      "desc": desc,
      "price": price,
      "quantity": quantity,
      "created_at": DateTime.now().toUtc().toString(),
    });
    return Product(
      id: result.documentID,
      name: name,
      desc: desc,
      userId: userId,
      username: username,
      price: price,
      quantity: quantity,
    );
  }

  Future<void> updateOne(Product product) async {
    productsRef.document(product.id).updateData(product.toJson());
  }

  deleteOne(String id) {
    productsRef.document(id).delete();
  }

  addGallery(String productId, List<ImageModel> images) {
    productsRef.document(productId).updateData(
      {
        "gallery": images.map((e) => e.toJson()).toList(),
      },
    );
  }
}