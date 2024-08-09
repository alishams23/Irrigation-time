import 'package:flutter/material.dart';
List<String> _list = ["Apple", "Ball", "Cat", "Dog", "Elephant"];

class DragMemberPage extends StatefulWidget {
  DragMemberPage({
    Key? key,
  }) : super(key: key);

  @override
  _DragMemberPageState createState() => _DragMemberPageState();
}

class _DragMemberPageState extends State<DragMemberPage> {
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(),
    body: ReorderableListView(
      children: _list.map((item) => ListTile(key: Key("${item}"), title: Text("${item}"), trailing: Container(width: 100,child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween ,children: [IconButton(onPressed: (){}, icon: Icon(Icons.edit)),Icon(Icons.menu),],)),onTap: (){
        
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
