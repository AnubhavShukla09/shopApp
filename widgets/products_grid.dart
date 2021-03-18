import 'package:flutter/material.dart';
import './product_item.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool data;
  ProductsGrid(this.data);
  @override
  Widget build(BuildContext context) {
    final loadedData = Provider.of<ProductProvider>(context);
    final loadedProduct = data ? loadedData.favouritesOnly : loadedData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: loadedProduct[index],
          child: ProductItem(),
        );
      },
      itemCount: loadedProduct.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
