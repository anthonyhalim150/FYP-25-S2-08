import 'package:flutter/material.dart';

class WeekPickerDialog extends StatefulWidget {
  final DateTimeRange? initialRange;

  const WeekPickerDialog({super.key, this.initialRange});

  @override
  State<WeekPickerDialog> createState() => _WeekPickerDialogState();
}

class _WeekPickerDialogState extends State<WeekPickerDialog> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialRange != null) {
      _startDate = widget.initialRange!.start;
      _endDate = widget.initialRange!.end;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Select Week", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _startDate = picked;
                        _endDate = picked.add(const Duration(days: 6));
                      });
                    }
                  },
                  child: Column(
                    children: [
                      const Text("Start Date"),
                      Text(
                        _startDate != null
                            ? "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}"
                            : "Pick Date",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward),
              Expanded(
                child: Column(
                  children: [
                    const Text("End Date"),
                    Text(
                      _endDate != null
                          ? "${_endDate!.day}/${_endDate!.month}/${_endDate!.year}"
                          : "-",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: (_startDate != null)
                ? () => Navigator.pop(context, DateTimeRange(start: _startDate!, end: _endDate!))
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Confirm"),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
