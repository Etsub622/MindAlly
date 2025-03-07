
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/profile/presentation/bloc/user_profile_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:front_end/features/profile/presentation/screens/update_profile_screen.dart';


class AppbarHome extends StatefulWidget implements PreferredSizeWidget {
  final BuildContext context;
  const AppbarHome({super.key, required this.context});
  @override
  Size get preferredSize => const Size.fromHeight(110);
   
  @override
  State<AppbarHome> createState() => _AppbarHomeState();
}

class _AppbarHomeState extends State<AppbarHome> {

 @override
 initState() {
    super.initState();
    context.read<UserProfileBloc>().add(GetUserProfileEvent());
  }
  String cutUsername(String username) {
    if (username.length > 10) {
      username = '${username.substring(0, 10)}...';
    }
    return username;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
      statusBarColor: Theme.of(context).colorScheme.surface,
    ));
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 45, bottom: 16, right: 8),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: 
            BlocBuilder<UserProfileBloc, UserprofileState>(
                builder: (context, state) {
              
              if (state is UserprofileLoadedState && state.status == UserStatus.loaded){
                  String userName = state.userEntity!.fullName;
                  String profilePicture = state.userEntity!.profileImage;
                  String hasPassword = state.userEntity?.password != null ? 'true' : 'false';
                  String email = state.userEntity!.email;
                return 
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateProfileNew(
                                    username: userName,
                                    profilePicture: profilePicture,
                                    hasPassword: hasPassword,
                                    email: email)
                                    )
                                    );
                      },
                      child: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).brightness != Brightness.dark
                                ? const Color(0xeEBEEF55)
                                : Colors.black,
                        backgroundImage: CachedNetworkImageProvider(
                            profilePicture,
                            errorListener: (context) {
                          const Icon(
                            Icons.error,
                            color: Colors.red,
                          );
                        }),
                        radius: 25,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text('👋',
                            style: Theme.of(context).textTheme.bodySmall),
                        Text('Hello, $userName',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                );
              
              } else {
                return Container();
              }
            }),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }

  // Future<dynamic> ShareBottomSheet(BuildContext context) {
  //   // String selectedAvatarUrl = widget.avatarUrl;
  //   return showModalBottomSheet(
  //       useSafeArea: true,
  //       isScrollControlled: true,
  //       // showDragHandle: true,
  //       backgroundColor: Theme.of(context).colorScheme.surface,
  //       context: context,
  //       builder: (context) {
  //         print('called builder');
  //         // print(widget.avatarUrl);
  //         return const GalleryModalBottomsheet();
  //       });
  // }
}
