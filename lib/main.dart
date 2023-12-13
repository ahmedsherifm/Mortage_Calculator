// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mortgage Calculator',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final totalAmountController = TextEditingController();
  final downPaymentController = TextEditingController();
  final salaryController = TextEditingController();
  final interestRateController = TextEditingController();
  final yearsController = TextEditingController();

  double monthlyPayment = 0.0;

  @override
  void dispose() {
    totalAmountController.dispose();
    downPaymentController.dispose();
    salaryController.dispose();
    interestRateController.dispose();
    yearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mortgage Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: totalAmountController,
              decoration: InputDecoration(
                labelText: 'Total amount',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                ThousandsFormatter(),
              ],
            ),
            TextField(
              controller: downPaymentController,
              decoration: InputDecoration(
                labelText: 'Down payment',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                ThousandsFormatter(),
              ],
            ),
            TextField(
              controller: salaryController,
              decoration: InputDecoration(
                labelText: 'Salary',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                ThousandsFormatter(),
              ],
            ),
            TextField(
              controller: interestRateController,
              decoration: InputDecoration(
                labelText: 'Interest rate',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: yearsController,
              decoration: InputDecoration(
                labelText: 'Years',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                double totalAmount = double.parse(totalAmountController.text.replaceAll(',', ''));
                double downPayment = double.parse(downPaymentController.text.replaceAll(',', ''));
                double salary = double.parse(salaryController.text.replaceAll(',', ''));
                double interestRate = double.parse(interestRateController.text);
                int years = int.parse(yearsController.text);

                double principal = totalAmount - downPayment;
                double totalIncrease =
                    principal + (((principal * interestRate) / 100) * years);
                int numberOfPayments = years * 12;

                monthlyPayment = totalIncrease / numberOfPayments;

                if(monthlyPayment >= (salary * 0.7)) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Your monthly payment will be: \$${NumberFormat('#,##0.00').format(monthlyPayment)} \n\nSorry, you cannot afford this apartment.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
                else if (monthlyPayment > salary / 2) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Your monthly payment will be: \$${NumberFormat('#,##0.00').format(monthlyPayment)} \n\nSorry, it will be hard to keep paying this much.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Monthly Payment'),
                      content: Text(
                          'Your monthly payment will be: \$${NumberFormat('#,##0.00').format(monthlyPayment)}'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }
}

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final String newTextFormatted = NumberFormat('#,##0').format(int.tryParse(newValue.text.replaceAll(',', '')) ?? 0);
    return TextEditingValue(
      text: newTextFormatted,
      selection: TextSelection.collapsed(offset: newTextFormatted.length),
    );
  }
}