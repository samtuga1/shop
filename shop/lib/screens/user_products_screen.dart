import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/AppDrawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const id = '/user_products';
  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).getAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.id, arguments: 'p0');
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, i) => Column(
              children: [
                UserProductItem(
                  id: productsData.items[i].id,
                  imageUrl: productsData.items[i].imageUrl,
                  title: productsData.items[i].title,
                ),
                const Divider(
                  indent: 60,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
