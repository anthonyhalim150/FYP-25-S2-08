import 'package:flutter/material.dart';
import '../widgets/bmi_widget.dart';

class BMIScreen extends StatelessWidget {
  const BMIScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: BMIWidget(),
      ),
    );
  }
}
