import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MyApp(),
    ),
  );
}
class Cart with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
  void deleteProduct(Product product) {
    _items.remove(product);
    notifyListeners();
  }
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.price);
  }
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alışveriş Sepeti',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  final List<Product> products = [
    Product(id: '1', name: 'Ürün 1', price: 10.0),
    Product(id: '2', name: 'Ürün 2', price: 20.0),
    Product(id: '3', name: 'Ürün 3', price: 30.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürünler'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index].name),
            subtitle:  Text('${products[index].price}'),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Provider.of<Cart>(context, listen: false).addProduct(products[index]);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${products[index].name} sepete eklendi!')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sepet'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final product = cart.items[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle:  Text('${product.price}'),
                  trailing: IconButton(onPressed: (){
                    Provider.of<Cart>(context,listen: false).deleteProduct(product);
                  }, icon: Icon(Icons.remove)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Toplam:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Consumer<Cart>(
                  builder: (context, cart, child) {
                    return const Text(
                      '\${cart.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
