import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/home_tab.dart';
import 'package:loja_virtual/tabs/products_tabe.dart';
import 'package:loja_virtual/wigdets/cart_button.dart';
import 'package:loja_virtual/wigdets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text('Produtos'),
            centerTitle: true,
          ),
          body: ProductsTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
      ],
    );
  }
}
