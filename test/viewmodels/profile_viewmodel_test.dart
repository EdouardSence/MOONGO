import 'package:flutter_test/flutter_test.dart';
import 'package:moongo/app/app.locator.dart';
import 'package:moongo/services/theme_service.dart';
import 'package:moongo/ui/views/profile/profile_viewmodel.dart';

import '../helpers/test_helpers.dart';

void main() {
  ProfileViewModel getModel() => ProfileViewModel();

  group('ProfileViewModel Tests -', () {
    setUp(() {
      registerServices();
      locator.registerSingleton<ThemeService>(ThemeService());
    });
    tearDown(() => locator.reset());

    group('formatDate -', () {
      test('formats a date as dd/mm/yyyy', () {
        final model = getModel();
        expect(model.formatDate(DateTime(2024, 1, 15)), '15/1/2024');
      });
    });

    group('formatMemberSince -', () {
      test('returns dash when date is null', () {
        final model = getModel();
        expect(model.formatMemberSince(null), '-');
      });

      test('returns days (j) when less than 30 days', () {
        final model = getModel();
        final date = DateTime.now().subtract(const Duration(days: 10));
        expect(model.formatMemberSince(date), '10j');
      });

      test('returns months (m) when between 30 and 364 days', () {
        final model = getModel();
        final date = DateTime.now().subtract(const Duration(days: 60));
        expect(model.formatMemberSince(date), '2m');
      });

      test('returns years (a) when 365 days or more', () {
        final model = getModel();
        final date = DateTime.now().subtract(const Duration(days: 400));
        expect(model.formatMemberSince(date), '1a');
      });
    });
  });
}
