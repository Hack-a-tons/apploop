import 'package:apploop_client/apploop_client.dart';
import 'package:flutter/material.dart';

import '../api/app_loop_api.dart';
import 'comment_edit_sheet.dart';

/// F7: review one recording — transcript, progress, editable comments.
class RecordingDetailScreen extends StatefulWidget {
  final AppLoopApi api;
  final int recordingId;

  const RecordingDetailScreen({
    super.key,
    required this.api,
    required this.recordingId,
  });

  @override
  State<RecordingDetailScreen> createState() => _RecordingDetailScreenState();
}

class _RecordingDetailScreenState extends State<RecordingDetailScreen> {
  List<FeedbackComment> _comments = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    try {
      final comments = await widget.api.listComments(widget.recordingId);
      if (!mounted) return;
      setState(() {
        _comments = comments;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load comments: $e';
      });
    }
  }

  Future<void> _toggleResolved(FeedbackComment comment) async {
    try {
      final updated = await widget.api.setResolved(
        comment.id!,
        !comment.resolved,
      );
      if (!mounted) return;
      setState(() {
        _comments = _comments
            .map((c) => c.id == updated.id ? updated : c)
            .toList();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update: $e')),
      );
    }
  }

  Future<void> _edit(FeedbackComment? comment) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => CommentEditSheet(
        api: widget.api,
        recordingId: widget.recordingId,
        comment: comment,
      ),
    );
    if (saved == true && mounted) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final resolved = _comments.where((c) => c.resolved).length;
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_error != null)
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  Text(
                    '$resolved of ${_comments.length} resolved',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (_comments.isEmpty && _error == null)
                    const Text(
                      'No issues yet. When automatic processing finishes, '
                      'extracted issues appear here — or add one manually.',
                    ),
                  for (final comment in _comments)
                    _CommentCard(
                      comment: comment,
                      api: widget.api,
                      onToggle: () => _toggleResolved(comment),
                      onEdit: () => _edit(comment),
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(null),
        tooltip: 'Add comment',
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final FeedbackComment comment;
  final AppLoopApi api;
  final Future<void> Function() onToggle;
  final Future<void> Function() onEdit;

  const _CommentCard({
    required this.comment,
    required this.api,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final shotName = comment.screenshotPath.split('/').last;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _SeverityChip(severity: comment.severity),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    comment.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (comment.resolved)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
            if (comment.timestamps.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                comment.timestamps,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ],
            if (comment.text.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(comment.text),
            ],
            if (shotName.isNotEmpty) ...[
              const SizedBox(height: 8),
              _ShotThumb(api: api, comment: comment, shotName: shotName),
            ],
            const SizedBox(height: 4),
            Row(
              children: [
                TextButton.icon(
                  onPressed: onToggle,
                  icon: Icon(
                    comment.resolved ? Icons.undo : Icons.check,
                  ),
                  label: Text(
                    comment.resolved ? 'Reopen' : 'Resolve',
                  ),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SeverityChip extends StatelessWidget {
  final String severity;

  const _SeverityChip({required this.severity});

  @override
  Widget build(BuildContext context) {
    final color = switch (severity) {
      'high' => Colors.red,
      'low' => Colors.green,
      _ => Colors.orange,
    };
    return Chip(
      label: Text(severity),
      backgroundColor: color.withValues(alpha: 0.2),
    );
  }
}

class _ShotThumb extends StatelessWidget {
  final AppLoopApi api;
  final FeedbackComment comment;
  final String shotName;

  const _ShotThumb({
    required this.api,
    required this.comment,
    required this.shotName,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: api.screenshotUrl(comment.recordingId, shotName),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            snapshot.data!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, _, _) =>
                const Text('Screenshot unavailable.'),
          ),
        );
      },
    );
  }
}
