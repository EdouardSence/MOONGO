import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'calendar_viewmodel.dart';

class CalendarView extends StackedView<CalendarViewModel> {
  const CalendarView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CalendarViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("CalendarView")),
      ),
    );
  }

  @override
  CalendarViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CalendarViewModel();
}
