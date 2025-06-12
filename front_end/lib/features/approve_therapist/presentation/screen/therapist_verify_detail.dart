// lib/features/approve_therapist/presentation/screen/therapist_verify_detail.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/approve_therapist/domain/entity/therapist_verify_entity.dart';
import 'package:front_end/features/approve_therapist/presentation/bloc/verify_bloc.dart';

class TherapistDetailPage extends StatefulWidget {
  final TherapistVerifyEntity therapist;

  const TherapistDetailPage({Key? key, required this.therapist})
      : super(key: key);

  @override
  _TherapistDetailPageState createState() => _TherapistDetailPageState();
}

class _TherapistDetailPageState extends State<TherapistDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleAction(BuildContext context, String action) {
    final comment = _commentController.text.trim();
    if (action == 'decline' && comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reason is required for rejection')),
      );
      return;
    }
    setState(() => _isLoading = true);
    if (action == 'approve') {
      context
          .read<VerifyBloc>()
          .add(ApproveTherapistEvent(id: widget.therapist.id));
    } else {
      context.read<VerifyBloc>().add(RejectTherapistEvent(
            id: widget.therapist.id,
            reason: comment,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.therapist.fullName,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocListener<VerifyBloc, VerifyState>(
        listener: (context, state) {
          if (state is VerifyActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
            context.read<VerifyBloc>().add(LoadTherapistsEvent());
          }
          if (state is VerifyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            setState(() => _isLoading = false);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.email, color: Color(0xff800080)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.therapist.email,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.work, color: Color(0xff800080)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.therapist.specialization,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Certificate',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: widget.therapist.certificate.isNotEmpty
                      ? Image.network(
                          widget.therapist.certificate,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: Icon(Icons.description,
                                size: 50, color: Colors.grey[600]),
                          ),
                        )
                      : Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: Icon(Icons.description,
                              size: 50, color: Colors.grey[600]),
                        ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    labelText: 'Comment (required for rejection)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _handleAction(context, 'approve'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Approve'),
                    ),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _handleAction(context, 'decline'),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Decline'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
