import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';

class CartTile extends StatelessWidget {
  CartProduct product;
  CartTile(this.product);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      CartModel.of(context).updatePrices();
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            height: 120,
            child: Image.network(
              product.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    product.productData.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    'Tamanho ${product.size}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    'R\$ ${product.productData.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: product.quantity > 1
                            ? () {
                                CartModel.of(context).decProduct(product);
                              }
                            : null,
                        icon: Icon(
                          Icons.remove,
                          color: product.quantity > 1
                              ? Theme.of(context).primaryColor
                              : Colors.grey[500],
                        ),
                      ),
                      Text(product.quantity.toString()),
                      IconButton(
                        onPressed: () {
                          CartModel.of(context).incProduct(product);
                        },
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          CartModel.of(context).removeCartItem(product);
                        },
                        child: Text(
                          'Remover',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        style: const ButtonStyle(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: product.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: Firestore.instance
                  .collection('products')
                  .document(product.category)
                  .collection('items')
                  .document(product.pid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  product.productData = ProductData.fromDocument(snapshot.data);
                  return _buildContent();
                } else {
                  return Container(
                    height: 70,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : _buildContent(),
    );
  }
}
