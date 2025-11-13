import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(home: LayoutDemo());
  }
}

class LayoutDemo extends StatelessWidget {
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Layouts Demo'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'List'),
              Tab(text: 'Grid'),
              Tab(text: 'Scrolling'),
            ],
          ),
        ),
        body: TabBarView(
          children: [ListExample(), GridExample(), ScrollingExample()],
        ),
      ),
    );
  }
}

class ListExample extends StatelessWidget {
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              'Item $index',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
class GridExample extends StatelessWidget {
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(9, (index) {
        return Container(
          margin: EdgeInsets.all(4),
          color: Colors.blue,
          child: Center(child: Text('$index')),
        );
      }),
    );
  }
}


class ScrollingExample extends StatelessWidget {
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 150,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Sliver Demo'),
            background: Container(color: Colors.teal),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 39, 165, 176), //selected from flutter colors
              ),
              child: ListTile(
                title: Text(
                  'Row $index',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            childCount: 10,
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 33, 144, 191), //selected from flutter colors
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Grid $index',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            childCount: 9,
          ),
        ),
      ],
    );
  }
}
