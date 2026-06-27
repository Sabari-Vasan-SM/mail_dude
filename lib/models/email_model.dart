class Email {
  final String id;
  final String senderName;
  final String senderEmail;
  final String subject;
  final String body;
  final DateTime timestamp;
  final bool isRead;

  Email({
    required this.id,
    required this.senderName,
    required this.senderEmail,
    required this.subject,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  factory Email.fromJson(String id, Map<dynamic, dynamic> json) {
    DateTime parsedDate;
    if (json['date'] != null) {
      try {
        parsedDate = DateTime.parse(json['date']);
      } catch (e) {
        parsedDate = DateTime.now();
      }
    } else {
      parsedDate = DateTime.now();
    }

    return Email(
      id: id,
      senderName: json['from'] ?? 'Unknown Sender',
      senderEmail: json['fromEmail'] ?? '',
      subject: json['subject'] ?? 'No Subject',
      body: json['body'] ?? '',
      timestamp: parsedDate,
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': senderName,
      'fromEmail': senderEmail,
      'subject': subject,
      'body': body,
      'date': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  Email copyWith({
    String? id,
    String? senderName,
    String? senderEmail,
    String? subject,
    String? body,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return Email(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      senderEmail: senderEmail ?? this.senderEmail,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
