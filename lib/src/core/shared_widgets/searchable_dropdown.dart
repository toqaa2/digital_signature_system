import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature_system/src/core/constants/constants.dart';

class SearchableDropdown extends StatefulWidget {
  const SearchableDropdown({
    super.key,
    required this.onSelected,
    required this.onDateChanged,
    required this.onReset,
  });

  final Function(String?) onSelected;
  final Function(DateTimeRange?) onDateChanged;
  final VoidCallback onReset;

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  String fromDate = '';
  String toDate = '';
  String value = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownSearch<String>(
            selectedItem: value,
            items: (filter, loadProps) => Constants.titleName,
            enabled: true,
            onChanged: (p0) {
              value = p0.toString();
              widget.onSelected(p0);
            },
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchDelay: const Duration(microseconds: 1),
              searchFieldProps: TextFieldProps(),
            ),
          ),
        ),
        Expanded(
          child: MaterialButton(
              height: 48.h,
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2025, 1, 1),
                  lastDate: DateTime.now(),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                ).then(
                  (value) {
                    if (value != null) {
                      setState(() {
                        fromDate = value.start.toString().split(' ').first;
                        toDate = value.end.toString().split(' ').first;
                      });
                      widget.onDateChanged(value);
                    }
                  },
                );
              },
              child: Text('From $fromDate To $toDate')),
        ),
        TextButton(
            onPressed: () {
              setState(() {
                fromDate = '';
                toDate = '';
                value = '';
              });
              widget.onReset();
            },
            child: Text('Reset Filter')),
      ],
    );
  }
}
