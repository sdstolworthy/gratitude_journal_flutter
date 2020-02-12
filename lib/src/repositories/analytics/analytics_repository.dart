import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:meta/meta.dart';

class AnalyticsRepository {
  AnalyticsRepository({FirebaseAnalytics firebaseAnalytics})
      : _firebaseAnalytics = firebaseAnalytics ?? FirebaseAnalytics();

  final FirebaseAnalytics _firebaseAnalytics;

  void logEvent({@required String name, Map<String, dynamic> parameters}) {
    try {
      _firebaseAnalytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      print('Error logging analytics event');
      print(e);
    }
  }
}
