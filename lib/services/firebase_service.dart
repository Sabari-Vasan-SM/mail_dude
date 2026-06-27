import 'package:firebase_database/firebase_database.dart';
import '../models/email_model.dart';

class FirebaseService {
  final FirebaseDatabase _db = FirebaseDatabase.instanceFor(
      app: FirebaseDatabase.instance.app,
      databaseURL: 'https://maildude-c856b-default-rtdb.asia-southeast1.firebasedatabase.app');

  // Stream of emails, ordered by date (latest first)
  Stream<List<Email>> getEmailsStream() {
    return _db.ref('emails').orderByChild('date').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) {
        return [];
      }

      final List<Email> emails = [];
      data.forEach((key, value) {
        try {
          emails.add(Email.fromJson(key.toString(), value as Map<dynamic, dynamic>));
        } catch (e) {
          print('Error parsing email with key $key: $e');
        }
      });

      // Sort by timestamp descending
      emails.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return emails;
    });
  }

  // Update read status
  Future<void> markAsRead(String emailId) async {
    try {
      await _db.ref('emails/$emailId').update({'isRead': true});
    } catch (e) {
      print('Error marking email as read: $e');
      rethrow;
    }
  }

  // Delete email
  Future<void> deleteEmail(String emailId) async {
    try {
      await _db.ref('emails/$emailId').remove();
    } catch (e) {
      print('Error deleting email: $e');
      rethrow;
    }
  }
}
