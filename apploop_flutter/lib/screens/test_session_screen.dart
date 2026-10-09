import 'dart:io';

import 'package:apploop_client/apploop_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../api/app_loop_api.dart';

/// F6: test one build — attach a screen recording and/or an audio note.
///
/// Screen recordings are picked from Files (save the iOS screen recording
/// there first, with the microphone on). Audio notes record in-app.
class TestSessionScreen extends StatefulWidget {
  final AppLoopApi api;
  final int buildId;

  const TestSessionScreen({
    super.key,
    required this.api,
    required this.buildId,
  });

  @override
  State<TestSessionScreen> createState() => _TestSessionScreenState();
}

class _TestSessionScreenState extends State<TestSessionScreen> {
  List<FeedbackRecording> _recordings = [];
  bool _loading = true;
  bool _busy = false;
  bool _recordingAudio = false;
  String? _error;
  final _recorder = AudioRecorder();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    try {
      final recordings = await widget.api.listRecordings(widget.buildId);
      if (!mounted) return;
      setState(() {
        _recordings = recordings;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load recordings: $e';
      });
    }
  }

  Future<void> _pickVideo() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final files = await FilePicker.pickFiles(type: FileType.video);
      final path = files.isEmpty ? null : files.first.path;
      if (path == null) {
        setState(() => _busy = false);
        return;
      }
      final recording = await widget.api.startRecording(widget.buildId);
      final description = await widget.api.videoUploadDescription(
        recording.id!,
      );
      final file = File(path);
      final ok = await FileUploader(
        description,
      ).upload(file.openRead(), await file.length());
      if (!ok) throw StateError('Upload failed, try again.');
      await widget.api.completeRecording(recording.id!);
      await _refresh();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Video upload failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleAudioNote() async {
    if (_recordingAudio) {
      await _stopAudioNote();
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (!await _recorder.hasPermission()) {
        throw StateError('Microphone permission denied.');
      }
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/note_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );
      setState(() {
        _busy = false;
        _recordingAudio = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = 'Could not start recording: $e';
      });
    }
  }

  Future<void> _stopAudioNote() async {
    setState(() => _busy = true);
    try {
      final path = await _recorder.stop();
      if (path == null) throw StateError('Nothing was recorded.');
      final recording = await widget.api.startRecording(widget.buildId);
      final description = await widget.api.audioUploadDescription(
        recording.id!,
      );
      final file = File(path);
      final ok = await FileUploader(
        description,
      ).upload(file.openRead(), await file.length());
      if (!ok) throw StateError('Upload failed, try again.');
      await widget.api.completeRecording(recording.id!);
      await _refresh();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Audio upload failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _recordingAudio = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Test session')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Record your screen with the microphone ON (iOS Control '
            'Center → Screen Recording), save it to Files, then pick it '
            'below — or record a quick audio note instead.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _busy ? null : _pickVideo,
                  icon: const Icon(Icons.video_library),
                  label: const Text('Pick screen recording'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: _busy ? null : _toggleAudioNote,
                  icon: Icon(_recordingAudio ? Icons.stop : Icons.mic),
                  label: Text(
                    _recordingAudio ? 'Stop & upload' : 'Audio note',
                  ),
                ),
              ),
            ],
          ),
          if (_busy) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(),
          ],
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ],
          const SizedBox(height: 16),
          Text('Recordings', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_recordings.isEmpty)
            const Text('No recordings yet for this build.')
          else
            for (final recording in _recordings)
              Card(
                child: ListTile(
                  leading: Icon(
                    recording.videoPath.isNotEmpty ? Icons.videocam : Icons.mic,
                  ),
                  title: Text('Recording ${recording.id}'),
                  subtitle: Text('Status: ${recording.status}'),
                ),
              ),
        ],
      ),
    );
  }
}
