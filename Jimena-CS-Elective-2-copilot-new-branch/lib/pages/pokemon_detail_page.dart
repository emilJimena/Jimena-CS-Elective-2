import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../models/pokemon_details.dart';
import '../services/pokemon_service.dart';

class PokemonDetailPage extends StatefulWidget {
  const PokemonDetailPage({
    super.key,
    required this.pokemon,
    this.loadDetails = PokemonService.fetchDetails,
  });

  final Pokemon pokemon;
  final Future<PokemonDetails> Function(int id) loadDetails;

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late Future<PokemonDetails> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = widget.loadDetails(widget.pokemon.id);
  }

  void _retry() {
    setState(() => _detailsFuture = widget.loadDetails(widget.pokemon.id));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: const Color(0xFFDC3545),
      foregroundColor: Colors.white,
      title: Text(_titleCase(widget.pokemon.name)),
    ),
    body: FutureBuilder<PokemonDetails>(
      future: _detailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError) {
          return _DetailMessage(
            title: 'Could not load details',
            message: 'Check your connection and try again.',
            onRetry: _retry,
          );
        }

        final details = snapshot.data;
        if (details == null) {
          return const _DetailMessage(
            title: 'No details available',
            message: 'There is no extra information for this Pokémon.',
          );
        }

        return _PokemonTradingCard(pokemon: widget.pokemon, details: details);
      },
    ),
  );
}

class _PokemonTradingCard extends StatelessWidget {
  const _PokemonTradingCard({required this.pokemon, required this.details});

  final Pokemon pokemon;
  final PokemonDetails details;

  static const _gold = Color(0xFFB78625);
  static const _paper = Color(0xFFFFF5D6);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(18),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Container(
          decoration: BoxDecoration(
            color: _paper,
            border: Border.all(color: _gold, width: 4),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'POKÉMON',
                    style: TextStyle(
                      color: Color(0xFF775721),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '#${pokemon.id.toString().padLeft(3, '0')}',
                    style: const TextStyle(
                      color: Color(0xFF775721),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                _titleCase(pokemon.name),
                style: const TextStyle(
                  color: Color(0xFF29231B),
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: details.types
                    .map((type) => _TypeTag(type: type))
                    .toList(),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 260,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFEAD48D), Color(0xFFD4E3C1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Image.network(
                    pokemon.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.catching_pokemon,
                      size: 90,
                      color: _gold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _Measurement(
                      label: 'HEIGHT',
                      value: '${(details.height / 10).toStringAsFixed(1)} m',
                    ),
                  ),
                  Expanded(
                    child: _Measurement(
                      label: 'WEIGHT',
                      value: '${(details.weight / 10).toStringAsFixed(1)} kg',
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, color: _gold),
              const Text(
                'POKÉDEX DESCRIPTION',
                style: TextStyle(
                  color: Color(0xFF775721),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                details.description,
                style: const TextStyle(color: Color(0xFF29231B), height: 1.35),
              ),
              const SizedBox(height: 16),
              const Text(
                'ABILITIES',
                style: TextStyle(
                  color: Color(0xFF775721),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: details.abilities
                    .map((ability) => Chip(label: Text(_titleCase(ability))))
                    .toList(),
              ),
              const SizedBox(height: 12),
              const Text(
                'BASE STATS',
                style: TextStyle(
                  color: Color(0xFF775721),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 5),
              ...details.stats.map((stat) => _StatRow(stat: stat)),
            ],
          ),
        ),
      ),
    ),
  );
}

class _TypeTag extends StatelessWidget {
  const _TypeTag({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) => Chip(
    visualDensity: VisualDensity.compact,
    backgroundColor: const Color(0xFFDC3545),
    label: Text(
      _titleCase(type),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
    ),
  );
}

class _Measurement extends StatelessWidget {
  const _Measurement({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 11, color: Color(0xFF775721)),
      ),
      const SizedBox(height: 2),
      Text(
        value,
        style: const TextStyle(
          color: Color(0xFF29231B),
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.stat});

  final PokemonStat stat;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        SizedBox(
          width: 108,
          child: Text(
            _titleCase(stat.name),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        SizedBox(
          width: 30,
          child: Text(
            '${stat.value}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: (stat.value / 255).clamp(0, 1),
            minHeight: 7,
            backgroundColor: const Color(0xFFE5D7B1),
            color: const Color(0xFFDC3545),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    ),
  );
}

class _DetailMessage extends StatelessWidget {
  const _DetailMessage({
    required this.title,
    required this.message,
    this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 14),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ],
      ),
    ),
  );
}

String _titleCase(String value) => value
    .split('-')
    .map(
      (part) =>
          part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}',
    )
    .join(' ');
