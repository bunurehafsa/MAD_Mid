import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _counter = 0;

  final List<Widget> _children = [ListViewPage(0), CounterPage(0)];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _children[0] = ListViewPage(_counter);
      _children[1] = CounterPage(_counter);
    });
  }

  void updateCounter(int counter) {
    setState(() {
      _counter = counter;
      _children[0] = ListViewPage(_counter);
      _children[1] = CounterPage(_counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/1.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          _children[_currentIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 124, 155, 190),
        selectedFontSize: 12,
        selectedItemColor: Colors.white,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List View',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.countertops),
            label: 'Counter',
          ),
        ],
      ),
    );
  }
}



class ListViewPage extends StatefulWidget {
  final int itemCount;
  ListViewPage(this.itemCount);

  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  List<dynamic> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _items = data.take(widget.itemCount).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.statusCode}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List View'),
      backgroundColor: Color.fromARGB(255, 124, 155, 190),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final color = index % 2 == 0 ? Color.fromARGB(255, 221, 189, 211) : Color.fromARGB(255, 176, 227, 243);
          return Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: ListTile(
              title: Text(_items[index]['title']),
              subtitle: Text(_items[index]['body']),
            ),
          );
        },
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  final int initialCounter;
  CounterPage(this.initialCounter);

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter;

  _CounterPageState() : _counter = 0;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialCounter;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    // Access the parent state to update the counter value
    (context.findAncestorStateOfType<_HomeScreenState>())?.updateCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter'),
      backgroundColor: Color.fromARGB(255, 124, 155, 190),),
      body: Center(
        child: Text('Counter: $_counter', style: TextStyle(fontSize: 24)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: Icon(Icons.add),
      ),
    );
  }
}
