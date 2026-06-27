import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/email_model.dart';
import '../services/firebase_service.dart';
import 'package:provider/provider.dart';

class EmailDetailScreen extends StatelessWidget {
  final Email email;

  const EmailDetailScreen({Key? key, required this.email}) : super(key: key);

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onBackground,
        elevation: 0,
        title: const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Hero(
        tag: 'email_card_${email.id}',
        child: Material(
          type: MaterialType.transparency,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject and Star
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        email.subject,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.star_border),
                      color: Colors.grey.shade600,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Sender Info Card
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark 
                        ? Colors.grey.shade900 
                        : Colors.white,
                    border: Border.all(
                      color: theme.brightness == Brightness.dark 
                          ? Colors.grey.shade800 
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: avatarColor,
                            foregroundColor: Colors.white,
                            radius: 20,
                            child: Text(
                              initial,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                    Text(
                                      DateFormat('h:mm a').format(email.timestamp),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        email.senderEmail,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MMM d, yyyy').format(email.timestamp),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'To',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'You (sabarivasan.22it@kongu.edu)',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Email Body
                Text(
                  email.body,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: theme.colorScheme.onBackground.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 48),
                const Divider(),
                const SizedBox(height: 24),
                // Action Buttons
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildActionButton(context, Icons.reply, 'Reply', theme.colorScheme.primary),
                    _buildActionButton(context, Icons.forward, 'Forward', theme.colorScheme.primary),
                    _buildActionButton(context, Icons.share, 'Share', theme.colorScheme.primary),
                    _buildActionButton(context, Icons.star_border, 'Star', Colors.grey.shade700),
                    _buildActionButton(context, Icons.delete_outline, 'Delete', Colors.red, onPressed: () {
                      Provider.of<FirebaseService>(context, listen: false).deleteEmail(email.id);
                      Navigator.pop(context);
                    }),
                    _buildActionButton(context, Icons.report_problem_outlined, 'Report', Colors.orange),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, {VoidCallback? onPressed}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return OutlinedButton.icon(
      onPressed: onPressed ?? () {},
      icon: Icon(icon, color: color, size: 20),
      label: Text(label, style: TextStyle(color: color)),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        side: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
