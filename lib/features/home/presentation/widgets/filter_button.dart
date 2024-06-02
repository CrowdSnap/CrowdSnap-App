import 'package:crowd_snap/features/home/presentation/provider/filter_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';

class FilterButton extends ConsumerWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener la fecha actual
    final now = DateTime.now();

    // Calcular el lunes y el domingo de la semana actual
    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    final sunday = DateTime(now.year, now.month, now.day + (8 - now.weekday));

    return PopupMenuButton<String>(
      onSelected: (value) async {
        HapticFeedback.mediumImpact();
        switch (value) {
          case 'startDate':
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: monday,
              firstDate: DateTime(2024, 05, 05),
              lastDate: DateTime(2100),
              locale: const Locale('es', 'ES'),
              initialEntryMode: DatePickerEntryMode.calendar,
              initialDatePickerMode: DatePickerMode.day,
            );
            if (selectedDate != null) {
              ref.read(startDateProvider.notifier).setStartDate(selectedDate);
            }
            break;
          case 'endDate':
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: sunday,
              firstDate: DateTime(2024, 05, 05),
              lastDate: DateTime(2100),
              locale: const Locale('es', 'ES'),
              initialEntryMode: DatePickerEntryMode.calendar,
              initialDatePickerMode: DatePickerMode.day,
            );
            if (selectedDate != null) {
              ref.read(endDateProvider.notifier).setEndDate(selectedDate);
            }
            break;
          case 'city':
            final selectedCity = await showDialog<String>(
              context: context,
              builder: (context) => SimpleDialog(
                title: const Text('Seleccionar ciudad'),
                children: [
                  SimpleDialogOption(
                    onPressed: () {
                      ref.read(cityProvider.notifier).setCity('Madrid');
                      Navigator.pop(context, 'Madrid');
                    },
                    child: const Text('Madrid'),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      ref.read(cityProvider.notifier).setCity('Barcelona');
                      Navigator.pop(context, 'Barcelona');
                    },
                    child: const Text('Barcelona'),
                  ),
                ],
              ),
            );
            if (selectedCity != null) {
              ref.read(cityProvider.notifier).setCity(selectedCity);
            }
            break;
          case 'numberOfPosts':
            int? selectedNumber = ref.read(numberOfPostsProvider);
            selectedNumber = await showDialog<int>(
              context: context,
              builder: (context) => StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Seleccionar número de posts'),
                    content: NumberPicker(
                      value: selectedNumber ?? 2,
                      minValue: 1,
                      maxValue: 10,
                      onChanged: (value) {
                        setState(() {
                          selectedNumber = value;
                        });
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(numberOfPostsProvider.notifier)
                              .setNumberOfPosts(selectedNumber!);
                          Navigator.pop(context);
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  );
                },
              ),
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'startDate',
          child: Text('Fecha de Inicio'),
        ),
        const PopupMenuItem<String>(
          value: 'endDate',
          child: Text('Fecha de Fin'),
        ),
        const PopupMenuItem<String>(
          value: 'city',
          child: Text('Ciudad'),
        ),
        const PopupMenuItem<String>(
          value: 'numberOfPosts',
          child: Text('Número de Posts'),
        ),
      ],
    );
  }
}
