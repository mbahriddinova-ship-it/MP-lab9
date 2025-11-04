//Madina Bahriddinova
//Student id: 220155
//Lab 9

import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced UI Design Lab',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(
        isDark: isDark,
        onThemeChanged: (value) {
          setState(() {
            isDark = value;
          });
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

//----------------------------------------------------
// 1. Basic Layout Widgets + 
// 2. Custom Stateless Widget
class CustomTitle extends StatelessWidget {
  final String text;
  final Color color;

  const CustomTitle({required this.text, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

//----------------------------------------------------
// 3. Custom Stateful Widget – Counter
class CustomCounter extends StatefulWidget {
  @override
  _CustomCounterState createState() => _CustomCounterState();
}

class _CustomCounterState extends State<CustomCounter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => setState(() => count--),
          icon: Icon(Icons.remove_circle, color: Colors.red),
        ),
        Text(
          '$count',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => setState(() => count++),
          icon: Icon(Icons.add_circle, color: Colors.green),
        ),
      ],
    );
  }
}

//----------------------------------------------------
// 4–10. Combined HomePage
class HomePage extends StatefulWidget {
  final bool isDark;
  final Function(bool) onThemeChanged;

  const HomePage({required this.isDark, required this.onThemeChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  // For AnimatedContainer
  bool toggled = false;

  // For Explicit Animation
  late AnimationController _controller;
  late Animation<double> _animation;

  // For GestureDetector
  Color bgColor = Colors.white;

  // For AnimatedList
  final List<int> _items = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int counter = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: 200).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void addItem() {
    _items.insert(0, counter++);
    _listKey.currentState!.insertItem(0, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('MP Advanced UI Lab'),
        actions: [
          Row(
            children: [
              Icon(Icons.light_mode),
              Switch(
                value: widget.isDark,
                onChanged: (value) => widget.onThemeChanged(value),
              ),
              Icon(Icons.dark_mode),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Task 1: Basic Layout
            CustomTitle(text: '1. Layout Widgets'),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                4,
                (i) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.primaries[i],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Task 3: Custom Counter
            CustomTitle(text: '2 & 3. Custom Widgets'),
            CustomCounter(),
            SizedBox(height: 20),

            // Task 5: AnimatedContainer
            CustomTitle(text: '5. Implicit Animation'),
            GestureDetector(
              onTap: () => setState(() => toggled = !toggled),
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                width: toggled ? 150 : 100,
                height: toggled ? 150 : 100,
                decoration: BoxDecoration(
                  color: toggled ? Colors.purple : Colors.orange,
                  borderRadius:
                      BorderRadius.circular(toggled ? 50 : 10),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Task 6: Explicit Animation
            CustomTitle(text: '6. Explicit Animation'),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  margin: EdgeInsets.only(left: _animation.value),
                  child: FlutterLogo(size: 60),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                _controller.forward(from: 0);
              },
              child: Text('Animate Logo'),
            ),
            SizedBox(height: 20),

            // Task 7: GestureDetector
            CustomTitle(text: '7. GestureDetector'),
            GestureDetector(
              onTap: () => setState(() => bgColor = Colors.lightBlueAccent),
              onDoubleTap: () => setState(() => bgColor = Colors.greenAccent),
              onLongPress: () => setState(() => bgColor = Colors.redAccent),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                color: Colors.grey[300],
                child: Text(
                  'Tap / Double Tap / Long Press Here',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Task 9: AnimatedList
            CustomTitle(text: '9. AnimatedList'),
            Container(
              height: 200,
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _items.length,
                itemBuilder: (context, index, animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: Card(
                      child: ListTile(
                        title: Text('Item ${_items[index]}'),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: addItem,
              child: Text('Add Item'),
            ),
            SizedBox(height: 30),

            // Task 10: Mini Project Section
            CustomTitle(text: '10. Themed Interactive UI'),
            Text(
              'This page combines all widgets: custom, animated, themed, and interactive elements.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
