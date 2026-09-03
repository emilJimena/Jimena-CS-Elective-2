import 'package:flutter/material.dart';

import '../widgets/crud_content.dart';
import '../widgets/discover_content.dart';
import '../widgets/sidebar.dart';

// Owns the selected navigation section and chooses the matching content view.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.onThemeToggle});
  final VoidCallback onThemeToggle;
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selected = 'Home';
  final nav = const ['Home', 'Orders', 'Products', 'Discounts'];
  final icons = const [Icons.home_outlined, Icons.receipt_long_outlined, Icons.sell_outlined, Icons.local_offer_outlined];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Row(children: [
            const Text('shopify', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w900, fontSize: 16)),
          ]),
          actions: [
            IconButton(tooltip: 'Toggle theme', onPressed: widget.onThemeToggle, icon: Icon(Theme.of(context).brightness == Brightness.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined)),
            const SizedBox(width: 5),
            OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withValues(alpha: .35))), child: const Text('Apparel Retailer', style: TextStyle(fontSize: 11))),
            const SizedBox(width: 12), const CircleAvatar(radius: 14, child: Text('AR', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold))), const SizedBox(width: 13),
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          final compact = constraints.maxWidth < 800;
          final sidebar = Sidebar(items: nav, icons: icons, selected: selected, onSelect: (item) => setState(() => selected = item));
          // Home is the discovery view; the other sections use the reusable CRUD view.
          final content = selected == 'Home' ? const DiscoverContent() : CrudContent(section: selected);
          if (compact) return Column(children: [SizedBox(height: 58, child: sidebar), Expanded(child: content)]);
          return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [SizedBox(width: 124, child: sidebar), Expanded(child: content)]);
        }),
      );
}
