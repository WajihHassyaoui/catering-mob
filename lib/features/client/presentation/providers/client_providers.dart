import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/group_order_model.dart';

final clientNavIndexProvider = StateProvider<int>((ref) => 0);
final activeGroupOrderProvider = StateProvider<GroupOrder?>((ref) => null);
