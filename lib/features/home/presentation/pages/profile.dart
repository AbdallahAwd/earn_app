import 'package:earnlia/core/resources/colors.dart';
import 'package:earnlia/core/resources/strings.dart';
import 'package:earnlia/core/resources/styles.dart';
import 'package:earnlia/core/routes/route.dart';
import 'package:earnlia/core/utils/conponents.dart';
import 'package:earnlia/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final HomeState state;
  const Profile({Key? key, required this.state}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String usersAvatar;

  @override
  void initState() {
    usersAvatar = widget.state.user!.avatar;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: widget.state.user!.avatar != usersAvatar,
                    child: InkWell(
                      onTap: () {
                        HomeCubit.get(context).updateAvatar(usersAvatar);
                        C.toast(text: 'Done');
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Profile',
                    style: AppStyles.normal(color: Colors.white),
                  ),
                  PopupMenuButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'logout':
                          HomeCubit.get(context).logOut();
                          Navigator.pushReplacementNamed(
                              context, Routes.initialRoute);
                          break;
                        default:
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          height: 20,
                          value: 'logout',
                          child: Row(
                            children: const [
                              Icon(Icons.logout),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Logout'),
                            ],
                          ),
                        )
                      ];
                    },
                  )
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 50,
              ),
              CircleAvatar(
                backgroundColor: AppColors.opWhite,
                backgroundImage: NetworkImage(usersAvatar),
                radius: 70,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.state.user!.name,
                style: AppStyles.medium(color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                enabled: false,
                initialValue: widget.state.user!.email,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.opWhite,
                    prefixIcon: C.sweetIcon(
                        iconColors: AppColors.gradiantColor,
                        icon: const Icon(
                          Icons.email,
                          color: Colors.white,
                        )),
                    constraints: const BoxConstraints(
                        minHeight: 40, minWidth: double.infinity),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22))),
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'This email is not visible to any other user but you',
                    style: AppStyles.small(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 400,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          usersAvatar = AppStrings.avatars[index];
                        });
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(55),
                            border: Border.all(
                                color: usersAvatar == AppStrings.avatars[index]
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 5)),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.opWhite,
                          backgroundImage:
                              NetworkImage(AppStrings.avatars[index]),
                          onBackgroundImageError: (exception, stackTrace) {
                            C.toast(text: exception.toString());
                          },
                        ),
                      ),
                    );
                  },
                  itemCount: AppStrings.avatars.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
