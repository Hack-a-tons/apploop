import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../api/app_loop_api.dart';

/// F1: speak a wish. The mic fills the fields live; the user can always
/// edit by keyboard before saving. Falls back to pure typing when speech
/// recognition is unavailable (web, denied permission, no mic).
class SpeakWishSheet extends StatefulWidget {
  final AppLoopApi api;

  const SpeakWishSheet({super.key, required this.api});

  @override
  State<SpeakWishSheet> createState() => _SpeakWishSheetState();
}

class _SpeakWishSheetState extends State<SpeakWishSheet> {
  final _speech = SpeechToText();
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();

  bool _initializing = true;
  bool _available = false;
  bool _listening = false;
  bool _touched = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_markTouched);
    _detailsController.addListener(_markTouched);
    _initSpeech();
  }

  void _markTouched() {
    _touched = true;
  }

  Future<void> _initSpeech() async {
    try {
      _available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (mounted) setState(() => _listening = false);
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _listening = false;
              _error = 'Could not listen: ${error.errorMsg}';
            });
          }
        },
      );
    } catch (e) {
      _available = false;
      _error = 'Speech recognition is not available here — type instead.';
    }
    if (mounted) setState(() => _initializing = false);
    if (_available) _toggleListening();
  }

  Future<void> _toggleListening() async {
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }
    setState(() {
      _error = '';
      _listening = true;
    });
    await _speech.listen(
      onResult: (result) {
        if (_touched) return;
        final words = result.recognizedWords.trim();
        if (words.isEmpty) return;
        // First sentence becomes the title, the rest the details.
        final match = RegExp(r'^(.+?[.!?])\s+(.+)$').firstMatch(words);
        if (match != null) {
          _titleController.text = match.group(1)!;
          _detailsController.text = match.group(2)!;
        } else if (words.length > 60) {
          final cut = words.lastIndexOf(' ', 60);
          _titleController.text = words.substring(0, cut < 0 ? 60 : cut);
          _detailsController.text = words.substring(cut < 0 ? 60 : cut + 1);
        } else {
          _titleController.text = words;
        }
      },
      listenOptions: SpeechListenOptions(
        listenFor: const Duration(minutes: 2),
        pauseFor: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Say or type what app you want first.')),
      );
      return;
    }
    await _speech.stop();
    try {
      await widget.api.createWish(title, _detailsController.text.trim());
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save wish: $e')),
      );
    }
  }

  @override
  void dispose() {
    _speech.cancel();
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
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
          Row(
            children: [
              Text(
                'Speak your wish',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              if (_initializing)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                IconButton.filled(
                  icon: Icon(_listening ? Icons.mic : Icons.mic_none),
                  tooltip: _listening ? 'Stop listening' : 'Start listening',
                  onPressed: _available ? _toggleListening : null,
                ),
            ],
          ),
          if (_listening)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text('Listening… speak now.'),
            ),
          if (_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _error,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'What app do you want?',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _detailsController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Details',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check),
            label: const Text('Save wish'),
          ),
        ],
      ),
    );
  }
}
