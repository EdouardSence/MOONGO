import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'shop_viewmodel.dart';

class ShopView extends StackedView<ShopViewModel> {
  const ShopView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ShopViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("ShopView")),
      ),
    );
  }

  @override
  ShopViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ShopViewModel();
}
