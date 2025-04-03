import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/get_patient_bloc/get_patient_bloc.dart';
import 'package:front_end/features/profile_patient/presentation/screens/manage_patient_screen.dart';
import 'package:front_end/features/profile_patient/presentation/screens/update_profile_screen.dart';
import 'package:front_end/features/profile_patient/presentation/widgets/profile_about_info.dart';
import 'package:front_end/features/profile_patient/presentation/widgets/profile_general_info_widget.dart';
import 'package:front_end/features/profile_patient/presentation/widgets/profile_others.info.dart';


class PatientProfilePageBody extends StatefulWidget {
  final UpdatePatientProfileNew profile;
  final String patientId;

  const PatientProfilePageBody({super.key, required this.profile, required this.patientId});

  @override
  _PatientProfilePageState createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePageBody> {
  @override
  void initState() {
    super.initState();
    context.read<PatientProfileBloc>().add(GetPatientLoadEvent(patientId: widget.patientId));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;

    return BlocBuilder<PatientProfileBloc, GetPatientState>(
        builder: (BuildContext context, GetPatientState state) {
      if (state is GetPatientLoaded) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipOval(
                    child: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainerLow,
                      // AppColor.hexToColor("#F1F3FB"),
                      radius: 30,
                      child: CachedNetworkImage(
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        imageUrl: state.patient.profilePicture ?? "",
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: width * .9,
                  child: Center(
                    child: Text(
                      state.patient.name,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: SizedBox(
                    // width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your button action here
                        // context.go(AppRoutes.login);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManagePatientScreen(
                                    userName: state.patient.name,
                                    email: state.patient.email,
                                    patientId: state.patient.id,
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        foregroundColor:
                            Theme.of(context).colorScheme.primary, // Text color
                        backgroundColor:
                            Theme.of(context).colorScheme.surface, // Text color
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 0.5,
                              color: Theme.of(context).colorScheme.outline),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: Text(
                        'Manage Account',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('General', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(
                  height: 10,
                ),
                const ProfilePageGeneralInfoWidget(),
                const SizedBox(
                  height: 20,
                ),
                // Text('Others', style: Theme.of(context).textTheme.bodySmall
                //     // TextStyle(
                //     //     fontSize: 14,
                //     //     color: AppColor.hexToColor("#181C21")),
                //     ),
                // const SizedBox(
                //   height: 10,
                // ),
                // const ProfileOthersInfo(),
                const SizedBox(
                  height: 20,
                ),
                Text('About', style: Theme.of(context).textTheme.bodySmall

                    ),
                const SizedBox(
                  height: 10,
                ),
                const ProfileAboutInfo(),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SizedBox(
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerLow,
                  // AppColor.hexToColor("#F1F3FB"),
                  radius: 30,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.profile.profilePicture,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: width * .9,
                child: Center(
                  child: Text(
                    widget.profile.username,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: SizedBox(
                  // width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your button action here
                      // context.go(AppRoutes.login);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManagePatientScreen(
                                  userName: widget.profile.username,
                                  email: widget.profile.email,
                                  patientId: widget.patientId,
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      foregroundColor:
                          Theme.of(context).colorScheme.primary, // Text color
                      backgroundColor:
                          Theme.of(context).colorScheme.surface, // Text color
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 0.5,
                            color: Theme.of(context).colorScheme.outline),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: Text(
                      'Manage Account',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text('General', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(
                height: 10,
              ),
              const ProfilePageGeneralInfoWidget(),
              const SizedBox(
                height: 20,
              ),
              Text('Others', style: Theme.of(context).textTheme.bodySmall
                  // TextStyle(
                  //     fontSize: 14,
                  //     color: AppColor.hexToColor("#181C21")),
                  ),
              const SizedBox(
                height: 10,
              ),
              const ProfileOthersInfo(),
              const SizedBox(
                height: 20,
              ),
              Text('About', style: Theme.of(context).textTheme.bodySmall
                  // TextStyle(
                  //     fontSize: 14,
                  //     color: AppColor.hexToColor("#181C21")),

                  ),
              const SizedBox(
                height: 10,
              ),
              const ProfileAboutInfo(),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      );
    });
  }
}
