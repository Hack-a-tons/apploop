import 'dart:async';

import 'package:apploop_client/apploop_client.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/app_loop_api.dart';

/// F4: one build with live status and scrolling log.
class BuildDetailScreen extends StatefulWidget {
  final AppLoopApi api;
  final int buildId;

  const BuildDetailScreen({
    super.key,
    required this.api,
    required this.buildId,
  });

  @override
  State<BuildDetailScreen> createState() => _BuildDetailScreenState();
}

class _BuildDetailScreenState extends State<BuildDetailScreen> {
  AppBuild? _build;
  TestflightInfo? _info;
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
      final build = await widget.api.getBuild(widget.buildId);
      final info = await widget.api.testflightInfo(widget.buildId);
      if (!mounted) return;
      setState(() {
        _build = build;
        _info = info;
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
    final active = _build != null && _activeStatuses.contains(_build!.status);
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
      final build = await widget.api.retryBuild(widget.buildId);
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

  Future<void> _install() async {
    final url = _info?.installUrl ?? '';
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open TestFlight.')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open TestFlight.')),
      );
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
                    if (_info != null && _info!.testflightState.isNotEmpty)
                      Chip(
                        avatar: const Icon(Icons.flight_takeoff, size: 16),
                        label: Text('TestFlight: ${_info!.testflightState}'),
                      ),
                    if (_info != null && _info!.installUrl.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _install,
                        icon: const Icon(Icons.download),
                        label: const Text('Install in TestFlight'),
                      ),
                    ] else if (_build!.status == 'ready') ...[
                      const SizedBox(height: 12),
                      const Text(
                        'No TestFlight invite link yet — set it on the '
                        'store app to install this build.',
                      ),
                    ],
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
