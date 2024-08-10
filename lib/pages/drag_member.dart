// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_super_parameters, prefer_const_constructors_in_immutables, unnecessary_string_interpolations, avoid_print, sized_box_for_whitespace, empty_catches, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:time_sort/models/sorted_member.dart';
import 'package:time_sort/api/group_farmer_list.dart';

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

  Future<void> _updateWaterWellCurrentMember(String currentMember, int startMember) async {
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

  @override
  Widget build(BuildContext context) {
    TextEditingController minuteController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ReorderableListView(
              children: widget.list
                  .map((item) => ListTile(
                        key: Key("${item.id}"),
                        title: Text("${item.member.fullName}"),
                        trailing: Container(
                            width: 150, // Adjusted width to better fit the dropdown and icon
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.edit), // Use the edit icon as the trigger for the menu
                                  onSelected: (String value) {
                                    if (value == 'تغییر مدت زمان آبیاری') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('تغییر مدت زمان آبیاری', textDirection: TextDirection.rtl),
                                            content: TextField(
                                              controller: minuteController,
                                              textDirection:
                                                  TextDirection.rtl, // Ensures the text inside the TextField is RTL
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'مدت زمان آبیاری (دقیقه)', // This will follow the textDirection of the TextField
                                                hintText: 'عدد را وارد کنید',
                                                hintTextDirection:
                                                    TextDirection.rtl, // Ensure the hint text is also RTL
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text('لغو', textDirection: TextDirection.rtl),
                                                onPressed: () {
                                                  minuteController = TextEditingController();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text('ذخیره', textDirection: TextDirection.rtl),
                                                onPressed: () async {
                                                  int? minutes = int.tryParse(minuteController.text);
                                                  if (minutes != null) {
                                                    // Perform the status change operation and use the minutes value
                                                    Navigator.of(context).pop();
                                                    await _updateMemberIrrigationTime(item.id, minutes);
                                                    // Use the `minutes` value as needed for the irrigation process
                                                  } else {
                                                    // Handle the case where the input is not a valid number
                                                    // For example, show an error message or do nothing
                                                  }
                                                  // Perform save operation
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else if (value == 'تغییر وضعیت به درحال آبیاری') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('تغییر وضعیت به درحال آبیاری'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              textDirection: TextDirection.rtl,
                                              children: [
                                                SizedBox(height: 16.0),
                                                TextField(
                                                  controller: minuteController,
                                                  keyboardType: TextInputType.number,
                                                  textDirection: TextDirection.rtl,
                                                  decoration: InputDecoration(
                                                    alignLabelWithHint: true,
                                                    hintTextDirection: TextDirection.rtl,
                                                    labelText: 'مدت زمان گذشته از شروع آبیاری (دقیقه)',
                                                    hintText: 'عدد را وارد کنید',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text('لغو', textDirection: TextDirection.rtl),
                                                onPressed: () {
                                                  minuteController = TextEditingController();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text('تأیید', textDirection: TextDirection.rtl),
                                                onPressed: () async {
                                                  int? minutes = int.tryParse(minuteController.text);
                                                  if (minutes != null) {
                                                    // Perform the status change operation and use the minutes value
                                                    Navigator.of(context).pop();
                                                    await _updateWaterWellCurrentMember(item.member.username, minutes);
                                                    // Use the `minutes` value as needed for the irrigation process
                                                  } else {
                                                    // Handle the case where the input is not a valid number
                                                    // For example, show an error message or do nothing
                                                  }
                                                },
                                              ),
                                            ],
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
                                Icon(Icons.menu),
                              ],
                            )),
                        onTap: () {},
                      ))
                  .toList(),
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
