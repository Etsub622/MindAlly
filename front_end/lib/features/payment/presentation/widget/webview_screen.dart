import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/presentation/bloc/add_event/add_events_bloc.dart';
import 'package:front_end/features/calendar/presentation/bloc/update_event/update_events_bloc.dart';
import 'package:front_end/features/chat/presentation/screens/chat_page.dart';
import 'package:front_end/features/profile_patient/domain/entities/user_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:front_end/core/routes/app_path.dart';


class WebViewScreen extends StatefulWidget {
  final String url;
  EventEntity event;
  final String? chatId;
  final UserEntity receiver;
  final bool isCreate;
  final double price;

  WebViewScreen({super.key, required this.url, required this.event, this.chatId, required this.receiver, required this.isCreate, required  this.price});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading page: ${error.description}')),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://checkout.chapa.co/checkout/test-payment-receipt')) {
              widget.event.price = widget.price;

              widget.isCreate ?
              
              context.read<AddScheduledEventsBloc>().add(
                                          AddScheduledEventsEvent(eventEntity: widget.event),
                                        )
                              :
                  context.read<UpdateScheduledEventsBloc>().add(
                          UpdateScheduledEventsEvent(
                            eventEntity: widget.event.copyWith(status: "Confirmed"),
                          ),
                        );
             
              // context.go(AppPath.calendar);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment completed!')),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Payment')),
      body: WebViewWidget(controller: _controller),
    );
  }
}