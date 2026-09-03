import 'package:flutter/material.dart';

// Stateless because it displays navigation data supplied by DashboardPage.
class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
    required this.items,
    required this.icons,
    required this.selected,
    required this.onSelect,
  });

  final List<String> items;
  final List<IconData> icons;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final horizontal = constraints.maxHeight < 200;
          return Container(
            color: Theme.of(context).cardTheme.color,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              scrollDirection: horizontal ? Axis.horizontal : Axis.vertical,
              children: [
                ...List.generate(
                  items.length,
                  (index) => SidebarItem(
                    label: items[index],
                    icon: icons[index],
                    selected: selected == items[index],
                    onTap: () => onSelect(items[index]),
                  ),
                ),
                if (!horizontal) ...[
                  const SizedBox(height: 8),
                  const SidebarItem(label: 'Sales channels', icon: Icons.chevron_right),
                  const SidebarItem(label: 'Online Store', icon: Icons.storefront_outlined),
                  const SidebarItem(label: 'Point of Sale', icon: Icons.point_of_sale_outlined),
                  const SidebarItem(label: 'Shop', icon: Icons.shopping_bag_outlined),
                ],
              ],
            ),
          );
        },
      );
}

class SidebarItem extends StatelessWidget {
  const SidebarItem({
    super.key,
    required this.label,
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: 108,
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.surfaceContainerHighest
                : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 7),
              Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12))),
            ],
          ),
        ),
      );
}
