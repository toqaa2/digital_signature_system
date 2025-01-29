import 'package:flutter/material.dart';

class FormTypeSelector extends StatelessWidget {
  final List<String> dropdownItems;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;

  const FormTypeSelector({
    super.key,
    required this.dropdownItems,
    required this.selectedItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Please Choose The Type of Form *',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          width: 420,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButton<String>(
            underline: SizedBox(),
            value: selectedItem,
            hint: const Text('Select Form Type'),
            style: const TextStyle(fontSize: 12),
            isExpanded: true,
            items: dropdownItems.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
