import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/utils/constants.dart';
import 'package:front_end/features/Home/presentation/bloc/get_all_therapists_bloc/get_all_therapists_bloc.dart';
import 'package:front_end/features/Home/presentation/bloc/get_matched_therapists_bloc/get_matched_therapists_bloc.dart';
import 'package:front_end/features/Home/presentation/screens/home_app_bar.dart';
import 'package:front_end/features/Home/presentation/widgets/therapist_profile_widget.dart';
import 'package:front_end/features/chat/presentation/screens/chat_bot_room.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  final String role;
  const HomeScreen({super.key, required this.userId, required this.role});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isNavigated = false; // Flag to prevent multiple taps

  @override
  void initState() {
    super.initState();
    if (widget.role == "patient") {
      context.read<GetMatchedTherapistsBloc>().add(GetMatchedTherapistsLoadEvent(patientId: widget.userId));
      context.read<GetAllTherapistsBloc>().add(GetAllTherapistsLoadEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarHome(userId: widget.userId, role: widget.role),
      body: widget.role == "patient" ? _buildPatientHome(context) : _buildTherapistHome(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showChatBot(context),
        backgroundColor: AppColor.hexToColor("#00538C"),
        child: Image.asset("asset/image/chatbot_icon.png", width: 24, height: 24),
      ),
    );
  }

  Widget _buildPatientHome(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      margin: EdgeInsets.only(top: 0.5),
      child: ListView(
        children: [
          // Header Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.hexToColor("#00538C"), AppColor.hexToColor("#00A1D6")],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: FadeInDown(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Find Your Perfect Therapist",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Connect with professionals tailored to your needs.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Suggested Therapists Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Suggested Therapists",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColor.hexToColor("#181C21"),
                  ),
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<GetMatchedTherapistsBloc, GetMatchedTherapistsState>(
            builder: (context, state) {
              if (state is GetMatchedTherapistsLoading) {
                return const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is GetMatchedTherapistsEmpty) {
                return const SizedBox(
                  height: 180,
                  child: Center(child: Text("No Suggested Therapists Found")),
                );
              } else if (state is GetMatchedTherapistsLoaded) {
                return SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: state.therapistList.length,
                    itemBuilder: (context, index) {
                      final therapist = state.therapistList[index];
                      return FadeInRight(
                        delay: Duration(milliseconds: index * 100),
                        child: Container(
                          width: 230,
                          margin: const EdgeInsets.only(right: 0),
                          child: TherapistProfileWidget(
                            therapist: therapist,
                            upperContext: context,
                            isCompact: false,
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const SizedBox(
                  height: 180,
                  child: Center(child: Text("Error Loading Suggested Therapists")),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          // All Therapists Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "All Therapists",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColor.hexToColor("#181C21"),
                  ),
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<GetAllTherapistsBloc, GetAllTherapistsState>(
            builder: (context, state) {
              if (state is GetAllTherapistsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetAllTherapistsEmpty) {
                return const Center(child: Text("No Therapists Available"));
              } else if (state is GetAllTherapistsLoaded) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.therapistList.length,
                  itemBuilder: (context, index) {
                    final therapist = state.therapistList[index];
                    return FadeInUp(
                      delay: Duration(milliseconds: index * 100),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TherapistProfileWidget(
                          therapist: therapist,
                          upperContext: context,
                          isCompact: false,
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text("Error Loading Therapists"));
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTherapistHome(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        margin: EdgeInsets.only(top: 16),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Welcome Section
            FadeInDown(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Welcome, Therapist!",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.hexToColor("#181C21"),
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Empower lives by sharing your expertise.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColor.hexToColor("#73777F"),
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Q&A Advertisement Card
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColor.hexToColor("#E6F0FA"), AppColor.hexToColor("#F5FAFF")],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Engage in Q&A!",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.hexToColor("#00538C"),
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Answer patient questions and share your expertise in our Q&A community.",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColor.hexToColor("#73777F"),
                                    ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          "asset/image/qa_ad.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _isNavigated
                            ? null
                            : () {
                                if (!_isNavigated) {
                                  setState(() => _isNavigated = true);
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    context.goNamed('home', extra: {'index': 1});
                                    setState(() => _isNavigated = false);
                                  });
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.hexToColor("#00538C"),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text("Get Involved"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Resource Advertisement Card
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColor.hexToColor("#E6F0FA"), AppColor.hexToColor("#F5FAFF")],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Share Resources!",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.hexToColor("#00538C"),
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Contribute articles, videos, and tools to support patient growth.",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColor.hexToColor("#73777F"),
                                    ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          "asset/image/resource_ad.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _isNavigated
                            ? null
                            : () {
                                if (!_isNavigated) {
                                  setState(() => _isNavigated = true);
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    context.goNamed('home', extra: {'index': 2});
                                    setState(() => _isNavigated = false);
                                  });
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.hexToColor("#00538C"),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text("Get Involved"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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