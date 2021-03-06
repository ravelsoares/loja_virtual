import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadcartItems();
    }
  }

  List<CartProduct> products = [];

  String couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void decProduct(CartProduct product) {
    product.quantity--;

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(product.cid)
        .updateData(product.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct product) {
    product.quantity++;

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(product.cid)
        .updateData(product.toMap());

    notifyListeners();
  }

  void addCartItem(CartProduct cardProduct) {
    products.add(cardProduct);

    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .add(cardProduct.toMap())
        .then((doc) {
      cardProduct.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cardProduct) {
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cardProduct.cid)
        .delete();

    products.remove(cardProduct);

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;

    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.productData.price * c.quantity;
      }
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  Future<String> finishOrder() async {
    if (products.length == 0) {
      return null;
    } else {
      isLoading = true;
      notifyListeners();

      double productsPrice = getProductsPrice();
      double shipPrice = getShipPrice();
      double discount = getDiscount();

      DocumentReference refOrder =
          await Firestore.instance.collection('orders').add({
        'clientId': user.firebaseUser.uid,
        'products': products.map((cartProduct) => cartProduct.toMap()).toList(),
        'productsPrice': productsPrice,
        'discount': discount,
        'shipPrice': shipPrice,
        'totalPrice': productsPrice + shipPrice - discount,
        'status': 1,
      });

      await Firestore.instance
          .collection('users')
          .document(user.firebaseUser.uid)
          .collection('orders')
          .document(refOrder.documentID)
          .setData({
        'orderId': refOrder.documentID,
      });

      QuerySnapshot query = await Firestore.instance
          .collection('users')
          .document(user.firebaseUser.uid)
          .collection('cart')
          .getDocuments();

      for (DocumentSnapshot doc in query.documents) {
        doc.reference.delete();
      }

      products.clear();
      discountPercentage = 0;
      couponCode = null;
      isLoading = false;
      notifyListeners();

      return refOrder.documentID;
    }
  }

  void _loadcartItems() async {
    QuerySnapshot query = await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .getDocuments();

    products =
        query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }
}
