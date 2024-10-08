import 'package:time_sort/models/sorted_member.dart';

class WaterWell {
  final int id;

  bool isOn;
  String offTime;
  String address;
  String fullName;
  final bool isAqueduct;
  final bool isAdmin;
  final String startMember;
  final SortedMember currentMember;
  final SortedMember nextMember;
  final SortedMember? previousMember;

  WaterWell({
    required this.id,
    required this.isOn,
    required this.offTime,
    required this.address,
    required this.fullName,
    required this.isAqueduct,
    required this.isAdmin,
    required this.startMember,
    required this.currentMember,
    required this.nextMember,
    this.previousMember,
  });

  factory WaterWell.fromJson(Map<String, dynamic> json) {
    return WaterWell(
      id: json['id'],
      isOn: json['is_on'],
      offTime: json['off_time'],
      address: json['address'],
      fullName: json['self_user']['full_name'],
      isAdmin: json['is_admin'],
      isAqueduct: json['is_aqueduct'],
      startMember: json['start_member'],
      currentMember: SortedMember.fromJson(json['current_member']),
      nextMember: SortedMember.fromJson(json['next_member']),
      previousMember: json['previous_member'] == null ? null : SortedMember.fromJson(json['previous_member']),
    );
  }
}
