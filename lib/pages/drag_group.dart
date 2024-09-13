// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_super_parameters, prefer_const_constructors_in_immutables, unnecessary_string_interpolations, avoid_print, await_only_futures, empty_catches

import 'package:flutter/material.dart';
import 'package:time_sort/pages/drag_member.dart';
import 'package:time_sort/api/group_farmer_list.dart';
import 'package:time_sort/models/group.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    fetchAdminStatus();
    fetchGroups();
  }

  void fetchAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? isAdminString = prefs.getString("is_admin");
    setState(() {
      _isAdmin = isAdminString == "true"; // Adjust based on how "is_admin" is stored
    });
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

  Widget buildListItem(Group item, int index) {
    return Container(
      key: Key("${item.id}"),
      color: index % 2 == 0 ? const Color.fromARGB(255, 9, 32, 11) : Colors.black, // Alternate background colors
      child: ListTile(
        leading: Text(
          "${index + 1}",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ), // Show the index starting from 1
        title: Text(
          "${item.name}",
          style: TextStyle(color: Colors.white),
        ),
        trailing: _isAdmin
            ? Icon(
                Icons.menu,
                color: Colors.white,
              )
            : null, // Show reorder icon only for admins
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DragMemberPage(list: item.members),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Moved Directionality to the top level
      child: Scaffold(
        appBar: AppBar(
          title: Text("آبیاری هوشمند"),
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _isAdmin
                ? ReorderableListView(
                    proxyDecorator: (Widget child, int index, Animation<double> animation) {
                      return Material(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: child,
                        ),
                      );
                    },
                    children: _list.asMap().entries.map((entry) {
                      int index = entry.key;
                      Group item = entry.value;
                      return buildListItem(item, index);
                    }).toList(),
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
                        _list[i].sort = i + 1;
                      }

                      try {
                        setState(() {
                          _loading = true;
                        });
                        await updateSortOrder();
                        setState(() {
                          _loading = false;
                        });
                      } catch (e) {
                        print('Error: $e');
                      }
                    },
                  )
                : ListView(
                    children: _list.asMap().entries.map((entry) {
                      int index = entry.key;
                      Group item = entry.value;
                      return buildListItem(item, index);
                    }).toList(),
                  ),
      ),
    );
  }
}
