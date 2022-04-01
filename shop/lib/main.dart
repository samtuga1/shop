import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import './screens/auth-screen.dart';
import './screens/user_products_screen.dart';
import './screens/orders.screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './screens/edit_product_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(auth.token, auth.userId, previousProducts?.items == null ? [] : previousProducts!.items),
          create: (ctx) => Products.diffConstructor(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(auth.token, auth.userId, previousOrders?.orders == null ? [] : previousOrders!.orders),
          create: (ctx) => Orders.diffConstructor(),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? const ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) =>
                const ProductsOverviewScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            ProductDetailScreen.id: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            UserProductsScreen.id: (ctx) => const UserProductsScreen(),
            EditProductScreen.id: (ctx) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
