import 'package:crowd_snap/features/home/presentation/provider/filter_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';

class FilterBadges extends ConsumerWidget {
  const FilterBadges({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = [
      'Fecha de Inicio',
      'Fecha de Fin',
      'Ciudad',
      'Número de Posts'
    ];

    // Obtener la fecha actual
    final now = DateTime.now();

    // Calcular el lunes y el domingo de la semana actual
    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    final sunday = DateTime(now.year, now.month, now.day + (8 - now.weekday));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FilterBadge(
              filter: filter,
              onSelected: (value) async {
                HapticFeedback.mediumImpact();
                switch (value) {
                  case 'Fecha de Inicio':
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
                      ref
                          .read(startDateProvider.notifier)
                          .setStartDate(selectedDate);
                    }
                    break;
                  case 'Fecha de Fin':
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
                      ref
                          .read(endDateProvider.notifier)
                          .setEndDate(selectedDate);
                    }
                    break;
                  case 'Ciudad':
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
                              ref
                                  .read(cityProvider.notifier)
                                  .setCity('Barcelona');
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
                  case 'Número de Posts':
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
            ),
          );
        }).toList(),
      ),
    );
  }
}

class FilterBadge extends StatelessWidget {
  final String filter;
  final Function(String) onSelected;

  const FilterBadge({
    required this.filter,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(filter),
      child: Chip(
      label: Text(
        filter,
        style: const TextStyle(
        letterSpacing: -0.5, // Decrease letter spacing
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Increase border radius
      ),
      ),
    );
  }
}
