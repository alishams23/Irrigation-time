import 'package:time_sort/models/user.dart';

class SortedMember {
  final int id;
  final User member;
  final int sort;
  final int time;

  SortedMember({
    required this.id,
    required this.member,
    required this.sort,
    required this.time,
  });

  factory SortedMember.fromJson(Map<String, dynamic> json) {
    return SortedMember(
      id: json['id'],
      member: User.fromJson(json['member']),
      sort: json['sort'],
      time: json['time'],
    );
  }
}
