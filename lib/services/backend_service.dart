// lib/services/backend_service.dart
import 'package:cloud_functions/cloud_functions.dart';

class BackendService {
  final _fns = FirebaseFunctions.instanceFor(region: 'europe-west1');

  Future<Map<String, dynamic>> ping() async {
    final res = await _fns.httpsCallable('ping').call();
    return Map<String, dynamic>.from(res.data as Map);
  }

  Future<String> getOrCreateDefaultCalendarId() async {
    final res = await _fns.httpsCallable('getOrCreateDefaultCalendar').call();
    final data = Map<String, dynamic>.from(res.data as Map);
    return data['calendarId'] as String;
  }
}
