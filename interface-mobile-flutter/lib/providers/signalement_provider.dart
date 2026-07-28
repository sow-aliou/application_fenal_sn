import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/signalement_service.dart';

final signalementServiceProvider = Provider<SignalementService>((ref) {
  return SignalementService();
});
