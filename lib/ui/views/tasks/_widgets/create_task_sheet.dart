import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/models/task_model.dart';
import 'package:moongo/ui/common/app_theme.dart';

import '../tasks_viewmodel.dart';

/// Sheet de création de tâche avec style enchanté
class CreateTaskSheet extends StatefulWidget {
  final TasksViewModel viewModel;

  const CreateTaskSheet({super.key, required this.viewModel});

  @override
  State<CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends State<CreateTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedIcon = '✨';
  String _selectedColor = '#2D5A47';
  int _seedsReward = 10;
  DateTime? _dueDate;
  RecurrenceFrequency? _recurrenceFrequency;
  List<int> _selectedDays = [];

  // Variables pour les sous-tâches
  final List<Map<String, dynamic>> _subTasks = [];
  final _subTaskController = TextEditingController();
  int _currentSubTaskSeeds = 5;

  final List<String> _icons = [
    '✨',
    '🌟',
    '💪',
    '🎯',
    '📚',
    '🧘',
    '🏃',
    '💤',
    '🎨',
    '🎵',
    '🌿',
    '🦋'
  ];

  final List<String> _colors = [
    '#2D5A47',
    '#D4A574',
    '#7C3AED',
    '#F59E0B',
    '#059669',
    '#0EA5E9'
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Poignée
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Titre avec ornements
            Row(
              children: [
                const Text('📜', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Text(
                  'Nouvelle Quête',
                  style: GoogleFonts.fraunces(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Titre
            TextField(
              controller: _titleController,
              style: GoogleFonts.dmSans(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              decoration: InputDecoration(
                labelText: 'Titre de la quête',
                labelStyle: GoogleFonts.dmSans(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                prefixIcon: Icon(Icons.edit_outlined, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              style: GoogleFonts.dmSans(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              decoration: InputDecoration(
                labelText: 'Description (optionnel)',
                labelStyle: GoogleFonts.dmSans(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                prefixIcon:
                    Icon(Icons.notes_outlined, color: AppColors.secondary),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Section Étapes
            Text(
              'Étapes de la quête',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: _subTasks.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Aucune étape définie',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey[600]
                                    : Colors.grey[400],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: _subTasks.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final sub = _subTasks[index];
                              return ListTile(
                                dense: true,
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        sub['title'],
                                        style: GoogleFonts.dmSans(
                                          color: isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.lightTextPrimary,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.tertiary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${sub['seedsReward']} 🌱',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.tertiary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close,
                                      size: 18, color: Colors.grey),
                                  onPressed: () => setState(() {
                                    _subTasks.removeAt(index);
                                  }),
                                ),
                              );
                            },
                          ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _subTaskController,
                            style: GoogleFonts.dmSans(fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Ajouter une étape...',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12),
                            ),
                            onSubmitted: (_) => _addSubTask(),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: AppColors.tertiary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _currentSubTaskSeeds,
                              isDense: true,
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 16),
                              items: [5, 10, 15, 20]
                                  .map((v) => DropdownMenuItem(
                                        value: v,
                                        child: Text('$v 🌱',
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      ))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _currentSubTaskSeeds = v ?? 5),
                            ),
                          ),
                        ),
                        IconButton(
                          icon:
                              Icon(Icons.add_circle, color: AppColors.tertiary),
                          onPressed: _addSubTask,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Icônes
            Text(
              'Emblème',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _icons.map((icon) {
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : (isDark
                              ? AppColors.darkBackground
                              : AppColors.lightBackground),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(icon, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Couleurs
            Text(
              'Aura',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: _colors.map((color) {
                final isSelected = _selectedColor == color;
                final colorValue =
                    Color(int.parse(color.replaceFirst('#', '0xFF')));
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorValue,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorValue.withValues(
                              alpha: isSelected ? 0.5 : 0.3),
                          blurRadius: isSelected ? 12 : 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 24)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Récompense
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tertiary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.tertiary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Text('🌱', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(
                    'Récompense:',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<int>(
                    value: _seedsReward,
                    dropdownColor:
                        isDark ? AppColors.darkSurface : Colors.white,
                    style: GoogleFonts.fraunces(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.tertiary,
                    ),
                    underline: const SizedBox(),
                    items: [5, 10, 15, 20, 25, 30, 50].map((v) {
                      return DropdownMenuItem(
                        value: v,
                        child: Text('$v graines'),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _seedsReward = v ?? 10),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            DatePickerTile(
              isDark: isDark,
              dueDate: _dueDate,
              onPickDate: _selectDate,
              onClearDate: () => setState(() => _dueDate = null),
            ),
            const SizedBox(height: 24),
            RecurrenceOptions(
              isDark: isDark,
              recurrenceFrequency: _recurrenceFrequency,
              selectedDays: _selectedDays,
              onSelectFrequency: _selectFrequency,
              onClearFrequency: _clearFrequency,
              onToggleDay: _toggleDay,
            ),

            const SizedBox(height: 32),

            // Bouton créer
            GestureDetector(
              onTap: _submitTask,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.85)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('✨', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Text(
                      'Inscrire la quête',
                      style: GoogleFonts.fraunces(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: isDark ? AppColors.darkSurface : Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        _dueDate = date;
        _recurrenceFrequency = null; // Exclusion mutuelle
        _selectedDays = [];
      });
    }
  }

  void _selectFrequency(RecurrenceFrequency frequency) {
    setState(() {
      _recurrenceFrequency = frequency;
      _dueDate = null; // Exclusion mutuelle
      if (frequency != RecurrenceFrequency.custom) {
        _selectedDays = [];
      }
    });
  }

  void _clearFrequency() {
    setState(() {
      _recurrenceFrequency = null;
      _selectedDays = [];
    });
  }

  void _toggleDay(int dayNumber) {
    setState(() {
      if (_selectedDays.contains(dayNumber)) {
        _selectedDays.remove(dayNumber);
      } else {
        _selectedDays.add(dayNumber);
      }
    });
  }

  void _addSubTask() {
    if (_subTaskController.text.isNotEmpty) {
      setState(() {
        _subTasks.add({
          'title': _subTaskController.text,
          'completed': false,
          'seedsReward': _currentSubTaskSeeds,
        });
        _subTaskController.clear();
      });
    }
  }

  void _submitTask() {
    if (_titleController.text.isEmpty) return;

    // Validation fréquence perso
    if (_recurrenceFrequency == RecurrenceFrequency.custom &&
        _selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Veuillez choisir les jours pour le rituel')));
      return;
    }

    // Déduction du type : Soit Routine, soit Unique
    TaskType type = TaskType.single;
    if (_recurrenceFrequency != null) {
      type = TaskType.recurring;
    }

    // Construction des sous-tâches
    List<SubTask>? subTaskObjects;
    if (_subTasks.isNotEmpty) {
      subTaskObjects = _subTasks.map((s) {
        final id =
            '${DateTime.now().millisecondsSinceEpoch}_${_subTasks.indexOf(s)}';
        return SubTask(
          id: id,
          title: s['title'],
          seedsReward: s['seedsReward'] as int,
          completed: false,
        );
      }).toList();
    }

    widget.viewModel.createTask(
      title: _titleController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      icon: _selectedIcon,
      color: _selectedColor,
      type: type,
      seedsReward: _seedsReward,
      dueDate: _dueDate,
      recurrence: _recurrenceFrequency != null
          ? RecurrenceConfig(
              frequency: _recurrenceFrequency!,
              daysOfWeek: _recurrenceFrequency == RecurrenceFrequency.custom &&
                      _selectedDays.isNotEmpty
                  ? _selectedDays
                  : null,
            )
          : null,
      subTasks: subTaskObjects,
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subTaskController.dispose();
    super.dispose();
  }
}

class DatePickerTile extends StatelessWidget {
  final bool isDark;
  final DateTime? dueDate;
  final VoidCallback onPickDate;
  final VoidCallback onClearDate;

  const DatePickerTile({
    super.key,
    required this.isDark,
    required this.dueDate,
    required this.onPickDate,
    required this.onClearDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickDate,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: dueDate != null ? AppColors.accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded, color: AppColors.accent),
            const SizedBox(width: 12),
            Text(
              dueDate == null
                  ? 'Ajouter une échéance'
                  : '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}',
              style: GoogleFonts.dmSans(
                color: dueDate != null
                    ? (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary)
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
              ),
            ),
            const Spacer(),
            if (dueDate != null)
              GestureDetector(
                onTap: onClearDate,
                child: Icon(Icons.close_rounded, color: Colors.grey[500]),
              ),
          ],
        ),
      ),
    );
  }
}

class RecurrenceOptions extends StatelessWidget {
  final bool isDark;
  final RecurrenceFrequency? recurrenceFrequency;
  final List<int> selectedDays;
  final ValueChanged<RecurrenceFrequency> onSelectFrequency;
  final VoidCallback onClearFrequency;
  final ValueChanged<int> onToggleDay;

  const RecurrenceOptions({
    super.key,
    required this.isDark,
    required this.recurrenceFrequency,
    required this.selectedDays,
    required this.onSelectFrequency,
    required this.onClearFrequency,
    required this.onToggleDay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Répéter cette quête ?',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            if (recurrenceFrequency != null)
              GestureDetector(
                onTap: onClearFrequency,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Non, unique',
                    style: TextStyle(
                      color: Colors.red[400],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: RecurrenceFrequency.values.map((freq) {
            final isSelected = recurrenceFrequency == freq;
            String label;
            String emoji;
            switch (freq) {
              case RecurrenceFrequency.daily:
                label = 'Quotidien';
                emoji = '🌅';
              case RecurrenceFrequency.weekly:
                label = 'Hebdo';
                emoji = '📅';
              case RecurrenceFrequency.monthly:
                label = 'Mensuel';
                emoji = '🌙';
              case RecurrenceFrequency.custom:
                label = 'Perso';
                emoji = '⚙️';
            }
            return GestureDetector(
              onTap: () => onSelectFrequency(freq),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.tertiary
                      : (isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.tertiary.withValues(alpha: 0.4),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(emoji),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: GoogleFonts.dmSans(
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (recurrenceFrequency == RecurrenceFrequency.custom) ...[
          const SizedBox(height: 16),
          Text(
            'Jours de répétition',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DayButton(
                label: 'L',
                dayNumber: 1,
                isDark: isDark,
                isSelected: selectedDays.contains(1),
                onTap: () => onToggleDay(1),
              ),
              DayButton(
                label: 'M',
                dayNumber: 2,
                isDark: isDark,
                isSelected: selectedDays.contains(2),
                onTap: () => onToggleDay(2),
              ),
              DayButton(
                label: 'M',
                dayNumber: 3,
                isDark: isDark,
                isSelected: selectedDays.contains(3),
                onTap: () => onToggleDay(3),
              ),
              DayButton(
                label: 'J',
                dayNumber: 4,
                isDark: isDark,
                isSelected: selectedDays.contains(4),
                onTap: () => onToggleDay(4),
              ),
              DayButton(
                label: 'V',
                dayNumber: 5,
                isDark: isDark,
                isSelected: selectedDays.contains(5),
                onTap: () => onToggleDay(5),
              ),
              DayButton(
                label: 'S',
                dayNumber: 6,
                isDark: isDark,
                isSelected: selectedDays.contains(6),
                onTap: () => onToggleDay(6),
              ),
              DayButton(
                label: 'D',
                dayNumber: 7,
                isDark: isDark,
                isSelected: selectedDays.contains(7),
                onTap: () => onToggleDay(7),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class DayButton extends StatelessWidget {
  final String label;
  final int dayNumber;
  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;

  const DayButton({
    super.key,
    required this.label,
    required this.dayNumber,
    required this.isDark,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkBackground : AppColors.lightBackground),
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              color: isSelected
                  ? Colors.white
                  : (isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
