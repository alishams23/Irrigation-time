// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_super_parameters, prefer_const_constructors_in_immutables, unnecessary_string_interpolations, avoid_print, sized_box_for_whitespace, empty_catches, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:time_sort/models/sorted_member.dart';
import 'package:time_sort/api/group_farmer_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _loading = false;

class DragMemberPage extends StatefulWidget {
  final List<SortedMember> list;

  DragMemberPage({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  _DragMemberPageState createState() => _DragMemberPageState();
}

class _DragMemberPageState extends State<DragMemberPage> {
  String? selectedOption;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    fetchAdminStatus();
  }

  void fetchAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? isAdminString = prefs.getString("is_admin");
    setState(() {
      _isAdmin = isAdminString == "true"; // Adjust based on how "is_admin" is stored
    });
  }

  Future<void> _updateMemberIrrigationTime(int memberId, int minutes) async {
    try {
      setState(() {
        _loading = true;
      });
      await ApiSortGroupMemberList().updateMemberTime(memberId, minutes);
      setState(() {
        _loading = false;
      });
      print('Time updated successfully');
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Error updating time: $e');
    }
  }

  Future<void> _updateWaterWellCurrentMember(int currentMember, int startMember) async {
    try {
      setState(() {
        _loading = true;
      });
      await ApiSortGroupMemberList().updateWaterWellCurrentMember(currentMember, startMember);
      setState(() {
        _loading = false;
      });
      print('Water well current member updated successfully');
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Error updating water well current member: $e');
    }
  }

  Future<void> updateSortOrder() async {
    ApiSortGroupMemberList api = ApiSortGroupMemberList();

    // Prepare the data to be sent to the API
    List<Map<String, dynamic>> updatedData = widget.list.map((group) {
      return {
        'id': group.id,
        'sort': group.sort,
      };
    }).toList();

    try {
      await api.updateMember(updatedData);
      print('Members updated successfully.');
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget buildListItem(SortedMember item, int index) {
    TextEditingController minuteController = TextEditingController();
    return Container(
      key: Key("${item.id}"),
      color: index % 2 == 0 ? Color.fromARGB(255, 9, 32, 11) : Colors.black, // Alternate background colors
      child: ListTile(
        leading: Text(
          "${index + 1}",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ), // Show the index starting from 1
        title: Text(
          "${item.member.fullName}",
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          "${item.time} دقیقه",
          style: TextStyle(color: Colors.white),
        ),
        trailing: _isAdmin
            ? Container(
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton<String>(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onSelected: (String value) {
                        if (value == 'تغییر مدت زمان آبیاری') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: AlertDialog(
                                  title: Text('تغییر مدت زمان آبیاری'),
                                  content: TextField(
                                    controller: minuteController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'مدت زمان آبیاری (دقیقه)',
                                      hintText: 'عدد را وارد کنید',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('لغو'),
                                      onPressed: () {
                                        minuteController = TextEditingController();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('ذخیره'),
                                      onPressed: () async {
                                        int? minutes = int.tryParse(minuteController.text);
                                        if (minutes != null) {
                                          Navigator.of(context).pop();
                                          await _updateMemberIrrigationTime(item.id, minutes);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else if (value == 'تغییر وضعیت به درحال آبیاری') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: AlertDialog(
                                  title: Text('تغییر وضعیت به درحال آبیاری'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 16.0),
                                      TextField(
                                        controller: minuteController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          alignLabelWithHint: true,
                                          labelText: 'مدت زمان گذشته از شروع آبیاری (دقیقه)',
                                          hintText: 'عدد را وارد کنید',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('لغو'),
                                      onPressed: () {
                                        minuteController = TextEditingController();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('تأیید'),
                                      onPressed: () async {
                                        int? minutes = int.tryParse(minuteController.text);
                                        if (minutes != null) {
                                          Navigator.of(context).pop();
                                          await _updateWaterWellCurrentMember(item.id, minutes);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            value: 'تغییر مدت زمان آبیاری',
                            child: Text('تغییر مدت زمان آبیاری'),
                          ),
                          PopupMenuItem(
                            value: 'تغییر وضعیت به درحال آبیاری',
                            child: Text('تغییر وضعیت به درحال آبیاری'),
                          ),
                        ];
                      },
                    ),
                    Icon(Icons.menu, color: Colors.white),
                  ],
                ),
              )
            : null, // Hide trailing widgets for non-admins
        onTap: () {},
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
                    children: widget.list.asMap().entries.map((entry) {
                      int index = entry.key;
                      SortedMember item = entry.value;
                      return buildListItem(item, index);
                    }).toList(),
                    onReorder: (int start, int current) async {
                      setState(
                        () {
                          if (start < current) {
                            int end = current - 1;
                            SortedMember startItem = widget.list[start];
                            int i = 0;
                            int local = start;
                            do {
                              widget.list[local] = widget.list[++local];
                              i++;
                            } while (i < end - start);
                            widget.list[end] = startItem;
                          } else if (start > current) {
                            SortedMember startItem = widget.list[start];
                            for (int i = start; i > current; i--) {
                              widget.list[i] = widget.list[i - 1];
                            }
                            widget.list[current] = startItem;
                          }
                        },
                      );
                      // Update the sort order in the list
                      for (int i = 0; i < widget.list.length; i++) {
                        widget.list[i].sort = i + 1;
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
                    children: widget.list.asMap().entries.map((entry) {
                      int index = entry.key;
                      SortedMember item = entry.value;
                      return buildListItem(item, index);
                    }).toList(),
                  ),
      ),
    );
  }
}
