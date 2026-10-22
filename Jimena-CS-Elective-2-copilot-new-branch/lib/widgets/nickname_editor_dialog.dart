import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';

class NicknameEditorDialog extends ConsumerStatefulWidget {
  const NicknameEditorDialog({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  ConsumerState<NicknameEditorDialog> createState() =>
      _NicknameEditorDialogState();
}

class _NicknameEditorDialogState extends ConsumerState<NicknameEditorDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(pokedexStateProvider).nicknames[widget.pokemon.id] ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text('Nickname ${_capitalize(widget.pokemon.name)}'),
    content: TextField(
      controller: _controller,
      autofocus: true,
      maxLength: 24,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        labelText: 'Custom nickname',
        hintText: 'Enter a nickname',
      ),
      onSubmitted: (_) => _save(),
    ),
    actions: [
      TextButton(
        onPressed: () {
          ref
              .read(pokedexStateProvider.notifier)
              .setNickname(widget.pokemon, null);
          Navigator.pop(context);
        },
        child: const Text('Remove nickname'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(onPressed: _save, child: const Text('Save')),
    ],
  );

  void _save() {
    ref
        .read(pokedexStateProvider.notifier)
        .setNickname(widget.pokemon, _controller.text);
    Navigator.pop(context);
  }
}

String _capitalize(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
