import 'package:flutter/material.dart';
import 'package:moongo/models/task_model.dart';
import 'package:stacked/stacked.dart';

import 'tasks_viewmodel.dart';

class TasksView extends StackedView<TasksViewModel> {
  const TasksView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, TasksViewModel viewModel, Widget? child) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text(
            'Mes Tâches',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF6366F1),
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Tous'),
              Tab(text: "Aujourd'hui"),
              Tab(text: 'Semaine'),
              Tab(text: 'Mois'),
            ],
          ),
        ),
        body: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildTaskList(viewModel, viewModel.allTasks),
                  _buildTaskList(viewModel, viewModel.todayTasks),
                  _buildTaskList(viewModel, viewModel.weekTasks),
                  _buildTaskList(viewModel, viewModel.monthTasks),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateTaskSheet(context, viewModel),
          backgroundColor: const Color(0xFF6366F1),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTaskList(TasksViewModel viewModel, List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Aucune tâche',
              style: TextStyle(fontSize: 18, color: Colors.grey[500]),
            ),
            const SizedBox(height: 8),
            Text(
              'Appuyez sur + pour créer une tâche',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(context, viewModel, task);
      },
    );
  }

  Widget _buildTaskCard(
      BuildContext context, TasksViewModel viewModel, TaskModel task) {
    final color = Color(int.parse(task.color.replaceFirst('#', '0xFF')));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header coloré
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Text(task.icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: task.completed
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.completed ? Colors.grey : Colors.black87,
                        ),
                      ),
                      if (task.description != null &&
                          task.description!.isNotEmpty)
                        Text(
                          task.description!,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                _buildTypeChip(task.type),
              ],
            ),
          ),
          // Contenu
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (task.type == TaskType.objective || task.subTasks.isNotEmpty)
                  _buildProgressBar(context, viewModel, task)
                else
                  _buildTaskActions(context, viewModel, task),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(TaskType type) {
    String label;
    Color color;
    IconData icon;

    switch (type) {
      case TaskType.single:
        label = 'Unique';
        color = Colors.blue;
        icon = Icons.calendar_today;
        break;
      case TaskType.recurring:
        label = 'Routine';
        color = Colors.green;
        icon = Icons.repeat;
        break;
      case TaskType.objective:
        label = 'Objectif';
        color = Colors.orange;
        icon = Icons.flag;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                fontSize: 12, color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
      BuildContext context, TasksViewModel viewModel, TaskModel task) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              task.subTasks.isEmpty
                  ? 'Aucune tâche'
                  : '${(task.progress * 100).toInt()}% complété',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (task.subTasks.isNotEmpty)
              Text(
                '${task.subTasks.where((t) => t.completed).length}/${task.subTasks.length}',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: task.progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 12),
        ...task.subTasks
            .map((subTask) => _buildSubTaskItem(viewModel, task, subTask)),
        const SizedBox(height: 8),
        // Bouton pour ajouter une sous-tâche
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () => _showAddSubTaskDialog(context, viewModel, task),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Ajouter une tâche'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6366F1),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.eco, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  '+${task.seedsReward} graines',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (task.progress >= 1.0 && !task.completed)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => viewModel.completeTask(task),
                icon: const Icon(Icons.check),
                label: const Text('Objectif atteint !'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubTaskItem(
      TasksViewModel viewModel, TaskModel task, SubTask subTask) {
    return GestureDetector(
      onTap: subTask.completed
          ? null
          : () => viewModel.completeSubTask(task, subTask.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              subTask.completed
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              size: 20,
              color: subTask.completed ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                subTask.title,
                style: TextStyle(
                  decoration:
                      subTask.completed ? TextDecoration.lineThrough : null,
                  color: subTask.completed ? Colors.grey : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSubTaskDialog(
      BuildContext context, TasksViewModel viewModel, TaskModel task) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle tâche'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Titre de la tâche',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                viewModel.addSubTaskToObjective(task.taskId, controller.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
            ),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskActions(
      BuildContext context, TasksViewModel viewModel, TaskModel task) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.eco, size: 16, color: Colors.green),
            const SizedBox(width: 4),
            Text(
              '+${task.seedsReward} graines',
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Row(
          children: [
            if (!task.completed)
              ElevatedButton.icon(
                onPressed: () => viewModel.completeTask(task),
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Terminer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, size: 18, color: Colors.green),
                    SizedBox(width: 4),
                    Text('Fait!',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => viewModel.deleteTask(task.taskId),
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }

  void _showCreateTaskSheet(BuildContext context, TasksViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateTaskSheet(viewModel: viewModel),
    );
  }

  @override
  TasksViewModel viewModelBuilder(BuildContext context) => TasksViewModel();

  @override
  void onViewModelReady(TasksViewModel viewModel) => viewModel.init();
}

class _CreateTaskSheet extends StatefulWidget {
  final TasksViewModel viewModel;

  const _CreateTaskSheet({required this.viewModel});

  @override
  State<_CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends State<_CreateTaskSheet> {
  TaskType _selectedType = TaskType.single;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedIcon = '✨';
  String _selectedColor = '#6366F1';
  int _seedsReward = 10;
  DateTime? _dueDate;
  RecurrenceFrequency? _recurrenceFrequency;
  List<int> _selectedDays = []; // 1=Lundi, 7=Dimanche
  bool _isGroupedTask = false; // Pour les routines groupées

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
    '🎵'
  ];
  final List<String> _colors = [
    '#6366F1',
    '#EC4899',
    '#10B981',
    '#F59E0B',
    '#EF4444',
    '#8B5CF6'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Nouvelle Tâche',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Type de tâche
            const Text('Type', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildTypeButton(
                    'Unique', TaskType.single, Icons.calendar_today),
                const SizedBox(width: 8),
                _buildTypeButton('Routine', TaskType.recurring, Icons.repeat),
                const SizedBox(width: 8),
                _buildTypeButton('Objectif', TaskType.objective, Icons.flag),
              ],
            ),
            const SizedBox(height: 20),

            // Titre
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Titre',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (optionnel)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.description),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),

            // Icône
            const Text('Icône', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _icons.map((icon) {
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF6366F1).withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: const Color(0xFF6366F1), width: 2)
                          : null,
                    ),
                    child: Center(
                        child:
                            Text(icon, style: const TextStyle(fontSize: 24))),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Couleur
            const Text('Couleur',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _colors.map((color) {
                final isSelected = _selectedColor == color;
                final colorValue =
                    Color(int.parse(color.replaceFirst('#', '0xFF')));
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colorValue,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Graines
            Row(
              children: [
                const Text('Récompense:',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                const Icon(Icons.eco, color: Colors.green, size: 20),
                const SizedBox(width: 4),
                DropdownButton<int>(
                  value: _seedsReward,
                  items: [5, 10, 15, 20, 25, 30, 50].map((v) {
                    return DropdownMenuItem(
                        value: v, child: Text('$v graines'));
                  }).toList(),
                  onChanged: (v) => setState(() => _seedsReward = v ?? 10),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Date (pour tâche unique)
            if (_selectedType == TaskType.single) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: Text(_dueDate == null
                    ? 'Ajouter une date (optionnel)'
                    : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'),
                trailing: _dueDate != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _dueDate = null),
                      )
                    : null,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _dueDate = date);
                },
              ),
            ],

            // Récurrence (pour routine)
            if (_selectedType == TaskType.recurring) ...[
              const Text('Fréquence',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: RecurrenceFrequency.values.map((freq) {
                  final isSelected = _recurrenceFrequency == freq;
                  String label;
                  switch (freq) {
                    case RecurrenceFrequency.daily:
                      label = 'Quotidien';
                    case RecurrenceFrequency.weekly:
                      label = 'Hebdo';
                    case RecurrenceFrequency.monthly:
                      label = 'Mensuel';
                    case RecurrenceFrequency.custom:
                      label = 'Perso';
                  }
                  return ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _recurrenceFrequency = freq;
                        if (freq != RecurrenceFrequency.custom) {
                          _selectedDays = [];
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              // Sélecteur de jours pour fréquence Perso
              if (_recurrenceFrequency == RecurrenceFrequency.custom) ...[
                const SizedBox(height: 16),
                const Text('Jours de répétition',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDayButton('L', 1),
                    _buildDayButton('M', 2),
                    _buildDayButton('M', 3),
                    _buildDayButton('J', 4),
                    _buildDayButton('V', 5),
                    _buildDayButton('S', 6),
                    _buildDayButton('D', 7),
                  ],
                ),
              ],
              // Checkbox pour tâche groupée
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _isGroupedTask,
                onChanged: (v) => setState(() => _isGroupedTask = v ?? false),
                title: const Text('Tâche groupée'),
                subtitle: const Text('Permet d\'ajouter plusieurs sous-tâches'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],

            const SizedBox(height: 32),

            // Bouton créer
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _titleController.text.isEmpty
                    ? null
                    : () {
                        widget.viewModel.createTask(
                          title: _titleController.text,
                          description: _descriptionController.text.isEmpty
                              ? null
                              : _descriptionController.text,
                          icon: _selectedIcon,
                          color: _selectedColor,
                          type: _selectedType,
                          seedsReward: _seedsReward,
                          dueDate: _dueDate,
                          recurrence: _selectedType == TaskType.recurring &&
                                  _recurrenceFrequency != null
                              ? RecurrenceConfig(
                                  frequency: _recurrenceFrequency!,
                                  daysOfWeek: _recurrenceFrequency ==
                                              RecurrenceFrequency.custom &&
                                          _selectedDays.isNotEmpty
                                      ? _selectedDays
                                      : null,
                                )
                              : null,
                        );
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Créer la tâche',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, TaskType type, IconData icon) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.grey),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayButton(String label, int dayNumber) {
    final isSelected = _selectedDays.contains(dayNumber);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedDays.remove(dayNumber);
          } else {
            _selectedDays.add(dayNumber);
          }
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
