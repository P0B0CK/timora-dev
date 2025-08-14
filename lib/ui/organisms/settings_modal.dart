// lib/ui/organisms/settings_modal.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timora/ui/atoms/button.dart';
import 'package:timora/ui/molecules/app_modal.dart';
import 'package:timora/theme/colors_extension.dart';
import 'package:timora/theme/theme_manager.dart';
import 'package:timora/env.dart' show AppConfig, AppEnvironment;

/// Ouvre la modale Paramètres
Future<void> openSettingsModal(BuildContext context) async {
  await showAppModal<void>(
    context: context,
    title: 'Paramètres',
    content: const _SettingsContent(),
    actions: const [
      AppModalAction<void>(label: 'Fermer', type: ButtonType.outlined),
    ],
    gapTitleToContent: 24,
    gapContentToActions: 24,
  );
}

class _SettingsContent extends StatelessWidget {
  const _SettingsContent();

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final tokens = theme.extension<AppColors>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('Apparence'),
        const SizedBox(height: 12),
        const _AppearanceRow(),

        const SizedBox(height: 28),
        _SectionTitle('Notifications'),
        const SizedBox(height: 12),
        const _NotificationsPanel(),

        const SizedBox(height: 28),
        _SectionTitle('À propos'),
        const SizedBox(height: 12),
        const _AboutPanel(),

        const SizedBox(height: 8),
        Text(
          'Crédits & remerciements à venir…',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: (tokens?.onSurface ?? theme.colorScheme.onSurface).withOpacity(0.7),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: .3,
      ),
    );
  }
}

class _AppearanceRow extends StatelessWidget {
  const _AppearanceRow();

  @override
  Widget build(BuildContext context) {
    final tm = context.watch<ThemeManager>();
    final isDark = tm.isDark;

    return Row(
      children: [
        Expanded(child: Text('Thème', style: Theme.of(context).textTheme.bodyLarge)),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: false, label: Text('Clair')),
            ButtonSegment(value: true,  label: Text('Sombre')),
          ],
          selected: {isDark},
          onSelectionChanged: (sel) {
            final next = sel.first;
            if (next != isDark) tm.toggleDuo();
          },
        ),
      ],
    );
  }
}

class _NotificationsPanel extends StatefulWidget {
  const _NotificationsPanel();

  @override
  State<_NotificationsPanel> createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<_NotificationsPanel> {
  bool _pushEnabled = true;
  bool _emailEnabled = false;
  bool _dndEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SettingTile(
          title: 'Notifications push',
          subtitle: 'Recevoir des notifications sur cet appareil',
          value: _pushEnabled,
          onChanged: (v) => setState(() => _pushEnabled = v),
        ),
        const SizedBox(height: 10),
        _SettingTile(
          title: 'Notifications par e-mail',
          subtitle: 'Recevoir un résumé quotidien',
          value: _emailEnabled,
          onChanged: (v) => setState(() => _emailEnabled = v),
        ),
        const SizedBox(height: 10),
        _SettingTile(
          title: 'Ne pas déranger',
          subtitle: 'Couper les notifications aux heures définies',
          value: _dndEnabled,
          onChanged: (v) => setState(() => _dndEnabled = v),
        ),
        if (_dndEnabled) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Plage horaire à venir…',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingTile({
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final tokens = theme.extension<AppColors>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: tokens?.surface ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tokens?.outline ?? theme.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: (tokens?.onSurface ?? theme.colorScheme.onSurface).withOpacity(0.7),
                  ),
                ),
              ],
            ]),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _AboutPanel extends StatelessWidget {
  const _AboutPanel();

  String _envLabel(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.dev: return 'DEV';
      case AppEnvironment.staging: return 'STAGING';
      case AppEnvironment.prod: return 'PROD';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme   = Theme.of(context);
    final tokens  = theme.extension<AppColors>();
    final env     = AppConfig.instance.env;
    const appName = 'Timora';
    const version = '0.1.0';

    return Column(
      children: [
        _AboutTile(
          icon: Icons.apps_rounded,
          title: appName,
          subtitle: 'Version $version  •  ${_envLabel(env)}',
        ),
        const SizedBox(height: 10),
        _AboutTile(
          icon: Icons.description_outlined,
          title: 'Licences open-source',
          subtitle: 'Packages et licences utilisés',
          onTap: () => showLicensePage(
            context: context,
            applicationName: appName,
            applicationVersion: version,
          ),
        ),
        const SizedBox(height: 10),
        _AboutTile(
          icon: Icons.gavel_outlined,
          title: 'Mentions légales',
          subtitle: 'Bientôt disponible',
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mentions légales à venir')),
          ),
        ),
      ],
    );
  }
}

class _AboutTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _AboutTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final tokens = theme.extension<AppColors>();

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: tokens?.surface ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: tokens?.outline ?? theme.dividerColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: tokens?.onSurface ?? theme.colorScheme.onSurface),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: (tokens?.onSurface ?? theme.colorScheme.onSurface).withOpacity(0.7),
                    ),
                  ),
                ],
              ]),
            ),
            if (onTap != null) const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
