import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar_viewmodel.dart';

class CalendarView extends StackedView<CalendarViewModel> {
  const CalendarView({super.key});

  @override
  Widget builder(
      BuildContext context, CalendarViewModel viewModel, Widget? child) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF6366F1); // AppColors.primary si dispo

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1F2937) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Agenda des Quêtes',
          style: GoogleFonts.fraunces(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Calendrier
          Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? const Color(0xFF374151) : Colors.white,
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: viewModel.focusedDay,
              calendarFormat: viewModel.calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(viewModel.selectedDay, day);
              },
              onDaySelected: viewModel.onDaySelected,
              onFormatChanged: viewModel.onFormatChanged,
              onPageChanged: viewModel.onPageChanged,
              eventLoader: viewModel.getTasksForDay,
              locale: 'fr_FR',
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                markerDecoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                defaultTextStyle:
                    TextStyle(color: isDark ? Colors.white : Colors.black87),
                weekendTextStyle: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                titleTextStyle: GoogleFonts.dmSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87),
                formatButtonTextStyle: TextStyle(color: primaryColor),
                formatButtonDecoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                leftChevronIcon: Icon(Icons.chevron_left,
                    color: isDark ? Colors.white : Colors.black87),
                rightChevronIcon: Icon(Icons.chevron_right,
                    color: isDark ? Colors.white : Colors.black87),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Liste des tâches du jour
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tâches du ${DateFormat.yMMMMEEEEd('fr_FR').format(viewModel.selectedDay)}',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[300] : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: viewModel.tasksForSelectedDay.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Aucune quête ce jour',
                                  style: GoogleFonts.dmSans(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: viewModel.tasksForSelectedDay.length,
                            itemBuilder: (context, index) {
                              final task = viewModel.tasksForSelectedDay[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                color: isDark
                                    ? const Color(0xFF374151)
                                    : Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  leading: Text(task.icon,
                                      style: const TextStyle(fontSize: 24)),
                                  title: Text(
                                    task.title,
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                      decoration: task.completed
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  subtitle: task.description != null
                                      ? Text(task.description!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis)
                                      : null,
                                  trailing: Checkbox(
                                    value: task.completed,
                                    activeColor: primaryColor,
                                    onChanged: (val) {
                                      // Toggle task logic (optionnel si on peut modifier depuis l'historique)
                                      // viewModel.toggleTask(task);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  CalendarViewModel viewModelBuilder(BuildContext context) =>
      CalendarViewModel();

  @override
  void onViewModelReady(CalendarViewModel viewModel) => viewModel.init();
}
