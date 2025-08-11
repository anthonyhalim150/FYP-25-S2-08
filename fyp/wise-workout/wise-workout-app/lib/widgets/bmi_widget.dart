import 'package:flutter/material.dart';
import '../services/userPreferences_service.dart';

class BMIWidget extends StatefulWidget {
  const BMIWidget({Key? key}) : super(key: key);

  @override
  State<BMIWidget> createState() => _BMIWidgetState();
}

class _BMIWidgetState extends State<BMIWidget> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  double? _bmi;
  bool _isLoading = true;
  bool _isSaving = false;

  Map<String, dynamic> _fullPrefs = {};

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await UserPreferencesService.fetchPreferences();

      if (prefs != null) {
        setState(() {
          _fullPrefs = prefs;
          _heightController.text = prefs['height_cm']?.toString() ?? '';
          _weightController.text = prefs['weight_kg']?.toString() ?? '';
          _bmi = prefs['bmi_value'] != null
              ? (prefs['bmi_value'] as num).toDouble()
              : null;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading preferences: $e")),
      );
    }
  }

  void _calculateBMI() {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (height != null && weight != null && height > 0) {
      setState(() {
        _bmi = weight / ((height / 100) * (height / 100));
      });
    } else {
      setState(() {
        _bmi = null;
      });
    }
  }

  Future<void> _savePreferences() async {
    setState(() => _isSaving = true);

    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (height == null || weight == null) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid height and weight")),
      );
      return;
    }

    final bmiValue = weight / ((height / 100) * (height / 100));

    // Keep all old prefs and only replace what changed
    final updatedPrefs = Map<String, dynamic>.from(_fullPrefs)
      ..['height_cm'] = height
      ..['weight_kg'] = weight
      ..['bmi_value'] = bmiValue;

    final success = await UserPreferencesService.updatePreferences(updatedPrefs);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preferences updated successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update preferences")),
      );
    }

    setState(() {
      _isSaving = false;
      _bmi = bmiValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        TextField(
          controller: _heightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Height (cm)"),
          onChanged: (_) => _calculateBMI(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _weightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Weight (kg)"),
          onChanged: (_) => _calculateBMI(),
        ),
        const SizedBox(height: 20),
        Text(
          _bmi != null ? "BMI: ${_bmi!.toStringAsFixed(2)}" : "BMI: --",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isSaving ? null : _savePreferences,
          child: _isSaving
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          )
              : const Text("Save Changes"),
        )
      ],
    );
  }
}
