import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:timora/theme/theme_manager.dart';
import 'package:timora/theme/theme_switcher.dart';
import 'package:timora/theme/themes.dart';
import 'package:timora/theme/colors.dart';

void main() {
  testWidgets('ThemeSwitcher rebuilds when ThemeManager toggles duo',
          (WidgetTester tester) async {
        // Deux thèmes du même duo
        final light = ThemeModel(
          id: 'timora-light',
          duoId: 'timora',
          name: 'Light',
          isDark: false,
          isPremium: false,
          palette: timoraClassic,
          feedback: defaultFeedback,
        );
        final dark = ThemeModel(
          id: 'timora-dark',
          duoId: 'timora',
          name: 'Dark',
          isDark: true,
          isPremium: false,
          palette: timoraClassic,
          feedback: defaultFeedback,
        );

        final manager = ThemeManager(catalog: [light, dark]);
        manager.setById('timora-light');

        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: manager,
            child: ThemeSwitcher(
              child: Builder(
                builder: (context) {
                  final theme = Theme.of(context);
                  return Text(
                    theme.brightness == Brightness.dark ? 'dark' : 'light',
                    textDirection: TextDirection.ltr,
                  );
                },
              ),
            ),
          ),
        );

        // Vérifie état initial (light)
        expect(find.text('light'), findsOneWidget);

        // Toggle vers dark
        manager.toggleDuo();
        await tester.pumpAndSettle();

        // Vérifie que le texte reflète le changement
        expect(find.text('dark'), findsOneWidget);
      });
}
