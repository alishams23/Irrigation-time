// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_super_parameters, prefer_const_constructors_in_immutables, unnecessary_string_interpolations, avoid_print, await_only_futures, empty_catches

import 'package:flutter/material.dart';
import 'package:time_sort/pages/drag_member.dart';
import 'package:time_sort/api/group_farmer_list.dart';
import 'package:time_sort/models/group.dart';

List<Group> _list = [];
bool _loading = true;

class DragGroupPage extends StatefulWidget {
  DragGroupPage({
    Key? key,
  }) : super(key: key);

  @override
  _DragGroupPageState createState() => _DragGroupPageState();
}

class _DragGroupPageState extends State<DragGroupPage> {
  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> updateSortOrder() async {
    ApiSortGroupMemberList api = ApiSortGroupMemberList();

    // Prepare the data to be sent to the API
    List<Map<String, dynamic>> updatedData = _list.map((group) {
      return {
        'id': group.id,
        'sort': group.sort,
      };
    }).toList();

    try {
      await api.updateGroup(updatedData);
      print('Groups updated successfully.');
    } catch (e) {
      print('Error: $e');
    }
  }

  void fetchGroups() async {
    ApiSortGroupMemberList api = ApiSortGroupMemberList();
    try {
      List<Group> groups = await api.fetchFarmerGroups();
      setState(() {
        _list = groups;
        _loading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ReorderableListView(
              children: _list
                  .map(
                    (item) => ListTile(
                      key: Key("${item.id}"),
                      title: Text("${item.name}"),
                      trailing: Icon(Icons.menu),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DragMemberPage(list: item.members),
                            ));
                      },
                    ),
                  )
                  .toList(),
              onReorder: (int start, int current) async {
                setState(
                  () {
                    if (start < current) {
                      int end = current - 1;
                      Group startItem = _list[start];
                      int i = 0;
                      int local = start;
                      do {
                        _list[local] = _list[++local];
                        i++;
                      } while (i < end - start);
                      _list[end] = startItem;
                    } else if (start > current) {
                      Group startItem = _list[start];
                      for (int i = start; i > current; i--) {
                        _list[i] = _list[i - 1];
                      }
                      _list[current] = startItem;
                    }
                  },
                );
                // Update the sort order in the list
                for (int i = 0; i < _list.length; i++) {
                  _list[i].sort = i + 1; // Update the sort field with the new order
                }

                try {
                  _loading = true;
                  await updateSortOrder();
                  setState(() {
                    _loading = false;
                  });
                } catch (e) {}
              },
            ),
    );
  }
}
