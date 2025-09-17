import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timora/theme/theme_manager.dart';
import 'package:timora/theme/themes.dart';
import 'package:timora/theme/colors.dart'; // timoraClassic + defaultFeedback

void main() {
  group('ThemeManager with ThemeModel', () {
    late ThemeManager manager;

    // Deux variantes d’un même duo (light/dark) — NOTE: duoId identique
    final light = ThemeModel(
      id: 'timora-light',
      duoId: 'timora',
      name: 'Timora Light',
      isDark: false,
      isPremium: false,
      palette: timoraClassic,
      feedback: defaultFeedback,
    );

    final dark = ThemeModel(
      id: 'timora-dark',
      duoId: 'timora',
      name: 'Timora Dark',
      isDark: true,
      isPremium: false,
      palette: timoraClassic,
      feedback: defaultFeedback,
    );

    setUp(() {
      manager = ThemeManager(catalog: [light, dark]);
      manager.setById('timora-light');
    });

    test('setById sélectionne le thème courant', () {
      expect(manager.current.id, 'timora-light');
      expect(manager.isDark, isFalse);

      manager.setById('timora-dark');
      expect(manager.current.id, 'timora-dark');
      expect(manager.isDark, isTrue);
    });

    test('toggleDuo bascule light ↔ dark sur le même duoId', () {
      expect(manager.isDark, isFalse);
      manager.toggleDuo();
      expect(manager.isDark, isTrue);
      manager.toggleDuo();
      expect(manager.isDark, isFalse);
    });
  });
}
