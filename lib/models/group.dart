import 'package:time_sort/models/sorted_member.dart';

class Group {
  final int id;
  final String name;
  final List<SortedMember> members;
  final bool isReverse;
  final bool isReversed;
  int sort;

  Group({
    required this.id,
    required this.name,
    required this.members,
    required this.isReverse,
    required this.isReversed,
    required this.sort,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    var membersJson = json['members'] as List;
    List<SortedMember> membersList = membersJson.map((i) => SortedMember.fromJson(i)).toList();

    return Group(
      id: json['id'],
      name: json['name'],
      members: membersList,
      isReverse: json['is_reverse'],
      isReversed: json['is_reversed'],
      sort: json['sort'],
    );
  }
}
