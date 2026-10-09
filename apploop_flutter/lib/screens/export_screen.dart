import 'package:apploop_client/apploop_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../api/app_loop_api.dart';

/// F8: export one wish's whole loop as Markdown — preview, copy, share.
class ExportScreen extends StatefulWidget {
  final AppLoopApi api;

  const ExportScreen({super.key, required this.api});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  List<AppWish> _wishes = [];
  AppWish? _selected;
  String? _markdown;
  bool _loading = true;
  bool _working = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWishes();
  }

  Future<void> _loadWishes() async {
    try {
      final wishes = await widget.api.listMyWishes();
      if (!mounted) return;
      setState(() {
        _wishes = wishes;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load wishes: $e';
      });
    }
  }

  Future<void> _export(AppWish wish) async {
    setState(() {
      _selected = wish;
      _working = true;
      _error = null;
    });
    try {
      final markdown = await widget.api.exportWish(wish.id!);
      if (!mounted) return;
      setState(() {
        _markdown = markdown;
        _working = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _working = false;
        _error = 'Export failed: $e';
      });
    }
  }

  Future<void> _copy() async {
    final markdown = _markdown;
    if (markdown == null) return;
    try {
      await Clipboard.setData(ClipboardData(text: markdown));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not access clipboard.')),
      );
    }
  }

  Future<void> _share() async {
    final markdown = _markdown;
    final title = _selected?.title ?? 'wish';
    if (markdown == null) return;
    try {
      await SharePlus.instance.share(
        ShareParams(text: markdown, subject: 'AppLoop export: $title'),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open sharing.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<AppWish>(
                  initialValue: _selected,
                  decoration: const InputDecoration(
                    labelText: 'Wish to export',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final wish in _wishes)
                      DropdownMenuItem(
                        value: wish,
                        child: Text(wish.title),
                      ),
                  ],
                  onChanged: (wish) {
                    if (wish != null) _export(wish);
                  },
                ),
                if (_working) ...[
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                if (_markdown != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: _copy,
                          icon: const Icon(Icons.copy),
                          label: const Text('Copy'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _share,
                          icon: const Icon(Icons.ios_share),
                          label: const Text('Share'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      _markdown!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  'The export package carries your wish from idea to '
                  'TestFlight builds and every test comment — everything a '
                  'developer needs to take it to production. Paid '
                  'publishing tiers come after the hackathon.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
    );
  }
}
