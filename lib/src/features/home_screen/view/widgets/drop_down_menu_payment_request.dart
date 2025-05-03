import 'package:flutter/material.dart';

class FormTypeSelectorPayment extends StatelessWidget {
  final List<String> dropdownItems;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;
  final String titleText;
  final String hintText;

  const FormTypeSelectorPayment({
    super.key,
    required this.dropdownItems,
    required this.selectedItem,
    required this.onChanged, required this.titleText, required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titleText,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          width: MediaQuery.of(context).size.width*0.3,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButton<String>(
            underline: SizedBox(),
            value: selectedItem,
            hint:  Text(hintText),
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
