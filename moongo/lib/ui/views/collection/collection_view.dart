import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'collection_viewmodel.dart';

class CollectionView extends StackedView<CollectionViewModel> {
  const CollectionView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CollectionViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("CollectionView")),
      ),
    );
  }

  @override
  CollectionViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CollectionViewModel();
}
