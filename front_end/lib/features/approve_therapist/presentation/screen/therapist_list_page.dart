import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/approve_therapist/domain/entity/therapist_verify_entity.dart';
import 'package:front_end/features/approve_therapist/presentation/bloc/verify_bloc.dart';
import 'package:front_end/features/approve_therapist/presentation/widget/therapist_card.dart';

class TherapistListPage extends StatefulWidget {
  const TherapistListPage({Key? key}) : super(key: key);

  @override
  State<TherapistListPage> createState() => _TherapistListPageState();
}

class _TherapistListPageState extends State<TherapistListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Unapproved Therapists',
              style: TextStyle(color: Colors.white),
            ),
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 25,
              ),
              tooltip: 'Refresh',
              onPressed: () {
                context.read<VerifyBloc>().add(LoadTherapistsEvent());
              },
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocConsumer<VerifyBloc, VerifyState>(
        listener: (context, state) {
          if (state is VerifyActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.read<VerifyBloc>().add(LoadTherapistsEvent());
          }
          if (state is VerifyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is VerifyInitial) {
            context.read<VerifyBloc>().add(LoadTherapistsEvent());
            return const Center(child: CircularProgressIndicator());
          }
          if (state is VerifyLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is VerifyLoaded) {
            return state.therapists.isEmpty
                ? const Center(child: Text('No unapproved therapists'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.therapists.length,
                    itemBuilder: (context, index) {
                      return TherapistCard(therapist: state.therapists[index]);
                    },
                  );
          }
          if (state is VerifyError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  TextButton(
                    onPressed: () =>
                        context.read<VerifyBloc>().add(LoadTherapistsEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Unexpected state'));
        },
      ),
    );
  }
}
