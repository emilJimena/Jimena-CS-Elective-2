import 'package:flutter/material.dart';

// Stateful because records change when the user creates, edits, or deletes one.
class CrudContent extends StatefulWidget {
  const CrudContent({super.key, required this.section});
  final String section;
  @override
  State<CrudContent> createState() => _CrudContentState();
}

class _CrudContentState extends State<CrudContent> {
  late List<String> records;

  @override
  void initState() {
    super.initState();
    // Sections start empty; records are created through the CRUD Add action.
    records = [];
  }

  // UPDATE: change the selected record and rebuild the list.
  void updateRecord(int index) => setState(() => records[index] = '${records[index]}  •  Edited');

  // DELETE: remove the selected record from local state.
  void deleteRecord(int index) => setState(() => records.removeAt(index));

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.section, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Manage your ${widget.section.toLowerCase()} with create, read, update, and delete actions.', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 20),
                Card(child: Column(children: records.asMap().entries.map((entry) => ListTile(title: Text(entry.value), leading: CircleAvatar(child: Text('${entry.key + 1}')), trailing: Wrap(spacing: 2, children: [IconButton(tooltip: 'Edit', onPressed: () => updateRecord(entry.key), icon: const Icon(Icons.edit_outlined)), IconButton(tooltip: 'Delete', onPressed: () => deleteRecord(entry.key), icon: const Icon(Icons.delete_outline))]))).toList())),
              ]),
            ),
          ),
        ),
      );
}
