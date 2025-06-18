import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/presentation/bloc/add_event/add_events_bloc.dart';
import 'package:front_end/features/calendar/presentation/bloc/update_event/update_events_bloc.dart';
import 'package:front_end/features/profile_patient/domain/entities/user_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final EventEntity event;
  final String? chatId;
  final UserEntity receiver;
  final bool isCreate;
  final double price;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.event,
    this.chatId,
    required this.receiver,
    required this.isCreate,
    required this.price,
  });

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
          onPageStarted: (String url) {
            debugPrint('WebView: Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('WebView: Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error loading page: ${error.description}')),
              );
            }
          },
          onNavigationRequest: (NavigationRequest request) async {
            debugPrint('WebView: Navigation request to: ${request.url}');
            // Handle both test and production Chapa receipt URLs
            if (request.url.contains('checkout.chapa.co/checkout') &&
                request.url.contains('payment-receipt')) {
              if (!mounted) {
                debugPrint('WebView: Widget not mounted, skipping navigation');
                return NavigationDecision.prevent;
              }

              // Update event price
              widget.event.price = widget.price;

              // Dispatch appropriate bloc event
              if (widget.isCreate) {
                context.read<AddScheduledEventsBloc>().add(
                      AddScheduledEventsEvent(eventEntity: widget.event),
                    );
              } else {
                context.read<UpdateScheduledEventsBloc>().add(
                      UpdateScheduledEventsEvent(
                        eventEntity: widget.event.copyWith(status: "Confirmed"),
                      ),
                    );
              }

            
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment completed!')),
              );
               
              // Prevent WebView from navigating to the receipt page
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