
import 'package:flutter/material.dart';
import 'package:front_end/features/profile_therapist/domain/entities/update_therapist_entity.dart';
import 'package:go_router/go_router.dart';

class TherapistProfileWidget extends StatefulWidget {
  final UpdateTherapistEntity therapist;
  final BuildContext upperContext;
  const TherapistProfileWidget({super.key, required this.upperContext,required this.therapist});

  @override
  State<TherapistProfileWidget> createState() => _TherapistProfileWidgetState();
}

class _TherapistProfileWidgetState extends State<TherapistProfileWidget> {

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.only(bottom: 5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.none),
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 245, 233, 247)
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: 35,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(widget.therapist.profilePicture ?? ""),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.therapist.name ??  "", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(widget.therapist.modality ?? "", style: const TextStyle(fontSize: 15)),
                  Text("${widget.therapist.experienceYears ?? "No"} Years of Experience"),
                  
                ],
              )
            ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(widget.therapist.fee != null ? "\$${widget.therapist.fee}" : "No"),
            TextButton(
            onPressed: (){
              GoRouter.of(widget.upperContext).pushNamed('chatDetails', 
              queryParameters: {
                "chatId" : widget.therapist.chatId,
                "id" : widget.therapist.id,
                "name" : widget.therapist.name,
                "email" : widget.therapist.email,
                "hasPassword" : "false",
                "role" : "therapist"
              },
              );
                       
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 220, 125, 236)),
              shape: MaterialStateProperty.all( RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ))
            ),
            child: const Center(
              child: Text("Chat", style: TextStyle(color: Colors.purple),),
            )),
          ],)
          ],
      )
          ));
  }
}