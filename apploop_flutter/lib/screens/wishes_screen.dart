import 'package:apploop_client/apploop_client.dart';
import 'package:flutter/material.dart';

import '../api/app_loop_api.dart';
import 'speak_wish_sheet.dart';
import 'wish_detail_screen.dart';

/// F0: wishes list. Voice input arrives in F1 — here wishes are typed.
class WishesScreen extends StatefulWidget {
  final AppLoopApi api;

  const WishesScreen({super.key, required this.api});

  @override
  State<WishesScreen> createState() => _WishesScreenState();
}

class _WishesScreenState extends State<WishesScreen> {
  late Future<List<AppWish>> _wishesFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _wishesFuture = widget.api.listMyWishes();
  }

  Future<void> _addWish() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SpeakWishSheet(api: widget.api),
    );
    if (saved == true && mounted) setState(_refresh);
  }

  Future<void> _deleteWish(AppWish wish) async {
    try {
      await widget.api.deleteWish(wish.id!);
      setState(_refresh);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete wish: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My wishes')),
      body: FutureBuilder<List<AppWish>>(
        future: _wishesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Could not load wishes:\n${snapshot.error}'),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => setState(_refresh),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final wishes = snapshot.data ?? const <AppWish>[];
          if (wishes.isEmpty) {
            return const Center(
              child: Text(
                'No wishes yet.\nTell the phone what app you want!',
                textAlign: TextAlign.center,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => setState(_refresh),
            child: ListView.builder(
              itemCount: wishes.length,
              itemBuilder: (context, index) {
                final wish = wishes[index];
                return Dismissible(
                  key: ValueKey(wish.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete),
                  ),
                  confirmDismiss: (_) async =>
                      await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete wish?'),
                          content: Text('Delete "${wish.title}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ) ??
                      false,
                  onDismissed: (_) => _deleteWish(wish),
                  child: ListTile(
                    title: Text(wish.title),
                    subtitle: Text(
                      wish.descriptionText.isEmpty
                          ? 'Status: ${wish.status}'
                          : '${wish.descriptionText}\nStatus: ${wish.status}',
                    ),
                    isThreeLine: wish.descriptionText.isNotEmpty,
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WishDetailScreen(
                            api: widget.api,
                            wish: wish,
                          ),
                        ),
                      );
                      if (mounted) setState(_refresh);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addWish,
        tooltip: 'Speak a new wish',
        child: const Icon(Icons.mic),
      ),
    );
  }
}
