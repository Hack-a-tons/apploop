import 'package:apploop_client/apploop_client.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../api/app_loop_api.dart';

const _severities = ['high', 'medium', 'low'];

/// F7: add or edit one comment, by typing or dictating.
class CommentEditSheet extends StatefulWidget {
  final AppLoopApi api;
  final int recordingId;
  final FeedbackComment? comment;

  const CommentEditSheet({
    super.key,
    required this.api,
    required this.recordingId,
    this.comment,
  });

  @override
  State<CommentEditSheet> createState() => _CommentEditSheetState();
}

class _CommentEditSheetState extends State<CommentEditSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _textController;
  late String _severity;
  bool _resolved = false;
  bool _saving = false;
  bool _listening = false;
  String? _error;
  final _speech = SpeechToText();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.comment?.title ?? '',
    );
    _textController = TextEditingController(
      text: widget.comment?.text ?? '',
    );
    _severity = widget.comment?.severity ?? 'medium';
    _resolved = widget.comment?.resolved ?? false;
  }

  @override
  void dispose() {
    _speech.cancel();
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _toggleDictation() async {
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }
    try {
      if (!await _speech.initialize()) {
        throw StateError('Speech recognition unavailable.');
      }
      setState(() => _listening = true);
      await _speech.listen(
        onResult: (result) {
          _textController.text = result.recognizedWords;
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _listening = false;
        _error = 'Dictation failed: $e';
      });
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _error = 'Give the issue a title.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await _speech.stop();
      final text = _textController.text.trim();
      if (widget.comment == null) {
        await widget.api.addManualComment(
          widget.recordingId,
          title,
          text,
          'keyboard',
        );
      } else {
        await widget.api.editComment(
          widget.comment!.id!,
          title,
          text,
          _severity,
        );
        if (_resolved != widget.comment!.resolved) {
          await widget.api.setResolved(widget.comment!.id!, _resolved);
        }
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Could not save: $e';
      });
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete comment?'),
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
    );
    if (confirmed != true || !mounted) return;
    try {
      await widget.api.deleteComment(widget.comment!.id!);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Could not delete: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.comment == null ? 'Add comment' : 'Edit comment',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _textController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Details',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_listening ? Icons.mic : Icons.mic_none),
                tooltip: 'Dictate',
                onPressed: _toggleDictation,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              DropdownButton<String>(
                value: _severity,
                items: [
                  for (final s in _severities)
                    DropdownMenuItem(value: s, child: Text(s)),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _severity = value);
                },
              ),
              const SizedBox(width: 16),
              if (widget.comment != null) ...[
                const Text('Resolved'),
                Switch(
                  value: _resolved,
                  onChanged: (value) => setState(() => _resolved = value),
                ),
              ],
            ],
          ),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (widget.comment != null)
                TextButton.icon(
                  onPressed: _delete,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                ),
              const Spacer(),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.check),
                label: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
