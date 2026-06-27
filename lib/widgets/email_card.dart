import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/email_model.dart';

class EmailCard extends StatelessWidget {
  final Email email;
  final VoidCallback onTap;

  const EmailCard({
    Key? key,
    required this.email,
    required this.onTap,
  }) : super(key: key);

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.cyan,
      Colors.indigo.shade400,
      Colors.green,
      Colors.orange,
      Colors.redAccent,
      Colors.amber.shade700,
      Colors.blue,
    ];
    int hash = name.codeUnits.fold(0, (prev, curr) => prev + curr);
    return colors[hash % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String initial = email.senderName.isNotEmpty ? email.senderName[0].toUpperCase() : '?';
    final avatarColor = _getAvatarColor(email.senderName);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor: avatarColor,
                foregroundColor: Colors.white,
                radius: 22,
                child: Text(
                  initial,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Sender and Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            email.senderName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTimestamp(email.timestamp),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Row 2: Subject and Unread Dot
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            email.subject,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!email.isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Row 3: Body Preview
                    Text(
                      email.body,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    if (timestamp.year == now.year && timestamp.month == now.month && timestamp.day == now.day) {
      return DateFormat('h:mm a').format(timestamp); // e.g. 2:35 PM
    } else if (timestamp.year == now.year && timestamp.month == now.month && timestamp.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d, yyyy').format(timestamp); // e.g. Jun 27, 2025
    }
  }
}
