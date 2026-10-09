import 'package:apploop_client/apploop_client.dart';
import 'package:flutter/material.dart';

import '../api/app_loop_api.dart';
import 'build_detail_screen.dart';

/// F4: all builds across the user's wishes, newest first.
class BuildsScreen extends StatefulWidget {
  final AppLoopApi api;

  const BuildsScreen({super.key, required this.api});

  @override
  State<BuildsScreen> createState() => _BuildsScreenState();
}

class _BuildsScreenState extends State<BuildsScreen> {
  late Future<List<AppBuild>> _buildsFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _buildsFuture = widget.api.listMyBuilds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Builds')),
      body: FutureBuilder<List<AppBuild>>(
        future: _buildsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Could not load builds:\n${snapshot.error}'),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => setState(_refresh),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final builds = snapshot.data ?? const <AppBuild>[];
          if (builds.isEmpty) {
            return const Center(
              child: Text(
                'No builds yet.\nOpen a wish and request one!',
                textAlign: TextAlign.center,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => setState(_refresh),
            child: ListView.builder(
              itemCount: builds.length,
              itemBuilder: (context, index) {
                final build = builds[index];
                return ListTile(
                  leading: _StatusIcon(status: build.status),
                  title: Text(
                    'Iteration ${build.iteration} · build ${build.buildNumber}',
                  ),
                  subtitle: Text(
                    'Status: ${build.status}'
                    '${build.testflightState.isNotEmpty ? ' · TF: ${build.testflightState}' : ''}',
                  ),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BuildDetailScreen(
                          api: widget.api,
                          buildId: build.id!,
                        ),
                      ),
                    );
                    if (context.mounted) setState(_refresh);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final String status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return switch (status) {
      'ready' => Icon(Icons.check_circle, color: colors.primary),
      'failed' => Icon(Icons.error, color: colors.error),
      'queued' => const Icon(Icons.hourglass_empty),
      _ => const Icon(Icons.sync),
    };
  }
}
