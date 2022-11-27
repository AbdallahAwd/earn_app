import 'package:earnlia/core/resources/colors.dart';
import 'package:earnlia/core/resources/styles.dart';
import 'package:earnlia/core/utils/button.dart';
import 'package:earnlia/core/utils/conponents.dart';
import 'package:earnlia/core/utils/textformfield.dart';
import 'package:earnlia/features/home/presentation/cubit/home_cubit.dart';
import 'package:earnlia/features/home/presentation/widgets/CustomTab/custom_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Invite extends StatelessWidget {
  final HomeState state;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey();
  Invite({required this.state, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Text(
                'Invitation',
                style: AppStyles.normal(color: Colors.white),
              ),
              const Divider(),
              Text(
                'Invite a friend or someone from internet to earn money on Earnlia. You\'ll get 4500 C',
                style: AppStyles.small(color: Colors.white),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 225.h,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: AppColors.opWhite,
                    borderRadius: BorderRadius.circular(22)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Your referral code',
                      style: AppStyles.normal(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('Code', style: AppStyles.normal()),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 47,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: AppColors.opWhite),
                      child: Center(
                        child: Text(
                          state.user!.refferalCode,
                          style: AppStyles.normal(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            C.toast(text: 'Copied');
                            Clipboard.setData(
                                ClipboardData(text: state.user!.refferalCode));
                          },
                          borderRadius: BorderRadius.circular(22),
                          child: Row(
                            children: [
                              C.sweetIcon(
                                  iconColors: AppColors.gradiantColor,
                                  icon: const Icon(
                                    Icons.copy,
                                    color: Colors.white,
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Copy',
                                style: AppStyles.normal(),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            C.share(
                                title: 'Earnlia',
                                text:
                                    'Hey you can earn money from this app enter my code ${state.user!.refferalCode}',
                                link:
                                    'https://play.google.com/store/apps/details?id=com.amaa.earnlia');
                          },
                          borderRadius: BorderRadius.circular(22),
                          child: Row(
                            children: [
                              C.sweetIcon(
                                  iconColors: AppColors.gradiantColor,
                                  icon: const Icon(
                                    Icons.share_outlined,
                                    color: Colors.white,
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Share',
                                style: AppStyles.normal(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              CustomTab(
                state: state,
                op1: 'Invited',
                op2: 'Code',
                children: [
                  if (HomeCubit.get(context).invitedPeople.isEmpty)
                    Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 80,
                        ),
                        const Icon(
                          Icons.person_pin,
                          size: 80,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'No invited people',
                          style: AppStyles.normal(),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        DefButton(
                            label: 'Invite',
                            width: 170.w,
                            height: 45.h,
                            onPressed: () => C.share(
                                title: 'Earnlia\n',
                                text:
                                    'Hey you can earn money easily form this app using my code ${state.user!.refferalCode}',
                                link:
                                    'https://play.google.com/store/apps/details?id=com.amaa.earnlia'))
                      ],
                    ),
                  if (HomeCubit.get(context).invitedPeople.isNotEmpty)
                    ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: AppColors.opWhite,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        HomeCubit.get(context)
                                            .invitedPeople[index]
                                            .avatar),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    HomeCubit.get(context)
                                        .invitedPeople[index]
                                        .name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.normal(),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: HomeCubit.get(context).invitedPeople.length),
                  Form(
                    key: _form,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 341.w,
                          child: DefTextformfield(
                              hintText: 'Code',
                              icon: const Icon(Icons.code),
                              validator: (String? value) {
                                if (value == state.user!.refferalCode) {
                                  return 'This is your code ;)';
                                } else if (value!.isEmpty) {
                                  return 'Enter a code';
                                }
                                return null;
                              },
                              controller: _controller),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: state.user!.isInvited
                              ? () {
                                  C.toast(text: 'You\'re already invited');
                                }
                              : () {
                                  if (_form.currentState!.validate()) {
                                    HomeCubit.get(context).applyInvitation(
                                        _controller.text.replaceFirst('#', ''));
                                    _controller.clear();
                                  }
                                },
                          borderRadius: BorderRadius.circular(22),
                          child: Container(
                              width: 110.w,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                gradient: LinearGradient(
                                  colors: state.user!.isInvited
                                      ? [Colors.grey, Colors.grey[300]!]
                                      : AppColors.gradiantColor,
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Text(
                                'Apply',
                                style: AppStyles.normal(color: Colors.white),
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
