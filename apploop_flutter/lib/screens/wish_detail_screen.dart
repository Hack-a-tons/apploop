import 'dart:async';

import 'package:apploop_client/apploop_client.dart';
import 'package:flutter/material.dart';

import '../api/app_loop_api.dart';
import 'build_detail_screen.dart';

/// F2: wish detail with TestFlight provisioning status.
/// F4: request a TestFlight build once the app is provisioned.

/// F2: wish detail with TestFlight provisioning status.
/// Polls while the store app is being provisioned.
class WishDetailScreen extends StatefulWidget {
  final AppLoopApi api;
  final AppWish wish;

  const WishDetailScreen({super.key, required this.api, required this.wish});

  @override
  State<WishDetailScreen> createState() => _WishDetailScreenState();
}

class _WishDetailScreenState extends State<WishDetailScreen> {
  StoreApp? _storeApp;
  bool _loading = true;
  bool _working = false;
  String? _error;
  Timer? _pollTimer;

  static const _activeStatuses = {'pending', 'creating'};

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    try {
      final app = await widget.api.getStoreAppForWish(widget.wish.id!);
      if (!mounted) return;
      setState(() {
        _storeApp = app;
        _loading = false;
        _error = null;
      });
      _updatePolling();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load store app: $e';
      });
    }
  }

  void _updatePolling() {
    final active =
        _storeApp != null && _activeStatuses.contains(_storeApp!.status);
    if (active && _pollTimer == null) {
      _pollTimer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => _refresh(),
      );
    } else if (!active) {
      _pollTimer?.cancel();
      _pollTimer = null;
    }
  }

  Future<void> _provision() async {
    setState(() {
      _working = true;
      _error = null;
    });
    try {
      final app = await widget.api.requestApp(widget.wish.id!);
      if (!mounted) return;
      setState(() {
        _storeApp = app;
        _working = false;
      });
      _updatePolling();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _working = false;
        _error = 'Provisioning failed: $e';
      });
    }
  }

  Future<void> _requestBuild() async {
    setState(() {
      _working = true;
      _error = null;
    });
    try {
      final build = await widget.api.requestBuild(widget.wish.id!);
      if (!mounted) return;
      setState(() => _working = false);
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BuildDetailScreen(
            api: widget.api,
            buildId: build.id!,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _working = false;
        _error = 'Build request failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.wish.title)),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              widget.wish.descriptionText.isEmpty
                  ? 'No details.'
                  : widget.wish.descriptionText,
            ),
            const SizedBox(height: 8),
            Text('Wish status: ${widget.wish.status}'),
            const Divider(height: 32),
            Text(
              'TestFlight app',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_storeApp == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'No TestFlight app yet. Provisioning creates a real '
                    'app record in App Store Connect for this wish.',
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _working ? null : _provision,
                    icon: _working
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.cloud_upload),
                    label: const Text('Provision TestFlight app'),
                  ),
                ],
              )
            else ...[
              _StatusRow(storeApp: _storeApp!),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  _storeApp!.statusLog.isEmpty
                      ? 'No log yet.'
                      : _storeApp!.statusLog,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
              if (_storeApp!.status == 'failed') ...[
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _working ? null : _provision,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry provisioning'),
                ),
              ],
              if (_storeApp!.status == 'ready') ...[
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _working ? null : _requestBuild,
                  icon: const Icon(Icons.build),
                  label: const Text('Request TestFlight build'),
                ),
                const SizedBox(height: 12),
                _TestflightLinkEditor(
                  api: widget.api,
                  storeApp: _storeApp!,
                ),
              ],
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final StoreApp storeApp;

  const _StatusRow({required this.storeApp});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Chip(
          avatar: const Icon(Icons.smartphone, size: 16),
          label: Text(storeApp.bundleId),
        ),
        Chip(
          avatar: Icon(
            switch (storeApp.status) {
              'ready' => Icons.check_circle,
              'failed' => Icons.error,
              _ => Icons.hourglass_empty,
            },
            size: 16,
          ),
          label: Text('Status: ${storeApp.status}'),
        ),
        if (storeApp.ascAppId.isNotEmpty)
          Chip(
            avatar: const Icon(Icons.tag, size: 16),
            label: Text('ASC ${storeApp.ascAppId}'),
          ),
      ],
    );
  }
}

/// Edits the public TestFlight invite link of a provisioned store app.
class _TestflightLinkEditor extends StatefulWidget {
  final AppLoopApi api;
  final StoreApp storeApp;

  const _TestflightLinkEditor({required this.api, required this.storeApp});

  @override
  State<_TestflightLinkEditor> createState() => _TestflightLinkEditorState();
}

class _TestflightLinkEditorState extends State<_TestflightLinkEditor> {
  late final TextEditingController _controller;
  bool _saving = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.storeApp.testflightLink);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _message = null;
    });
    try {
      final updated = await widget.api.setTestflightLink(
        widget.storeApp.id!,
        _controller.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _saving = false;
        _message = updated.testflightLink.isEmpty
            ? 'Link cleared.'
            : 'Link saved.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _message = 'Could not save link: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
            labelText: 'TestFlight invite link',
            hintText: 'https://testflight.apple.com/join/…',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _saving ? null : _save,
          icon: const Icon(Icons.link),
          label: const Text('Save invite link'),
        ),
        if (_message != null) ...[
          const SizedBox(height: 4),
          Text(_message!),
        ],
      ],
    );
  }
}
