import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/Home/presentation/bloc/get_matched_therapists_bloc/get_matched_therapists_bloc.dart';
import 'package:front_end/features/Home/presentation/screens/home_app_bar.dart';
import 'package:front_end/features/Home/presentation/widgets/therapist_profile_widget.dart';
import 'package:front_end/features/chat/presentation/screens/chat_bot_room.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  final String role;
  const HomeScreen({super.key, required this.userId, required this.role});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.role == "patient") {
      BlocProvider.of<GetMatchedTherapistsBloc>(context)
          .add(GetMatchedTherapistsLoadEvent(patientId: widget.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarHome(userId: widget.userId, role: widget.role),
      body: Container(
        decoration: const BoxDecoration(),
        child: widget.role == "patient"
            ? BlocBuilder<GetMatchedTherapistsBloc, GetMatchedTherapistsState>(
                builder: (context, state) {
                  if (state is GetMatchedTherapistsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetMatchedTherapistsEmpty) {
                    return const Center(child: Text("No Therapists Found"));
                  } else if (state is GetMatchedTherapistsLoaded) {
                    return ListView.builder(
                        itemCount: state.therapistList.length,
                        itemBuilder: (context, index) {
                          final therapist = state.therapistList[index];
                          return TherapistProfileWidget(
                              therapist: therapist, upperContext: context);
                        });
                  } else {
                    return const Center(
                        child: Text("Error to load therapists"));
                  }
                },
              )
            : const Center(child: Text("Welcome Therapist")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showChatBot(context);
        },
        child: Image.asset("asset/image/chatbot_icon.png"),
      ),
    );
  }

  void _showChatBot(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const ChatBotScreen(),
        );
      },
    );
  }
}
