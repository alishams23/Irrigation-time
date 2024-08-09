import 'package:time_sort/models/user.dart';

class SortedMember {
  final int id;
  final User member;
  final int sort;
  final int time;
  final int? year;
  final int? month;
  final int? day;
  final int? hour;
  final int? minute;
  final bool? isOn;

  SortedMember({
    required this.id,
    required this.member,
    required this.sort,
    required this.time,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.isOn,
  });

  factory SortedMember.fromJson(Map<String, dynamic> json) {
    return SortedMember(
      id: json['id'],
      member: User.fromJson(json['member']),
      sort: json['sort'],
      time: json['time'],
      year: json['year'],
      month: json['month'],
      day: json['day'],
      hour: json['hour'],
      minute: json['minute'],
      isOn: json['is_on'],
    );
  }
}
