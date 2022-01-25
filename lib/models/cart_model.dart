import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loja_virtual/datas/card_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  CartModel(this.user);

  List<CardProduct> products = [];

  void addCartItem(CardProduct cardProduct) {
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

  void removeCartItem(CardProduct cardProduct) {
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cardProduct.cid)
        .delete();

    products.remove(cardProduct);

    notifyListeners();
  }
}
