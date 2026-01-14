import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:moongo/models/task_model.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: SafeArea(
        child: Column(
          children: [
            // Header avec graines
            _buildHeader(viewModel),

            // Paysage avec créatures
            Expanded(
              flex: 3,
              child: _buildLandscape(viewModel),
            ),

            // Post-it avec tâches du jour
            Expanded(
              flex: 2,
              child: _buildTodayTasks(viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'MOONGO',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Text('🌱', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 4),
                Text(
                  '${viewModel.seeds}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscape(HomeViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFBBF7D0), Color(0xFFD1FAE5), Color(0xFFDDD6FE)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Sol avec herbe
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFF86EFAC),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
          ),

          // Nuages décoratifs
          const Positioned(
            top: 20,
            left: 30,
            child: Text('☁️',
                style: TextStyle(fontSize: 30, color: Colors.white54)),
          ),
          const Positioned(
            top: 40,
            right: 40,
            child: Text('☁️',
                style: TextStyle(fontSize: 24, color: Colors.white54)),
          ),

          // Créatures
          if (viewModel.creatures.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🌳',
                      style: TextStyle(fontSize: 60, color: Colors.green[300])),
                  const SizedBox(height: 8),
                  Text(
                    'Votre parc est vide',
                    style: TextStyle(
                        color: Colors.green[700], fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Achetez un œuf dans la boutique !',
                    style: TextStyle(color: Colors.green[600], fontSize: 12),
                  ),
                ],
              ),
            )
          else
            ...viewModel.creatures
                .take(6)
                .toList()
                .asMap()
                .entries
                .map((entry) {
              final index = entry.key;
              final creature = entry.value;
              return _buildAnimatedCreature(creature, index);
            }),
        ],
      ),
    );
  }

  Widget _buildAnimatedCreature(CreatureModel creature, int index) {
    // Position aléatoire mais déterministe basée sur l'index
    final random = Random(creature.creatureId.hashCode);
    final left = 30.0 + (index % 3) * 80.0 + random.nextDouble() * 30;
    final bottom = 70.0 + (index ~/ 3) * 60.0 + random.nextDouble() * 20;

    return Positioned(
      left: left,
      bottom: bottom,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Duration(milliseconds: 1500 + random.nextInt(500)),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, sin(value * 2 * pi) * 5),
            child: child,
          );
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(creature.emoji, style: const TextStyle(fontSize: 32)),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                creature.name,
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayTasks(HomeViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFFDE68A), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📝', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text(
                "Aujourd'hui",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF92400E),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE68A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${viewModel.completedTodayCount}/${viewModel.todayTasks.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: viewModel.todayTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🎉', style: TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        Text(
                          'Aucune tâche pour aujourd\'hui !',
                          style: TextStyle(color: Colors.amber[800]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: viewModel.todayTasks.take(4).length,
                    itemBuilder: (context, index) {
                      final task = viewModel.todayTasks[index];
                      return _buildTaskItem(task, viewModel);
                    },
                  ),
          ),
          if (viewModel.todayTasks.length > 4)
            Center(
              child: Text(
                '+${viewModel.todayTasks.length - 4} autres tâches',
                style: TextStyle(fontSize: 12, color: Colors.amber[700]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(TaskModel task, HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: task.completed ? null : () => viewModel.completeTask(task),
            child: Icon(
              task.completed
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              size: 20,
              color: task.completed ? Colors.green : const Color(0xFF92400E),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontSize: 14,
                decoration: task.completed ? TextDecoration.lineThrough : null,
                color: task.completed ? Colors.grey : const Color(0xFF78350F),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(task.icon, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.init();
}
