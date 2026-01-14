import 'package:flutter_test/flutter_test.dart';
import 'package:moongo/app/app.locator.dart';
import 'package:moongo/ui/views/home/home_viewmodel.dart';

import '../helpers/test_helpers.dart';

void main() {
  HomeViewModel getModel() => HomeViewModel();

  group('HomeViewmodelTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());

    group('initialization -', () {
      test('When created, should not be busy initially', () {
        final model = getModel();
        expect(model.isBusy, false);
      });

      test('When created, creatures list should be empty', () {
        final model = getModel();
        expect(model.creatures, isEmpty);
      });

      test('When created, todayTasks list should be empty', () {
        final model = getModel();
        expect(model.todayTasks, isEmpty);
      });
    });
  });
}
