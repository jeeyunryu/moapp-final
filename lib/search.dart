import 'package:flutter/material.dart';

class Item {
  Item({
    required this.id,
    required this.expandedValue,
    required this.headerValue,
  });

  int id;
  String expandedValue;
  String headerValue;
}


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

  // @override
  // void initState() {
  //   super.initState();
  //   _isOpen = true; // Set the initial value to true
  // }

  @override
  Widget build(BuildContext context) {
    bool _isOpen = true;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        centerTitle: true,
        title: const Text('Search', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10, 0, 0),
            child:
                Text('Filter', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ExpansionPanelList.radio(
            initialOpenPanelValue: 1,
            children: [
              ExpansionPanelRadio(
                value: 1,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text('select filters'),
                  );
                },
                body: Container(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.blue,
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
                          activeColor: Colors.blue,
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
                          activeColor: Colors.blue,
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
              ),
            ],
          ),
          // ExpansionPanelList(
          //     children: [
          //       ExpansionPanel(
          //         headerBuilder: (context, isExpanded) {
          //           return Text('select filters');
          //         },
          //         body: Container(
          //             child: Column(
          //           children: [
          //             Row(
          //               children: [
          //                 Checkbox(
          //                   activeColor: Colors.blue,
          //                   // fillColor: MaterialStateProperty.resolveWith(getColor),
          //                   value: isChecked,
          //                   onChanged: (bool? value) {
          //                     setState(() {
          //                       isChecked = value!;
          //                     });
          //                   },
          //                 ),
          //                 Text('No Kids Zone'),
          //               ],
          //             ),
          //             Row(
          //               children: [
          //                 Checkbox(
          //                   activeColor: Colors.blue,
          //                   // fillColor: MaterialStateProperty.resolveWith(getColor),
          //                   value: isChecked2,
          //                   onChanged: (bool? value) {
          //                     setState(() {
          //                       isChecked2 = value!;
          //                     });
          //                   },
          //                 ),
          //                 Text('Pet-Friendly'),
          //               ],
          //             ),
          //             Row(
          //               children: [
          //                 Checkbox(
          //                   // fillColor: MaterialStateProperty.resolveWith(getColor),
          //                   value: isChecked3,
          //                   onChanged: (bool? value) {
          //                     setState(() {
          //                       isChecked3 = value!;
          //                     });
          //                   },
          //                 ),
          //                 Text('Free breakfast'),
          //               ],
          //             )
          //           ],
          //         )),
          //         isExpanded: _isOpen,
          //       ),
          // ],
          // expansionCallback: (i, isExpanded) {
          //   setState(() {
          //     _isOpen = !isExpanded;
          //     print('Debugging message: $isExpanded');
          //     print('Debugging message: $_isOpen');
          //   });
          // }),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 30.0, 0, 0),
            child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('check-in'),
                Container(
                  width: 120,
                  child: Text(
                      '${_selectedDate.value.year}.${_selectedDate.value.month}.${_selectedDate.value.day} (FRI) 9:30 am',
                      style: TextStyle(color: Colors.grey)),
                ),
              ]),
              Container(
                width: 170,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      side: BorderSide(color: Colors.lightBlue),
                    ),
                    // const ButtonStyle(
                    //   backgroundColor:
                    //       MaterialStatePropertyAll<Color>(Colors.lightBlue),
                    //   side:
                    // ),
                    onPressed: () {
                      _restorableDatePickerRouteFuture.present();
                    },
                    child: const Text('select date',
                        style: TextStyle(color: Colors.black))),
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 108.0, left: 100, right: 100),
            child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                ),
                onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                            title: const Text('Please check your choice :)'),
                            content: Column(children: [
                              Row(
                                children: [
                                  Icon(Icons.filter_list, color: Colors.blue),
                                  SizedBox(width: 10),
                                  Container(
                                    width: 150,
                                    child: Text(getSelectedFiltersText(),
                                        style: TextStyle(color: Colors.grey)),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.calendar_month,
                                      color: Colors.blue),
                                  SizedBox(width: 10),
                                  const Text('IN'),
                                  SizedBox(width: 10),
                                  Text(
                                      '${_selectedDate.value.year}.${_selectedDate.value.month}.${_selectedDate.value.day} (FRI)',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ]),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Search'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('Cancel'),
                              )
                            ])),
                child: const Text('Search',
                    style: TextStyle(color: Colors.white, fontSize: 30.0))),
          ),
        ],
      ),
    );
  }
}
