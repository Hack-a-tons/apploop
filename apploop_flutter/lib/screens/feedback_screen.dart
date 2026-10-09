import 'package:apploop_client/apploop_client.dart';
import 'package:flutter/material.dart';

import '../api/app_loop_api.dart';
import 'recording_detail_screen.dart';

/// F7: all feedback recordings across builds, newest first.
class FeedbackScreen extends StatefulWidget {
  final AppLoopApi api;

  const FeedbackScreen({super.key, required this.api});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late Future<List<FeedbackRecording>> _recordingsFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _recordingsFuture = widget.api.listMyRecordings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: FutureBuilder<List<FeedbackRecording>>(
        future: _recordingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Could not load feedback:\n${snapshot.error}'),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => setState(_refresh),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final recordings = snapshot.data ?? const <FeedbackRecording>[];
          if (recordings.isEmpty) {
            return const Center(
              child: Text(
                'No feedback yet.\nTest a build to record some!',
                textAlign: TextAlign.center,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => setState(_refresh),
            child: ListView.builder(
              itemCount: recordings.length,
              itemBuilder: (context, index) {
                final recording = recordings[index];
                return ListTile(
                  leading: Icon(
                    recording.videoPath.isNotEmpty ? Icons.videocam : Icons.mic,
                  ),
                  title: Text('Recording ${recording.id}'),
                  subtitle: Text('Status: ${recording.status}'),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RecordingDetailScreen(
                          api: widget.api,
                          recordingId: recording.id!,
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
