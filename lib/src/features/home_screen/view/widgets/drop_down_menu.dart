import 'package:flutter/material.dart';

class FormTypeSelector extends StatelessWidget {
  final List<String> dropdownItems;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;
  final String titleText;
  final String hintText;
  final bool withTitle;

  const FormTypeSelector({
    super.key,
    required this.dropdownItems,
    required this.selectedItem,
    required this.withTitle,
    required this.onChanged,
    required this.titleText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (withTitle == true)
          Column(
            children: [
              Text(
                titleText,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 5),
            ],
          ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButton<String>(
            underline: SizedBox(),
            value: selectedItem,
            hint: Text(hintText),
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
