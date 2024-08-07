import 'package:time_sort/models/sorted_member.dart';

class WaterWell {
  final int id;

  bool isOn;
  final bool isAdmin;
  final String startMember;
  final SortedMember currentMember;
  final SortedMember nextMember;

  WaterWell({
    required this.id,
    required this.isOn,
    required this.isAdmin,
    required this.startMember,
    required this.currentMember,
    required this.nextMember,
  });

  factory WaterWell.fromJson(Map<String, dynamic> json) {
    return WaterWell(
      id: json['id'],
      isOn: json['is_on'],
      isAdmin: json['is_admin'],
      startMember: json['start_member'],
      currentMember: SortedMember.fromJson(json['current_member']),
      nextMember: SortedMember.fromJson(json['next_member']),
    );
  }
}
