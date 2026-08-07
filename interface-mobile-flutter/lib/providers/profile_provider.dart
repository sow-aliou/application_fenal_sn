import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/profile_service.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

final userProfileProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final service = ref.watch(profileServiceProvider);
  return await service.getProfile();
});
