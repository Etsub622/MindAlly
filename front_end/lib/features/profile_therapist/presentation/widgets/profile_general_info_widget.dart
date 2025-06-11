import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/core/utils/constants.dart';
import 'package:go_router/go_router.dart';


enum LangugeModel { english, amharic}
class ProfilePageGeneralInfoWidget extends StatelessWidget {
  const ProfilePageGeneralInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return Container(
                      height: 210,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: SvgPicture.asset(AppImage.dashIcon),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Language",
                              style: Theme.of(context).textTheme.titleMedium

                              // TextStyle(
                              //   f
                              //     // fontWeight: FontWeight.w500,
                              //     color: AppColor.hexToColor(
                              //         "#404751"),
                              //     fontSize: 16),
                              ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("English",
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              Radio(
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                value: LangugeModel.english,
                                groupValue: LangugeModel.english,
                                onChanged: (value) {
                                  // context.read<GptModelsBloc>().add(
                                  //     CatchGptModelsEvent(
                                  //         chatModel: value.toString(),
                                  //         modeltype: "llm"));
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  });
            },
            leading: Icon(
              Icons.translate,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title:
                Text("Language", style: Theme.of(context).textTheme.bodyMedium
                    // TextStyle(
                    //     fontSize: 14,
                    //     color: AppColor.hexToColor("#181C21")),
                    ),
            trailing: SizedBox(
              width: width * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "English",
                    style: TextStyle(
                        fontSize: 12, color: AppColor.hexToColor("#73777F")),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppColor.hexToColor("#73777F"),
                  )
                ],
              ),
            ),
          ),
          ListTile(
              onTap: () {
              },
              leading: SvgPicture.asset(
                AppImage.themeIcon,

                // size: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: Text("Theme", style: Theme.of(context).textTheme.bodyMedium
                 
                  ),
              trailing: SizedBox(
                width: width * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Light",
                      style: TextStyle(
                          fontSize: 12, color: AppColor.hexToColor("#73777F")),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColor.hexToColor("#73777F"),
                    )
                  ],
                ),
              ),
            )
          ,ListTile(
            onTap: () {
              context.push(AppPath.therapistOnboard);
            },
            leading: Icon(
              Icons.filter_list,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: Text("Personalization",
                style: Theme.of(context).textTheme.bodyMedium
                ),
          ),
        ],
      ),
    );
  }
}
