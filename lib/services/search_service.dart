import '../models/email_model.dart';

class SearchService {
  static List<Email> filterEmails(List<Email> emails, String query) {
    if (query.isEmpty) {
      return emails;
    }
    
    final lowerQuery = query.toLowerCase();
    
    return emails.where((email) {
      final matchSender = email.senderName.toLowerCase().contains(lowerQuery);
      final matchSubject = email.subject.toLowerCase().contains(lowerQuery);
      return matchSender || matchSubject;
    }).toList();
  }
}
