import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  final String? restorationId = 'main';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with RestorationMixin {
  bool isChecked = false;
  bool isChecked2 = false;
  bool isChecked3 = false;

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2021, 7, 25));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2021),
          lastDate: DateTime(2022),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  String getSelectedFiltersText() {
    List<String> selectedFilters = [];
    if (isChecked) selectedFilters.add('No Kids Zone');
    if (isChecked2) selectedFilters.add('Pet-Friendly');
    if (isChecked3) selectedFilters.add('Free breakfast');

    return selectedFilters.join(' / ');
  }

  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          Text('Filter'),
          ExpansionPanelList(
              children: [
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Text('select filters');
                  },
                  body: Container(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            // fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          Text('No Kids Zone'),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            // fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked2,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked2 = value!;
                              });
                            },
                          ),
                          Text('Pet-Friendly'),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            // fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked3,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked3 = value!;
                              });
                            },
                          ),
                          Text('Free breakfast'),
                        ],
                      )
                    ],
                  )),
                  isExpanded: _isOpen,
                ),
              ],
              expansionCallback: (i, isOpen) {
                setState(() {
                  _isOpen = !isOpen;
                });
              }),
          Text('Date'),
          Row(children: [
            Column(children: [
              Text('check-in'),
              Text(
                  '${_selectedDate.value.year}.${_selectedDate.value.month}.${_selectedDate.value.day} ${_selectedDate.value.hour}:${_selectedDate.value.minute}'),
            ]),
            OutlinedButton(
                onPressed: () {
                  _restorableDatePickerRouteFuture.present();
                },
                child: const Text('select date'))
          ]),
          ElevatedButton(
              onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                          title: const Text('Please check your choice :)'),
                          content: Column(children: [
                            Row(
                              children: [
                                Icon(Icons.filter_list),
                                SizedBox(width: 10),
                                Container(
                                  width: 150,
                                  child: Text(getSelectedFiltersText()),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.calendar_month),
                                SizedBox(width: 10),
                                const Text('IN'),
                                SizedBox(width: 10),
                                Text(
                                    '${_selectedDate.value.year}.${_selectedDate.value.month}.${_selectedDate.value.day}'),
                              ],
                            ),
                          ]),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Search'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('Cancel'),
                            )
                          ])),
              child: const Text('Search')),
        ],
      ),
    );
  }
}
