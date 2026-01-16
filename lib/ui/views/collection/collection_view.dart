import 'package:flutter/material.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:stacked/stacked.dart';

import '_widgets/collection_widgets.dart';
import 'collection_viewmodel.dart';

/// Collection View avec esthétique "Cabinet de Curiosités" - Galerie mystique
class CollectionView extends StackedView<CollectionViewModel> {
  const CollectionView({super.key});

  @override
  Widget builder(
      BuildContext context, CollectionViewModel viewModel, Widget? child) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Fond avec texture de galerie
          GalleryBackground(isDark: isDark),

          // Contenu
          Column(
            children: [
              // En-tête de la galerie
              GalleryHeader(creaturesCount: viewModel.creatures.length),

              // Contenu principal
              Expanded(
                child: viewModel.isBusy
                    ? const CollectionLoadingState()
                    : viewModel.creatures.isEmpty
                        ? CollectionEmptyState(isDark: isDark)
                        : CreatureGallery(
                            creatures: viewModel.creatures,
                            onCreatureTap: (creature) =>
                                _showCreatureDetail(context, creature),
                          ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Détail de la créature
  void _showCreatureDetail(BuildContext context, CreatureModel creature) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CreatureDetailSheet(creature: creature),
    );
  }

  @override
  CollectionViewModel viewModelBuilder(BuildContext context) =>
      CollectionViewModel();

  @override
  void onViewModelReady(CollectionViewModel viewModel) => viewModel.init();
}
