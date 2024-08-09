import 'package:flutter/material.dart';
import 'package:time_sort/pages/drag_member.dart';
List<String> _list = ["Apple", "Ball", "Cat", "Dog", "Elephant"];

class DragGroupPage extends StatefulWidget {
  DragGroupPage({
    Key? key,
  }) : super(key: key);

  @override
  _DragGroupPageState createState() => _DragGroupPageState();
}

class _DragGroupPageState extends State<DragGroupPage> {
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(),
    body: ReorderableListView(
      children: _list.map((item) => ListTile(key: Key("${item}"), title: Text("${item}"), trailing:Icon(Icons.menu),onTap: (){
             Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>DragMemberPage(),
                          ));
      },)).toList(),
      onReorder: (int start, int current) {
        // dragging from top to bottom
        if (start < current) {
          int end = current - 1;
          String startItem = _list[start];
          int i = 0;
          int local = start;
          do {
            _list[local] = _list[++local];
            i++;
          } while (i < end - start);
          _list[end] = startItem;
        }
        // dragging from bottom to top
        else if (start > current) {
          String startItem = _list[start];
          for (int i = start; i > current; i--) {
            _list[i] = _list[i - 1];
          }
          _list[current] = startItem;
        }
        setState(() {});
      },
    ),
  );
}

}
