import 'package:flutter/material.dart';

class ReminderWidget extends StatefulWidget {
  const ReminderWidget({Key? key}) : super(key: key);

  static Future<Map<String, dynamic>?> show(BuildContext context) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ReminderWidget(),
    );
  }

  @override
  State<ReminderWidget> createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  final TextEditingController _timeController = TextEditingController();

  final List<String> _dayShortNames = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  final List<String> _longNames = [
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
  ];
  List<bool> _selected = List.generate(7, (index) => false);

  bool get isEveryday => _selected.every((v) => v);
  bool get isWeekdays =>
      _selected.sublist(1, 6).every((v) => v) &&
          !_selected[0] &&
          !_selected[6];

  void selectEveryday() => setState(() => _selected = List.generate(7, (_) => true));
  void selectNone() => setState(() => _selected = List.generate(7, (_) => false));
  void selectWeekdays() =>
      setState(() => _selected = [false, true, true, true, true, true, false]);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
          maxWidth: 340,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Set Reminder',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Time',
                    prefixIcon: const Icon(Icons.access_time),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      _timeController.text = picked.format(context);
                    }
                  },
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Repeat",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  children: [
                    _buildQuickOption("Everyday", isEveryday, selectEveryday),
                    _buildQuickOption("Weekdays", isWeekdays, selectWeekdays),
                    _buildQuickOption("Clear", !_selected.contains(true), selectNone),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    children: List.generate(7, (index) {
                      final isSelected = _selected[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selected[index] = !_selected[index];
                          });
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: isSelected
                              ? const Color(0xFF2150FF)
                              : Colors.grey[200],
                          child: Text(
                            _dayShortNames[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2150FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    onPressed: () {
                      if (_timeController.text.isEmpty ||
                          !_selected.contains(true)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Please select time and at least one repeat day."),
                          ),
                        );
                        return;
                      }
                      final selectedDays = List.generate(7, (i) => _selected[i] ? _longNames[i] : null)
                          .whereType<String>()
                          .toList();

                      Navigator.of(context).pop({
                        'time': _timeController.text,
                        'repeat': selectedDays,
                      });
                    },
                    child: const Text('Save',
                        style: TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickOption(
      String label,
      bool selected,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2150FF) : Colors.grey[200],
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}