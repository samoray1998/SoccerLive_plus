import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/matches_provider.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final matchesProvider = Provider.of<MatchesProvider>(context);
    final selectedDate = matchesProvider.selectedDate != null
        ? DateTime.parse(matchesProvider.selectedDate!)
        : DateTime.now();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            final previousDay = selectedDate.subtract(const Duration(days: 1));
            final formattedDate = DateFormat('yyyy-MM-dd').format(previousDay);
            matchesProvider.setSelectedDate(formattedDate);
          },
        ),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2023),
              lastDate: DateTime(2025),
            );
            if (picked != null) {
              final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
              matchesProvider.setSelectedDate(formattedDate);
            }
          },
          child: Column(
            children: [
              Text(
                DateFormat('EEEE').format(selectedDate),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                DateFormat('d MMM yyyy').format(selectedDate),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            final nextDay = selectedDate.add(const Duration(days: 1));
            final formattedDate = DateFormat('yyyy-MM-dd').format(nextDay);
            matchesProvider.setSelectedDate(formattedDate);
          },
        ),
      ],
    );
  }
}