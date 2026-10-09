import 'dart:async';

import 'package:apploop_client/apploop_client.dart';
import 'package:flutter/material.dart';

import '../client.dart';

/// F4: one build with live status and scrolling log.
class BuildDetailScreen extends StatefulWidget {
  final int buildId;

  const BuildDetailScreen({super.key, required this.buildId});

  @override
  State<BuildDetailScreen> createState() => _BuildDetailScreenState();
}

class _BuildDetailScreenState extends State<BuildDetailScreen> {
  AppBuild? _build;
  bool _loading = true;
  bool _working = false;
  String? _error;
  Timer? _pollTimer;

  static const _activeStatuses = {
    'queued',
    'claimed',
    'generating',
    'building',
    'uploading',
    'processing',
  };

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
      final build = await client.build.getBuild(widget.buildId);
      if (!mounted) return;
      setState(() {
        _build = build;
        _loading = false;
        _error = null;
      });
      _updatePolling();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load build: $e';
      });
    }
  }

  void _updatePolling() {
    final active =
        _build != null && _activeStatuses.contains(_build!.status);
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

  Future<void> _retry() async {
    setState(() {
      _working = true;
      _error = null;
    });
    try {
      final build = await client.build.retryBuild(widget.buildId);
      if (!mounted) return;
      setState(() {
        _build = build;
        _working = false;
      });
      _updatePolling();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _working = false;
        _error = 'Retry failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Build')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_build != null) ...[
                    Text(
                      'Iteration ${_build!.iteration} · '
                      'build ${_build!.buildNumber} · v${_build!.version}',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Status: ${_build!.status}'),
                    if (_build!.testflightState.isNotEmpty)
                      Text('TestFlight: ${_build!.testflightState}'),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 120),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        _build!.statusLog.isEmpty
                            ? 'No log yet.'
                            : _build!.statusLog,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (_build!.status == 'failed') ...[
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _working ? null : _retry,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry build'),
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
