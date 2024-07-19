import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ShoppingCartScreen(),
    );
  }
}

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  int _totalPrice = 0;
  final List<_ShoppingItemState> _shoppingItemStates = [];
  final formatCurrency = NumberFormat("#,##0", "en_US");

  static const List<Map<String, dynamic>> _products = [
    {
      "title": "iPad Pro",
      "price": 39000,
      "image": "images/ipadpro.jpg",
    },
    {
      "title": "iPad Air",
      "price": 29000,
      "image": "images/ipadair.jpg",
    },
    {
      "title": "iPad Mini",
      "price": 23000,
      "image": "images/ipadmini.jpg",
    },
    {
      "title": "iPad",
      "price": 19000,
      "image": "images/ipad.jpg",
    },
  ];

  void _updateTotalPrice(int change) {
    setState(() {
      _totalPrice += change;
    });
  }

  void _clearCart() {
    setState(() {
      for (var itemState in _shoppingItemStates) {
        itemState.resetCount();
      }
      _totalPrice = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ShoppingItem(
                  title: product["title"],
                  price: product["price"],
                  imageUrl: product["image"],  // เพิ่มข้อมูลรูปภาพ
                  onPriceChange: _updateTotalPrice,
                  registerItemState: (state) {
                    _shoppingItemStates.add(state);
                  },
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
                  "Total",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${formatCurrency.format(_totalPrice)} บาท',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              onPressed: _clearCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text("Clear Cart", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}

class ShoppingItem extends StatefulWidget {
  final String title;
  final int price;
  final String imageUrl;  // เพิ่มข้อมูลรูปภาพ
  final Function(int) onPriceChange;
  final Function(_ShoppingItemState) registerItemState;

  const ShoppingItem({
    Key? key,
    required this.title,
    required this.price,
    required this.imageUrl,  // เพิ่มข้อมูลรูปภาพ
    required this.onPriceChange,
    required this.registerItemState,
  }) : super(key: key);

  @override
  State<ShoppingItem> createState() => _ShoppingItemState();
}

class _ShoppingItemState extends State<ShoppingItem> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    widget.registerItemState(this);
  }

  void _updateCount(int change) {
    if (count + change >= 0) {
      setState(() {
        count += change;
        widget.onPriceChange(change * widget.price);
      });
    }
  }

  void resetCount() {
    if (count > 0) {
      widget.onPriceChange(-count * widget.price);
      setState(() {
        count = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat("#,##0", "en_US");
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.network(
              widget.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${formatCurrency.format(widget.price)} บาท',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => _updateCount(-1),
                  icon: const Icon(Icons.remove),
                  color: Colors.red,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => _updateCount(1),
                  icon: const Icon(Icons.add),
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
