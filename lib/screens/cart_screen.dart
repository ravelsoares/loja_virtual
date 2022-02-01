import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/cart_tile.dart';
import 'package:loja_virtual/wigdets/cart_price.dart';
import 'package:loja_virtual/wigdets/discount_card.dart';
import 'package:loja_virtual/wigdets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color prymaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 10.0),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int p = model.products.length;
                return Text(
                  '${p ?? 0} ${p == 1 ? "item" : "items"}',
                  style: TextStyle(fontSize: 17),
                );
              },
            ),
          ),
        ],
      ),
      // ignore: missing_return
      body: ScopedModelDescendant<CartModel>(builder: (context, child, model) {
        if (model.isLoading && UserModel.of(context).isLoggedIn()) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!UserModel.of(context).isLoggedIn()) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.remove_shopping_cart,
                  color: prymaryColor,
                  size: 80,
                ),
                const SizedBox(height: 16),
                Text(
                  'Faça o login para adicionar produtos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: prymaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: const Text(
                    'Entre para comprar',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(prymaryColor),
                  ),
                ),
              ],
            ),
          );
        } else if (model.products == null || model.products.length == 0) {
          return Center(
            child: Text(
              'Nenhum produto no carrinho',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: prymaryColor,
              ),
            ),
          );
        } else {
          return ListView(
            children: [
              Column(
                children: model.products.map((product) {
                  return CartTile(product);
                }).toList(),
              ),
              Discountcard(),
              ShipCard(),
              CartPrice(() async {
                String orderId = await model.finishOrder();
                if (orderId != null) {
                  print(orderId);
                }
              }),
            ],
          );
        }
      }),
    );
  }
}
