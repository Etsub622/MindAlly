import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/payment/presentation/widget/payment_form.dart';
import 'package:front_end/features/payment/presentation/widget/webview_screen.dart';
import 'package:front_end/features/profile_patient/domain/entities/user_entity.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/payment_bloc.dart';

class PaymentScreen extends StatefulWidget {
  final String therapistEmail;
  final String patientEmail;
  final double sessionHour;
  final EventEntity event;
  final String? chatId;
  final UserEntity receiver;
  final bool isCreate;

  const PaymentScreen({
    super.key,
    required this.therapistEmail,
    required this.patientEmail,
    required this.event,
    required this.sessionHour,
    this.chatId,
    required this.receiver,
    required this.isCreate,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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

  Widget _buildShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(height: 20, width: 250, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(height: 50, width: double.infinity, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(height: 45, width: double.infinity, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewScreen(
                    url: state.checkoutUrl,
                    event: widget.event,
                    chatId: widget.chatId,
                    receiver: widget.receiver,
                    isCreate: widget.isCreate,
                    price: widget.sessionHour * double.parse(_pricePerHrController.text),
                  ),
                ),
              );
            }
          },
          child: BlocBuilder<PaymentBloc, PaymentState>(
            builder: (context, state) {
              if (state is PaymentLoading) {
                return _buildShimmer();
              }

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
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Initiate Payment'),
                    ),
                    if (state is PaymentFailure)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          state.error,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
