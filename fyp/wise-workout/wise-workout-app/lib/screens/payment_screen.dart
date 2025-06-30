import 'package:flutter/material.dart';
import 'home_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String planName;
  final double price;

  const PaymentScreen({required this.planName, required this.price, Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';
  String cardHolder = '';
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'You\'re purchasing: ${widget.planName}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${widget.price.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.deepPurple),
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Card Holder Name'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter card holder name' : null,
                onSaved: (value) => cardHolder = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                maxLength: 16,
                validator: (value) =>
                value == null || value.length != 16 ? 'Enter valid card number' : null,
                onSaved: (value) => cardNumber = value!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                      maxLength: 5,
                      validator: (value) => value == null || !RegExp(r'^\d{2}/\d{2}$').hasMatch(value)
                          ? 'Invalid date'
                          : null,
                      onSaved: (value) => expiryDate = value!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'CVV'),
                      obscureText: true,
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                      value == null || value.length != 3 ? 'Invalid CVV' : null,
                      onSaved: (value) => cvv = value!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14)
                ),
                onPressed: isProcessing
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      isProcessing = true;
                    });
                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        isProcessing = false;
                      });
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          icon: const Icon(Icons.check_circle, color: Colors.green, size: 40),
                          title: const Text('Payment Successful!'),
                          content: Text('Thank you for purchasing the ${widget.planName} plan.'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => const HomeScreen(userName: '')),
                                      (Route<dynamic> route) => false,
                                );
                              },
                              child: const Text('OK'),
                            )
                          ],
                        ),
                      );
                    });
                  }
                },
                child: isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Pay \$${widget.price.toStringAsFixed(2)}'),
              )
            ],
          ),
        ),
      ),
    );
  }
}