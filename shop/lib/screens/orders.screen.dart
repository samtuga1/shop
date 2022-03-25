import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/AppDrawer.dart';
import '../widgets/order_item.dart' as ord;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isInit = true;
  bool isLoading = false;

  Future<void> fetchData() async {
    final orderData = Provider.of<Orders>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    await orderData.fetchAndSet();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      fetchData();
    }
    isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => ord.OrderItem(
          order: orderData.orders[i],
        ),
      ),
    );
  }
}
