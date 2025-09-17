// lib/ui/organisms/calendar/month/month_modal.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ✅ on utilise la responsive modal
import 'package:timora/ui/molecules/responsive_modal.dart';
import 'package:timora/ui/atoms/button.dart' show ButtonType;
import 'package:timora/ui/molecules/event_list_item.dart';
import 'package:timora/ui/molecules/event_quick_create_modal.dart';

Future<void> showMonthModal({
  required BuildContext context,
  required String calendarId,
  required DateTime yearAnchor, // 1er janvier de l'année
  required int month,           // 1..12
  bool withShadow = true,       // 👈 contrôle ombres / “par-dessus l’UI”
}) async {
  final date  = DateTime(yearAnchor.year, month, 1);
  final loc   = Localizations.localeOf(context).toString();
  final title = toBeginningOfSentenceCase(DateFormat.yMMMM(loc).format(date)) ?? 'Mois';

  final result = await showResponsiveModal<String>(
    context: context,
    title: title,
    withShadow: withShadow, // 👈
    // On injecte un content widget custom
    content: _MonthModalContent(calendarId: calendarId, monthAnchor: date),
    // Actions bas de carte
    actions: const [
      ResponsiveModalAction<String>(
        label: 'Créer un événement',
        type: ButtonType.primary,
        result: 'create',
      ),
      ResponsiveModalAction<String>(
        label: 'Fermer',
        type: ButtonType.outlined,
        result: 'close',
      ),
    ],
  );

  if (result == 'create') {
    final created = await showQuickCreateEventModal(
      context: context,
      calendarId: calendarId,
      monthAnchor: date,
    );
    if (created == true) {
      // Réouvrir pour rafraîchir la liste
      await showMonthModal(
        context: context,
        calendarId: calendarId,
        yearAnchor: yearAnchor,
        month: month,
        withShadow: withShadow, // conserve le même mode d’affichage
      );
    }
  }
}

class _MonthModalContent extends StatefulWidget {
  final String calendarId;
  final DateTime monthAnchor;
  const _MonthModalContent({required this.calendarId, required this.monthAnchor});

  @override
  State<_MonthModalContent> createState() => _MonthModalContentState();
}

class _MonthModalContentState extends State<_MonthModalContent> {
  late Future<QuerySnapshot<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _queryMonth(widget.calendarId, widget.monthAnchor);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _queryMonth(
      String calendarId,
      DateTime anchor,
      ) {
    final start = DateTime(anchor.year, anchor.month, 1);
    final end = (anchor.month == 12)
        ? DateTime(anchor.year + 1, 1, 1)
        : DateTime(anchor.year, anchor.month + 1, 1);

    return FirebaseFirestore.instance
        .collection('events')
        .where('calendarId', isEqualTo: calendarId)
        .where('startAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('startAt', isLessThan: Timestamp.fromDate(end))
        .orderBy('startAt')
        .get();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text('Événements du mois', style: theme.textTheme.titleMedium),
        ),
        FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snap.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Erreur: ${snap.error}',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                ),
              );
            }
            final docs = snap.data?.docs ?? const [];
            if (docs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('Aucun événement ce mois-ci.', style: theme.textTheme.bodyMedium),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              separatorBuilder: (_, __) => const Divider(height: 12),
              itemBuilder: (context, i) {
                final d = docs[i].data();
                final start = (d['startAt'] is Timestamp)
                    ? (d['startAt'] as Timestamp).toDate()
                    : DateTime.tryParse('${d['startAt']}');
                final end = (d['endAt'] is Timestamp)
                    ? (d['endAt'] as Timestamp).toDate()
                    : DateTime.tryParse('${d['endAt']}');

                return EventListItem(
                  title: (d['title'] as String?) ?? '(Sans titre)',
                  startsAt: start,
                  endsAt: end,
                  location: d['location'] as String?,
                  notes: d['notes'] as String?,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
