import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature_system/src/core/constants/constants.dart';

import 'custom_button.dart';

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
  String value = 'Search by Form Title';

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
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
              shape: OutlineInputBorder(borderSide: BorderSide()),
              height: 48.h,
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2025, 1, 1),
                  lastDate: DateTime.now(),
                ).then(
                  (value) {
                    if (value != null) {
                      setState(() {
                        fromDate = value.start.toString().split(' ').first;
                        toDate = value.end.toString().split(' ').first;
                      });
                      widget.onDateChanged(DateTimeRange(
                          start: value.start,
                          end: value.end.add(const Duration(
                            hours: 23,
                            minutes: 59,
                            seconds: 59,
                            milliseconds: 999,
                          ))));
                    }
                  },
                );
              },
              child: fromDate.isEmpty
                  ? Text("Filter By Date")
                  : Text('From $fromDate To $toDate')),
        ),
        ButtonWidget(
            verticalMargin: 2,
            minWidth: 120,
            height: 35,
            textStyle: TextStyle(fontSize: 12, color: Colors.white),
            text: 'Reset Filter',
            onTap: () {
              setState(() {
                fromDate = '';
                toDate = '';
                value = '';
              });
              widget.onReset();
            }),
      ],
    );
  }
}
