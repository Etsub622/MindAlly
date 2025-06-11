import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/payment/presentation/widget/payment_form.dart';
import 'package:front_end/features/payment/presentation/widget/webview_screen.dart';
import 'package:front_end/features/profile_patient/domain/entities/user_entity.dart';
import '../bloc/payment_bloc.dart';

class PaymentScreen extends StatelessWidget {
  final String therapistEmail;
  final String patientEmail;
  final double sessionHour;
  final EventEntity event;
  final String? chatId;
  final UserEntity receiver;

  const PaymentScreen(
      {super.key,
      required this.therapistEmail,
      required this.patientEmail,
      required this.event,
      required this.sessionHour,
      this.chatId,
      required this.receiver});

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
                      event: event,
                      chatId: chatId,
                      receiver: receiver),
                ),
              );
            }
          },
          child: PaymentForm(
            therapistEmail: therapistEmail,
            patientEmail: patientEmail,
            sessionHour: sessionHour,
          ),
        ),
      ),
    );
  }
}
