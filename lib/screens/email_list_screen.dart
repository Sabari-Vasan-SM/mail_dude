import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/email_model.dart';
import '../services/firebase_service.dart';
import '../services/search_service.dart';
import '../widgets/email_card.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_skeleton.dart';
import 'email_detail_screen.dart';
import 'settings_screen.dart';

class EmailListScreen extends StatefulWidget {
  const EmailListScreen({Key? key}) : super(key: key);

  @override
  State<EmailListScreen> createState() => _EmailListScreenState();
}

class _EmailListScreenState extends State<EmailListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late final FirebaseService _firebaseService;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _firebaseService = Provider.of<FirebaseService>(context, listen: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {}, // Handle drawer or menu
        ),
        title: const Text('mailDUDE', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Focus search bar if needed
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CustomSearchBar(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onClear: () => _onSearchChanged(''),
          ),
          Expanded(
            child: StreamBuilder<List<Email>>(
              stream: _firebaseService.getEmailsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingSkeleton();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                        const SizedBox(height: 16),
                        Text('Failed to load emails', style: theme.textTheme.titleLarge),
                        Text(snapshot.error.toString(), style: theme.textTheme.bodySmall),
                      ],
                    ),
                  );
                }

                final emails = snapshot.data ?? [];
                final filteredEmails = SearchService.filterEmails(emails, _searchQuery);

                if (filteredEmails.isEmpty && _searchQuery.isEmpty) {
                  return EmptyState(onRefresh: _handleRefresh);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.mail_outline, size: 20, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'EMAILS (${filteredEmails.length})',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _handleRefresh,
                        child: ListView.builder(
                          itemCount: filteredEmails.length,
                          itemBuilder: (context, index) {
                            final email = filteredEmails[index];
                            return TweenAnimationBuilder<double>(
                              key: ValueKey(email.id),
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(0, 50 * (1 - value)),
                                  child: Opacity(
                                    opacity: value,
                                    child: child,
                                  ),
                                );
                              },
                              child: Hero(
                                tag: 'email_card_${email.id}',
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: EmailCard(
                                    email: email,
                                    onTap: () {
                                      _firebaseService.markAsRead(email.id);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EmailDetailScreen(email: email),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Emails',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            activeIcon: Icon(Icons.star),
            label: 'Starred',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            activeIcon: Icon(Icons.local_offer),
            label: 'Labels',
          ),
        ],
      ),
    );
  }
}
