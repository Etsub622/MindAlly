import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/payment_bloc.dart';

class PaymentForm extends StatefulWidget {
  final String therapistEmail;
  final String patientEmail;
  final double sessionHour;

  const PaymentForm({super.key, required this.therapistEmail, required this.patientEmail, required this.sessionHour});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _pricePerHrController = TextEditingController();

  @override
  void dispose() {
    _pricePerHrController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final bloc = context.read<PaymentBloc>();
      bloc.add(InitiatePaymentEvent(
        therapistEmail: widget.therapistEmail,
        patientEmail: widget.patientEmail,
        sessionHour: widget.sessionHour,
        pricePerHr: double.parse(_pricePerHrController.text),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Please insert the price per hour for the session. The session hour is ${widget.sessionHour} hours."),
          TextFormField(
            controller: _pricePerHrController,
            decoration: const InputDecoration(labelText: 'Price per Hour (ETB)'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              if (double.tryParse(value) == null || double.parse(value) <= 0) {
                return 'Must be a positive number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          BlocBuilder<PaymentBloc, PaymentState>(
            builder: (context, state) {
              if (state is PaymentLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Initiate Payment'),
              );
            },
          ),
          BlocBuilder<PaymentBloc, PaymentState>(
            builder: (context, state) {
              if (state is PaymentFailure) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    state.error,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return const SizedBox.shrink(); // Return empty widget if not PaymentFailure
            },
          ),
        ],
          
      ),
    );
  }
}