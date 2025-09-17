import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timora/services/events_service.dart';
import 'package:timora/ui/molecules/responsive_modal.dart';
import 'package:timora/ui/atoms/button.dart' show ButtonType;

class _DateTimeField extends StatelessWidget {
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onPick;

  const _DateTimeField({
    required this.label,
    required this.value,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.localeOf(context).toString();
    String fmt(DateTime d) => '${DateFormat('EEE d MMM', loc).format(d)} • ${DateFormat('HH:mm', loc).format(d)}';

    return InkWell(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          locale: Locale(loc),
        );
        if (d == null) return;
        final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(value));
        if (t == null) return;
        onPick(DateTime(d.year, d.month, d.day, t.hour, t.minute));
      },
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(fmt(value)),
      ),
    );
  }
}

Future<bool?> showQuickCreateEventModal({
  required BuildContext context,
  required String calendarId,
  required DateTime monthAnchor,
}) async {
  final _formKey = GlobalKey<FormState>();
  final titleCtrl = TextEditingController();
  DateTime startAt = DateTime(monthAnchor.year, monthAnchor.month, monthAnchor.day, 9, 0);
  DateTime endAt   = startAt.add(const Duration(hours: 1));

  // ---- Contenu du formulaire (Widget) ----
  Widget form = Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: titleCtrl,
          decoration: const InputDecoration(
            labelText: 'Titre',
            hintText: 'Ex: Réunion projet',
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Titre requis' : null,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _DateTimeField(
                label: 'Début',
                value: startAt,
                onPick: (d) => startAt = d,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DateTimeField(
                label: 'Fin',
                value: endAt,
                onPick: (d) => endAt = d,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  // ---- Appel de la modale responsive ----
  final result = await showResponsiveModal<bool>(
    context: context,
    title: 'Nouvel événement',
    content: form,
    withShadow: true, // 👈 interaction → ombres activées
    actions: [
      const ResponsiveModalAction<bool>(
        label: 'Annuler',
        type: ButtonType.outlined,
        result: false,
      ),
      ResponsiveModalAction<bool>(
        label: 'Créer',
        type: ButtonType.primary,
        // on valide le form et on crée
        result: true,
      ),
    ],
  );

  // Si l’utilisateur a confirmé → on tente la création
  if (result == true) {
    if (!_formKey.currentState!.validate()) return false;
    await EventsService().addEvent(
      calendarId: calendarId,
      title: titleCtrl.text.trim(),
      startAt: startAt,
      endAt: endAt,
    );
    return true;
  }
  return false;
}
